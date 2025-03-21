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

struct TitanText: TextModality {
    func getName() -> String { "Titan Text Generation" }
    
    let parameters: TextGenerationParameters

    init(parameters: TextGenerationParameters) {
        self.parameters = parameters
    }

    func getParameters() -> TextGenerationParameters {
        parameters
    }

    func getTextRequestBody(
        prompt: String,
        maxTokens: Int?,
        temperature: Double?,
        topP: Double?,
        topK: Int?,
        stopSequences: [String]?
    ) throws -> BedrockBodyCodable {
        TitanRequestBody(
            prompt: prompt,
            maxTokens: maxTokens ?? parameters.maxTokens.defaultVal,
            temperature: temperature ?? parameters.temperature.defaultVal
            // topP: topP ?? parameters.topP.defaultVal,
            // topK: topK ?? parameters.topK.defaultVal,
            // stopSequences: stopSequences ?? parameters.stopSequences.defaultVal
        )
    }

    func getTextResponseBody(from data: Data) throws -> ContainsTextCompletion {
        let decoder = JSONDecoder()
        return try decoder.decode(TitanResponseBody.self, from: data)
    }
}
