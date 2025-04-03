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
import BedrockTypes
import Foundation
import Logging

public struct BedrockService: Sendable {
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
        self.logger = logger ?? BedrockService.createLogger("swiftbedrock.service")
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
            self.bedrockClient = try await BedrockService.createBedrockClient(
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
            self.bedrockRuntimeClient = try await BedrockService.createBedrockRuntimeClient(
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
    /// - Throws: BedrockServiceError.invalidResponse
    /// - Returns: An array of ModelInfo objects containing details about each available model.
    public func listModels() async throws -> [ModelSummary] {
        logger.trace("Fetching foundation models")
        do {
            let response = try await bedrockClient.listFoundationModels(
                input: ListFoundationModelsInput()
            )
            guard let models = response.modelSummaries else {
                logger.trace("Failed to extract modelSummaries from response")
                throw BedrockServiceError.invalidSDKResponse(
                    "Something went wrong while extracting the modelSummaries from the response."
                )
            }
            var modelsInfo: [ModelSummary] = []
            modelsInfo = try models.compactMap { (sdkModelSummary) -> ModelSummary? in
                try ModelSummary.getModelSummary(from: sdkModelSummary)
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
            logger.trace("Error while listing foundation models", metadata: ["error": "\(error)"])
            throw error
        }
    }

    /// Generates a text completion using a specified model.
    /// - Parameters:
    ///   - text: the text to be completed
    ///   - model: the BedrockModel that will be used to generate the completion
    ///   - maxTokens: the maximum amount of tokens in the completion (must be at least 1) optional, default 300
    ///   - temperature: the temperature used to generate the completion (must be a value between 0 and 1) optional, default 0.6
    /// - Throws: BedrockServiceError.invalidMaxTokens if maxTokens is less than 1
    ///           BedrockServiceError.invalidTemperature if temperature is not between 0 and 1
    ///           BedrockServiceError.invalidPrompt if the prompt is empty
    ///           BedrockServiceError.invalidResponse if the response body is missing
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
                throw BedrockServiceError.invalidSDKResponse(
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
    /// - Throws: BedrockServiceError.invalidNrOfImages if nrOfImages is not between 1 and 5
    ///           BedrockServiceError.invalidPrompt if the prompt is empty
    ///           BedrockServiceError.invalidResponse if the response body is missing
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
                throw BedrockServiceError.invalidSDKResponse(
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
    /// - Throws: BedrockServiceError.invalidNrOfImages if nrOfImages is not between 1 and 5
    ///           BedrockServiceError.similarity if similarity is not between 0.2 - 1.0
    ///           BedrockServiceError.invalidPrompt if the prompt is empty
    ///           BedrockServiceError.invalidResponse if the response body is missing
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
                throw BedrockServiceError.invalidSDKResponse(
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

    /// converse
    public func converse(
        with model: BedrockModel,
        conversation: [Message],
        maxTokens: Int? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        stopSequences: [String]? = nil,
        systemPrompts: [String]? = nil,
        tools: [Tool]? = nil
    ) async throws -> Message {
        do {
            let modality: ConverseModality = try model.getConverseModality()
            try validateConverseParams(
                modality: modality,
                maxTokens: maxTokens,
                temperature: temperature,
                topP: topP,
                stopSequences: stopSequences
            )

            logger.trace(
                "Creating ConverseRequest",
                metadata: [
                    "model.name": "\(model.name)",
                    "model.id": "\(model.id)",
                    "conversation.count": "\(conversation.count)",
                    "maxToken": "\(String(describing: maxTokens))",
                    "temperature": "\(String(describing: temperature))",
                    "topP": "\(String(describing: topP))",
                    "stopSequences": "\(String(describing: stopSequences))",
                    "systemPrompts": "\(String(describing: systemPrompts))",
                    "tools": "\(String(describing: tools))",
                ]
            )
            let converseRequest = ConverseRequest(
                model: model,
                messages: conversation,
                maxTokens: maxTokens,
                temperature: temperature,
                topP: topP,
                stopSequences: stopSequences,
                systemPrompts: systemPrompts,
                tools: tools
            )

            logger.trace("Creating ConverseInput")
            let input = try converseRequest.getConverseInput()
            logger.trace(
                "Created ConverseInput",
                metadata: [
                    "input.messages.count": "\(String(describing:input.messages!.count))",
                    "input.modelId": "\(String(describing:input.modelId!))",
                ]
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
                throw BedrockServiceError.invalidSDKResponse(
                    "Something went wrong while extracting ConverseOutput from response."
                )
            }
            let converseResponse = try ConverseResponse(converseOutput)
            return converseResponse.message
        } catch {
            logger.trace("Error while conversing", metadata: ["error": "\(error)"])
            throw error
        }
    }

    /// Use Converse API without needing to make Messages
    public func converse(
        with model: BedrockModel,
        prompt: String?,
        imageFormat: ImageBlock.Format? = nil,
        imageBytes: String? = nil,
        history: [Message] = [],
        maxTokens: Int? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        stopSequences: [String]? = nil,
        systemPrompts: [String]? = nil,
        tools: [Tool]? = nil,
        toolResult: ToolResultBlock? = nil
    ) async throws -> (String, [Message]) {
        logger.trace(
            "Conversing",
            metadata: [
                "model.id": .string(model.id),
                "model.modality": .string(model.modality.getName()),
                "prompt": .string(prompt ?? "No prompt"),
            ]
        )
        do {
            var messages = history
            let modality: ConverseModality = try model.getConverseModality()

            if tools != nil || toolResult != nil {
                guard model.hasConverseModality(.toolUse) else {
                    throw BedrockServiceError.invalidModality(
                        model,
                        modality,
                        "This model does not support converse tool."
                    )
                }
            }

            if let toolResult {
                guard let _: [Tool] = tools else {
                    throw BedrockServiceError.invalidPrompt("Tool result is defined but tools are not.")
                }
                guard case .toolUse(_) = messages.last?.content.last else {
                    throw BedrockServiceError.invalidPrompt("Tool result is defined but last message is not tool use.")
                }
                messages.append(Message(toolResult))
            } else {
                guard let prompt = prompt else {
                    throw BedrockServiceError.invalidPrompt("Prompt is not defined.")
                }

                if let imageFormat, let imageBytes {
                    guard model.hasConverseModality(.vision) else {
                        throw BedrockServiceError.invalidModality(
                            model,
                            modality,
                            "This model does not support converse vision."
                        )
                    }
                    messages.append(
                        Message(prompt: prompt, imageFormat: imageFormat, imageBytes: imageBytes)
                    )
                } else {
                    messages.append(Message(prompt))
                }
            }
            let message = try await converse(
                with: model,
                conversation: messages,
                maxTokens: maxTokens,
                temperature: temperature,
                topP: topP,
                stopSequences: stopSequences,
                systemPrompts: systemPrompts,
                tools: tools
            )
            messages.append(message)
            logger.trace(
                "Received message",
                metadata: ["replyMessage": "\(message)", "messages.count": "\(messages.count)"]
            )
            let converseResponse = ConverseResponse(message)
            return (converseResponse.getReply(), messages)
        } catch {
            logger.trace("Error while conversing", metadata: ["error": "\(error)"])
            throw error
        }
    }
}
