//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Foundation Models Playground open source project
//
// Copyright (c) 2025 Amazon.com, Inc. or its affiliates
//                    and the Swift Foundation Models Playground project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of Swift Foundation Models Playground project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

@preconcurrency import AWSBedrock
@preconcurrency import AWSBedrockRuntime
import AWSClientRuntime
import AWSSDKIdentity
import Foundation
import Logging
import SwiftBedrockTypes

public struct SwiftBedrock: Sendable {
    let region: Region
    let logger: Logger
    private let bedrockClient: BedrockClientProtocol
    private let bedrockRuntimeClient: BedrockRuntimeClientProtocol

    // MARK: - Initialization

    /// Initializes a new SwiftBedrock instance
    /// - Parameters:
    ///   - region: The AWS region to use (defaults to .useast1)
    ///   - logger: Optional custom logger instance
    ///   - bedrockClient: Optional custom Bedrock client
    ///   - bedrockRuntimeClient: Optional custom Bedrock Runtime client
    ///   - useSSO: Whether to use SSO authentication (defaults to false)
    /// - Throws: Error if client initialization fails
    public init(
        region: Region = .useast1,
        logger: Logger? = nil,
        bedrockClient: BedrockClientProtocol? = nil,
        bedrockRuntimeClient: BedrockRuntimeClientProtocol? = nil,
        useSSO: Bool = false
    ) async throws {
        self.logger = logger ?? SwiftBedrock.createLogger("swiftbedrock.service")
        self.logger.trace(
            "Initializing SwiftBedrock",
            metadata: ["region": .string(region.rawValue)]
        )
        self.region = region

        if bedrockClient != nil {
            self.logger.trace("Using supplied bedrockClient")
            self.bedrockClient = bedrockClient!
        } else {
            self.logger.trace("Creating bedrockClient")
            self.bedrockClient = try await SwiftBedrock.createBedrockClient(
                region: region,
                useSSO: useSSO
            )
            self.logger.trace(
                "Created bedrockClient",
                metadata: ["useSSO": "\(useSSO)"]
            )
        }
        if bedrockRuntimeClient != nil {
            self.logger.trace("Using supplied bedrockRuntimeClient")
            self.bedrockRuntimeClient = bedrockRuntimeClient!
        } else {
            self.logger.trace("Creating bedrockRuntimeClient")
            self.bedrockRuntimeClient = try await SwiftBedrock.createBedrockRuntimeClient(
                region: region,
                useSSO: useSSO
            )
            self.logger.trace(
                "Created bedrockRuntimeClient",
                metadata: ["useSSO": "\(useSSO)"]
            )
        }
        self.logger.trace(
            "Initialized SwiftBedrock",
            metadata: ["region": .string(region.rawValue)]
        )
    }

    // MARK: - Private Helpers

    /// Creates Logger using either the loglevel saved as en environment variable `SWIFT_BEDROCK_LOG_LEVEL` or with default `.trace`
    static private func createLogger(_ name: String) -> Logger {
        var logger: Logger = Logger(label: name)
        logger.logLevel =
            ProcessInfo.processInfo.environment["SWIFT_BEDROCK_LOG_LEVEL"].flatMap {
                Logger.Level(rawValue: $0.lowercased())
            } ?? .trace  // FIXME: trace for me, later .info
        return logger
    }

    /// Creates a BedrockClient
    static private func createBedrockClient(
        region: Region,
        useSSO: Bool = false
    ) async throws
        -> BedrockClientProtocol
    {
        let config = try await BedrockClient.BedrockClientConfiguration(
            region: region.rawValue
        )
        if useSSO {
            config.awsCredentialIdentityResolver = try SSOAWSCredentialIdentityResolver()
        }
        return BedrockClient(config: config)
    }

    /// Creates a BedrockRuntimeClient
    static private func createBedrockRuntimeClient(
        region: Region,
        useSSO: Bool = false
    )
        async throws
        -> BedrockRuntimeClientProtocol
    {
        let config =
            try await BedrockRuntimeClient.BedrockRuntimeClientConfiguration(
                region: region.rawValue
            )
        if useSSO {
            config.awsCredentialIdentityResolver = try SSOAWSCredentialIdentityResolver()
        }
        return BedrockRuntimeClient(config: config)
    }

    // MARK: Public Methods

    /// Lists all available foundation models from Amazon Bedrock
    /// - Throws: SwiftBedrockError.invalidResponse
    /// - Returns: An array of ModelInfo objects containing details about each available model.
    public func listModels() async throws -> [ModelInfo] {
        logger.trace("Fetching foundation models")
        do {
            let response = try await bedrockClient.listFoundationModels(
                input: ListFoundationModelsInput()
            )
            guard let models = response.modelSummaries else {
                logger.trace("Failed to extract modelSummaries from response")
                throw SwiftBedrockError.invalidSDKResponse(
                    "Something went wrong while extracting the modelSummaries from the response."
                )
            }
            var modelsInfo: [ModelInfo] = []
            modelsInfo = models.compactMap { (model) -> ModelInfo? in
                guard let modelId = model.modelId,
                    let providerName = model.providerName,
                    let modelName = model.modelName
                else {
                    logger.trace("Skipping model due to missing required properties")
                    return nil
                }
                return ModelInfo(
                    modelName: modelName,
                    providerName: providerName,
                    modelId: modelId
                )
            }
            logger.trace(
                "Fetched foundation models",
                metadata: [
                    "models.count": "\(modelsInfo.count)",
                    "models.content": .string(String(describing: modelsInfo)),
                ]
            )
            return modelsInfo
        } catch {
            logger.trace("Error while completing text", metadata: ["error": "\(error)"])
            throw error
        }
    }

    /// Generates a text completion using a specified model.
    /// - Parameters:
    ///   - text: the text to be completed
    ///   - model: the BedrockModel that will be used to generate the completion
    ///   - maxTokens: the maximum amount of tokens in the completion (must be at least 1) optional, default 300
    ///   - temperature: the temperature used to generate the completion (must be a value between 0 and 1) optional, default 0.6
    /// - Throws: SwiftBedrockError.invalidMaxTokens if maxTokens is less than 1
    ///           SwiftBedrockError.invalidTemperature if temperature is not between 0 and 1
    ///           SwiftBedrockError.invalidPrompt if the prompt is empty
    ///           SwiftBedrockError.invalidResponse if the response body is missing
    /// - Returns: a TextCompletion object containing the generated text from the model
    public func completeText(
        _ prompt: String,
        with model: BedrockModel,
        maxTokens: Int? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        topK: Int? = nil,
        stopSequences: [String]? = nil
    ) async throws -> TextCompletion {
        logger.trace(
            "Generating text completion",
            metadata: [
                "model.id": .string(model.id),
                "model.modality": .string(model.modality.getName()),
                "prompt": .string(prompt),
                "maxTokens": .stringConvertible(maxTokens ?? "not defined"),
                "temperature": .stringConvertible(temperature ?? "not defined"),
                "topP": .stringConvertible(topP ?? "not defined"),
                "topK": .stringConvertible(topK ?? "not defined"),
                "stopSequences": .stringConvertible(stopSequences ?? "not defined"),
            ]
        )
        do {
            let modality = try model.getTextModality()
            try validateTextCompletionParams(
                modality: modality,
                prompt: prompt,
                maxTokens: maxTokens,
                temperature: temperature,
                topP: topP,
                topK: topK,
                stopSequences: stopSequences
            )

            logger.trace(
                "Creating InvokeModelRequest",
                metadata: [
                    "model": .string(model.id),
                    "prompt": "\(prompt)",
                ]
            )
            let request: InvokeModelRequest = try InvokeModelRequest.createTextRequest(
                model: model,
                prompt: prompt,
                maxTokens: maxTokens,
                temperature: temperature,
                topP: topP,
                topK: topK,
                stopSequences: stopSequences
            )
            let input: InvokeModelInput = try request.getInvokeModelInput()
            logger.trace(
                "Sending request to invokeModel",
                metadata: [
                    "model": .string(model.id), "request": .string(String(describing: input)),
                ]
            )

            let response = try await self.bedrockRuntimeClient.invokeModel(input: input)
            logger.trace(
                "Received response from invokeModel",
                metadata: [
                    "model": .string(model.id), "response": .string(String(describing: response)),
                ]
            )

            guard let responseBody = response.body else {
                logger.trace(
                    "Invalid response",
                    metadata: [
                        "response": .string(String(describing: response)),
                        "hasBody": .stringConvertible(response.body != nil),
                    ]
                )
                throw SwiftBedrockError.invalidSDKResponse(
                    "Something went wrong while extracting body from response."
                )
            }
            if let bodyString = String(data: responseBody, encoding: .utf8) {
                logger.trace("Extracted body from response", metadata: ["response.body": "\(bodyString)"])
            }

            let invokemodelResponse: InvokeModelResponse = try InvokeModelResponse.createTextResponse(
                body: responseBody,
                model: model
            )
            logger.trace(
                "Generated text completion",
                metadata: [
                    "model": .string(model.id), "response": .string(String(describing: invokemodelResponse)),
                ]
            )
            return try invokemodelResponse.getTextCompletion()
        } catch {
            logger.trace("Error while completing text", metadata: ["error": "\(error)"])
            throw error
        }
    }

    /// Generates 1 to 5 image(s) from a text prompt using a specific model.
    /// - Parameters:
    ///   - prompt: the prompt describing the image that should be generated
    ///   - model: the BedrockModel that will be used to generate the image
    ///   - nrOfImages: the number of images that will be generated (must be a number between 1 and 5) optional, default 3
    /// - Throws: SwiftBedrockError.invalidNrOfImages if nrOfImages is not between 1 and 5
    ///           SwiftBedrockError.invalidPrompt if the prompt is empty
    ///           SwiftBedrockError.invalidResponse if the response body is missing
    /// - Returns: a ImageGenerationOutput object containing an array of generated images
    public func generateImage(
        _ prompt: String,
        with model: BedrockModel,
        negativePrompt: String? = nil,
        nrOfImages: Int? = nil,
        cfgScale: Double? = nil,
        seed: Int? = nil,
        quality: ImageQuality? = nil,
        resolution: ImageResolution? = nil
    ) async throws -> ImageGenerationOutput {
        logger.trace(
            "Generating image(s)",
            metadata: [
                "model.id": .string(model.id),
                "model.modality": .string(model.modality.getName()),
                "prompt": .string(prompt),
                "negativePrompt": .stringConvertible(negativePrompt ?? "not defined"),
                "nrOfImages": .stringConvertible(nrOfImages ?? "not defined"),
                "cfgScale": .stringConvertible(cfgScale ?? "not defined"),
                "seed": .stringConvertible(seed ?? "not defined"),
            ]
        )
        do {
            let modality = try model.getImageModality()
            try validateImageGenerationParams(
                modality: modality,
                nrOfImages: nrOfImages,
                cfgScale: cfgScale,
                resolution: resolution,
                seed: seed
            )
            let textToImageModality = try model.getTextToImageModality()
            try validateTextToImageParams(modality: textToImageModality, prompt: prompt, negativePrompt: negativePrompt)

            let request: InvokeModelRequest = try InvokeModelRequest.createTextToImageRequest(
                model: model,
                prompt: prompt,
                negativeText: negativePrompt,
                nrOfImages: nrOfImages,
                cfgScale: cfgScale,
                seed: seed,
                quality: quality,
                resolution: resolution
            )
            let input: InvokeModelInput = try request.getInvokeModelInput()
            logger.trace(
                "Sending request to invokeModel",
                metadata: [
                    "model": .string(model.id), "request": .string(String(describing: input)),
                ]
            )
            let response = try await self.bedrockRuntimeClient.invokeModel(input: input)
            guard let responseBody = response.body else {
                logger.trace(
                    "Invalid response",
                    metadata: [
                        "response": .string(String(describing: response)),
                        "hasBody": .stringConvertible(response.body != nil),
                    ]
                )
                throw SwiftBedrockError.invalidSDKResponse(
                    "Something went wrong while extracting body from response."
                )
            }
            let invokemodelResponse: InvokeModelResponse = try InvokeModelResponse.createImageResponse(
                body: responseBody,
                model: model
            )
            return try invokemodelResponse.getGeneratedImage()
        } catch {
            logger.trace("Error while generating image", metadata: ["error": "\(error)"])
            throw error
        }
    }

    /// Generates 1 to 5 imagevariation(s) from reference images and a text prompt using a specific model.
    /// - Parameters:
    ///   - image: the reference images
    ///   - prompt: the prompt describing the image that should be generated
    ///   - model: the BedrockModel that will be used to generate the image
    ///   - nrOfImages: the number of images that will be generated (must be a number between 1 and 5) optional, default 3
    /// - Throws: SwiftBedrockError.invalidNrOfImages if nrOfImages is not between 1 and 5
    ///           SwiftBedrockError.similarity if similarity is not between 0.2 - 1.0
    ///           SwiftBedrockError.invalidPrompt if the prompt is empty
    ///           SwiftBedrockError.invalidResponse if the response body is missing
    /// - Returns: a ImageGenerationOutput object containing an array of generated images
    public func generateImageVariation(
        images: [String],
        prompt: String,
        with model: BedrockModel,
        negativePrompt: String? = nil,
        similarity: Double? = nil,
        nrOfImages: Int? = nil,
        cfgScale: Double? = nil,
        seed: Int? = nil,
        quality: ImageQuality? = nil,
        resolution: ImageResolution? = nil
    ) async throws -> ImageGenerationOutput {
        logger.trace(
            "Generating image(s) from reference image",
            metadata: [
                "model.id": .string(model.id),
                "model.modality": .string(model.modality.getName()),
                "prompt": .string(prompt),
                "nrOfImages": .stringConvertible(nrOfImages ?? "not defined"),
                "similarity": .stringConvertible(similarity ?? "not defined"),
                "negativePrompt": .stringConvertible(negativePrompt ?? "not defined"),
                "cfgScale": .stringConvertible(cfgScale ?? "not defined"),
                "seed": .stringConvertible(seed ?? "not defined"),
            ]
        )
        do {
            let modality = try model.getImageModality()
            try validateImageGenerationParams(
                modality: modality,
                nrOfImages: nrOfImages,
                cfgScale: cfgScale,
                resolution: resolution,
                seed: seed
            )
            let imageVariationModality = try model.getImageVariationModality()
            try validateImageVariationParams(
                modality: imageVariationModality,
                images: images,
                prompt: prompt,
                similarity: similarity,
                negativePrompt: negativePrompt
            )
            let request: InvokeModelRequest = try InvokeModelRequest.createImageVariationRequest(
                model: model,
                prompt: prompt,
                negativeText: negativePrompt,
                images: images,
                similarity: similarity,
                nrOfImages: nrOfImages,
                cfgScale: cfgScale,
                seed: seed,
                quality: quality,
                resolution: resolution
            )
            let input: InvokeModelInput = try request.getInvokeModelInput()
            logger.trace(
                "Sending request to invokeModel",
                metadata: [
                    "model": .string(model.id), "request": .string(String(describing: input)),
                ]
            )
            let response = try await self.bedrockRuntimeClient.invokeModel(input: input)
            guard let responseBody = response.body else {
                logger.trace(
                    "Invalid response",
                    metadata: [
                        "response": .string(String(describing: response)),
                        "hasBody": .stringConvertible(response.body != nil),
                    ]
                )
                throw SwiftBedrockError.invalidSDKResponse(
                    "Something went wrong while extracting body from response."
                )
            }
            let invokemodelResponse: InvokeModelResponse = try InvokeModelResponse.createImageResponse(
                body: responseBody,
                model: model
            )
            return try invokemodelResponse.getGeneratedImage()
        } catch {
            logger.trace("Error while generating image variations", metadata: ["error": "\(error)"])
            throw error
        }
    }

    /// Use Converse API
    public func converse(
        with model: BedrockModel,
        prompt: String,
        history: [Message] = [],
        maxTokens: Int? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        stopSequences: [String]? = nil
    ) async throws -> (String, [Message]) {
        logger.trace(
            "Conversing",
            metadata: [
                "model.id": .string(model.id),
                "model.modality": .string(model.modality.getName()),
                "prompt": .string(prompt),
            ]
        )
        do {
            let modality = try model.getTextModality()  // FIXME later: ConverseModality?
            try validateConverseParams(
                modality: modality,
                prompt: prompt,
                history: history,
                maxTokens: maxTokens,
                temperature: temperature,
                topP: topP,
                stopSequences: stopSequences
            )

            var messages = history
            messages.append(Message(from: .user, content: [.text(prompt)]))

            let converseRequest = ConverseRequest(
                model: model,
                messages: messages,
                maxTokens: maxTokens,
                temperature: temperature,
                topP: topP,
                stopSequences: stopSequences
            )
            let input = converseRequest.getConverseInput()
            logger.trace(
                "Created ConverseInput",
                metadata: ["messages.count": "\(messages.count)", "model": "\(model.id)"]
            )
            let response = try await self.bedrockRuntimeClient.converse(input: input)
            logger.trace("Received response", metadata: ["response": "\(response)"])

            guard let converseOutput = response.output else {
                logger.trace(
                    "Invalid response",
                    metadata: [
                        "response": .string(String(describing: response)),
                        "hasOutput": .stringConvertible(response.output != nil),
                    ]
                )
                throw SwiftBedrockError.invalidSDKResponse(
                    "Something went wrong while extracting ConverseOutput from response."
                )
            }
            let converseResponse = try ConverseResponse(converseOutput)
            messages.append(converseResponse.message)
            logger.trace(
                "Received message",
                metadata: ["replyMessage": "\(converseResponse.message)", "messages.count": "\(messages.count)"]
            )
            return (converseResponse.getReply(), messages)
        } catch {
            logger.trace("Error while conversing", metadata: ["error": "\(error)"])
            throw error
        }
    }
}
