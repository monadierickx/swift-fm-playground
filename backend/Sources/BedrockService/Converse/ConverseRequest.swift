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
import BedrockTypes

public struct ConverseRequest {
    let model: BedrockModel
    let messages: [Message]
    let inferenceConfig: InferenceConfig?

    init(
        model: BedrockModel,
        messages: [Message] = [],
        maxTokens: Int?,
        temperature: Double?,
        topP: Double?,
        stopSequences: [String]?
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

    func getConverseInput() throws -> ConverseInput {
        let sdkInferenceConfig: BedrockRuntimeClientTypes.InferenceConfiguration?
        if inferenceConfig != nil {
            sdkInferenceConfig = inferenceConfig!.getSDKInferenceConfig()
        } else {
            sdkInferenceConfig = nil
        }
        return ConverseInput(
            inferenceConfig: sdkInferenceConfig,
            messages: try getSDKMessages(),
            modelId: model.id
        )
    }

    private func getSDKMessages() throws -> [BedrockRuntimeClientTypes.Message] {
        try messages.map { try $0.getSDKMessage() }
    }

    struct InferenceConfig {
        let maxTokens: Int?
        let temperature: Double?
        let topP: Double?
        let stopSequences: [String]?

        func getSDKInferenceConfig() -> BedrockRuntimeClientTypes.InferenceConfiguration {
            let temperatureFloat: Float?
            if temperature != nil {
                temperatureFloat = Float(temperature!)
            } else {
                temperatureFloat = nil
            }
            let topPFloat: Float?
            if topP != nil {
                topPFloat = Float(topP!)
            } else {
                topPFloat = nil
            }
            return BedrockRuntimeClientTypes.InferenceConfiguration(
                maxTokens: maxTokens,
                stopSequences: stopSequences,
                temperature: temperatureFloat,
                topp: topPFloat
            )
        }
    }
}
