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

struct Anthropic: ModelFamily {
    let name: String = "Anthropic"

    func getTextRequestBody(prompt: String, maxTokens: Int, temperature: Double) throws -> BedrockBodyCodable {
        AnthropicRequestBody(prompt: prompt, maxTokens: maxTokens, temperature: temperature)
    }

    func getTextResponseBody(from data: Data) throws -> ContainsTextCompletion {
        let decoder = JSONDecoder()
        return try decoder.decode(AnthropicResponseBody.self, from: data)
    }

    func getTextToImageRequestBody(prompt: String, nrOfImages: Int) throws -> BedrockBodyCodable {
        throw SwiftBedrockError.notImplemented("getTextToImageRequestBody is not implemented for Anthropic")
    }

    func getImageVariationRequestBody(
        prompt: String,
        image: String,
        similarity: Double,
        nrOfImages: Int
    ) throws -> BedrockBodyCodable {
        throw SwiftBedrockError.notImplemented("getImageVariationRequestBody is not implemented for Anthropic")
    }

    func getImageResponseBody(from: Data) throws -> ContainsImageGeneration {
        throw SwiftBedrockError.notImplemented("getImageResponseBody is not implemented for Anthropic")
    }
}
