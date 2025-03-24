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

public struct ConverseRequest {
    let model: BedrockModel
    let messages: [Message]
    let inferenceConfig: InferenceConfig

    init(
        model: BedrockModel,
        messages: [Message] = [],
        maxTokens: Int,
        temperature: Double,
        topP: Double,
        stopSequences: [String]
    ) {
        self.messages = messages
        self.model = model
        self.inferenceConfig = InferenceConfig(
            maxTokens: maxTokens,
            temperature: temperature,
            topP: topP,
            stopSequences: stopSequences
        )
    }

    func getConverseInput() -> ConverseInput {
        ConverseInput(
            inferenceConfig: inferenceConfig.getSDKInferenceConfig(),
            messages: getSDKMessages(),
            modelId: model.id
        )
    }

    private func getSDKMessages() -> [BedrockRuntimeClientTypes.Message] {
        messages.map { $0.getSDKMessage() }
    }

    struct InferenceConfig {
        let maxTokens: Int
        let temperature: Double
        let topP: Double
        let stopSequences: [String]

        func getSDKInferenceConfig() -> BedrockRuntimeClientTypes.InferenceConfiguration {
            BedrockRuntimeClientTypes.InferenceConfiguration(
                maxTokens: maxTokens,
                stopSequences: stopSequences,
                temperature: Float(temperature),
                topp: Float(topP)
            )
        }
    }
}
