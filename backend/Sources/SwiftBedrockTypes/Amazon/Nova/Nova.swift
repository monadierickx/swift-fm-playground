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

struct Nova: ModelFamily {
    let name: String = "Nova"

    func getTextRequestBody(prompt: String, maxTokens: Int, temperature: Double) throws -> BedrockBodyCodable {
        NovaRequestBody(prompt: prompt, maxTokens: maxTokens, temperature: temperature)
    }

    func getTextResponseBody(from data: Data) throws -> ContainsTextCompletion {
        let decoder = JSONDecoder()
        return try decoder.decode(NovaResponseBody.self, from: data)
    }

    func getTextToImageRequestBody(prompt: String, nrOfImages: Int) throws -> BedrockBodyCodable {
        AmazonImageRequestBody.textToImage(prompt: prompt, nrOfImages: nrOfImages)
    }

    func getImageVariationRequestBody(
        prompt: String,
        image: String,
        similarity: Double,
        nrOfImages: Int
    ) throws -> BedrockBodyCodable {
        AmazonImageRequestBody.imageVariation(
            prompt: prompt,
            referenceImage: image,
            similarity: similarity,
            nrOfImages: nrOfImages
        )
    }

    func getImageResponseBody(from data: Data) throws -> ContainsImageGeneration {
        let decoder = JSONDecoder()
        return try decoder.decode(AmazonImageResponseBody.self, from: data)
    }
}
