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

@preconcurrency import AWSBedrockRuntime
import Foundation
import SwiftBedrockTypes

public struct BedrockResponse {
    let model: BedrockModel
    let contentType: ContentType
    let textCompletionBody: ContainsTextCompletion?
    let imageGenerationBody: ContainsImageGeneration?

    private init(
        model: BedrockModel,
        contentType: ContentType = .json,
        textCompletionBody: ContainsTextCompletion
    ) {
        self.model = model
        self.contentType = contentType
        self.textCompletionBody = textCompletionBody
        self.imageGenerationBody = nil
    }

    private init(
        model: BedrockModel,
        contentType: ContentType = .json,
        imageGenerationBody: ContainsImageGeneration
    ) {
        self.model = model
        self.contentType = contentType
        self.textCompletionBody = nil
        self.imageGenerationBody = imageGenerationBody
    }

    /// Creates a BedrockResponse from custom response data containing text completion
    /// - Parameters:
    ///   - customBody: Response data conforming to ContainsTextCompletion
    ///   - model: Any Bedrock model that generated the response
    static func createCustomTextResponse(customBody: ContainsTextCompletion, model: BedrockModel) -> Self {
        self.init(model: model, textCompletionBody: customBody)
    }

    /// Creates a BedrockResponse from custom response data containing image generation
    /// - Parameters:
    ///   - customBody: Response data conforming to ContainsImageGeneration
    ///   - model: Any Bedrock model that generated the response
    static func createCustomImageResponse(customBody: ContainsImageGeneration, model: BedrockModel) -> Self {
        self.init(model: model, imageGenerationBody: customBody)
    }

    /// Creates a BedrockResponse from raw response data containing text completion
    /// - Parameters:
    ///   - data: The raw response data from the Bedrock service
    ///   - model: The Bedrock model that generated the response
    /// - Throws: SwiftBedrockError.invalidModel if the model is not supported
    ///          SwiftBedrockError.invalidResponseBody if the response cannot be decoded
    static func createTextResponse(body data: Data, model: BedrockModel) throws -> Self {
        do {
            // var body: ContainsTextCompletion
            // let decoder = JSONDecoder()
            // switch model.family {
            // case .anthropic:
            //     body = try decoder.decode(AnthropicResponseBody.self, from: data)
            // case .titan:
            //     body = try decoder.decode(TitanResponseBody.self, from: data)
            // case .nova:
            //     body = try decoder.decode(NovaResponseBody.self, from: data)
            // case .deepseek:
            //     body = try decoder.decode(DeepSeekResponseBody.self, from: data)
            // default:
            //     throw SwiftBedrockError.invalidModel(model.id)  // FIXME: allow new models
            // }
            let body: ContainsTextCompletion = try model.family.getTextResponseBody(from: data)
            return self.init(model: model, textCompletionBody: body)
        } catch {
            throw SwiftBedrockError.invalidResponseBody(data)
        }
    }

    /// Creates a BedrockResponse from raw response data containing an image generation
    /// - Parameters:
    ///   - data: The raw response data from the Bedrock service
    ///   - model: The Bedrock model that generated the response
    /// - Throws: SwiftBedrockError.invalidModel if the model is not supported
    ///          SwiftBedrockError.invalidResponseBody if the response cannot be decoded
    static func createImageResponse(body data: Data, model: BedrockModel) throws -> Self {
        do {
            // var body: ContainsImageGeneration
            let decoder = JSONDecoder()
            // switch model.family {
            // case .titan, .nova:
            //     body = try decoder.decode(AmazonImageResponseBody.self, from: data)
            // default:
            //     throw SwiftBedrockError.invalidModel(model.id)  // FIXME: allow new models
            // }
            let body = try decoder.decode(AmazonImageResponseBody.self, from: data)
            return self.init(model: model, imageGenerationBody: body)
        } catch {
            throw SwiftBedrockError.invalidResponseBody(data)
        }
    }

    /// Extracts the text completion from the response body
    /// - Returns: The text completion from the response
    /// - Throws: SwiftBedrockError.decodingError if the completion cannot be extracted
    public func getTextCompletion() throws -> TextCompletion {
        do {
            guard let textCompletionBody = textCompletionBody else {
                throw SwiftBedrockError.decodingError("No text completion body found in the response")
            }
            return try textCompletionBody.getTextCompletion()
        } catch {
            throw SwiftBedrockError.decodingError(
                "Something went wrong while decoding the request body to find the completion: \(error)"
            )
        }
    }

    /// Extracts the image generation from the response body
    /// - Returns: The image generation from the response
    /// - Throws: SwiftBedrockError.decodingError if the image generation cannot be extracted
    public func getGeneratedImage() throws -> ImageGenerationOutput {
        do {
            guard let imageGenerationBody = imageGenerationBody else {
                throw SwiftBedrockError.decodingError("No image generation body found in the response")
            }
            return imageGenerationBody.getGeneratedImage()
        } catch {
            throw SwiftBedrockError.decodingError(
                "Something went wrong while decoding the request body to find the completion: \(error)"
            )
        }
    }
}
