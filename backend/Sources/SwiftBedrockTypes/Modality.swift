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

import Foundation

public protocol Modality: Sendable, Hashable, Equatable {
    func getName() -> String
}

public protocol TextModality: Modality {

    init(parameters: TextGenerationParameters)
    func getParameters() -> TextGenerationParameters

    func getTextRequestBody(
        prompt: String,
        maxTokens: Int?,
        temperature: Double?,
        topP: Double?,
        topK: Int?,
        stopSequences: [String]?
    ) throws -> BedrockBodyCodable
    
    func getTextResponseBody(from data: Data) throws -> ContainsTextCompletion
}

public protocol ImageModality: Modality {
    init(parameters: ImageGenerationParameters)
    func getParameters() -> ImageGenerationParameters

    func getTextToImageRequestBody(prompt: String, nrOfImages: Int) throws -> BedrockBodyCodable
    func getImageVariationRequestBody(
        prompt: String,
        image: String,
        similarity: Double, 
        nrOfImages: Int
    ) throws -> BedrockBodyCodable // FIXME: optionals and use defaults
    func getImageResponseBody(from: Data) throws -> ContainsImageGeneration
}
