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

typealias DeepSeekR1V1 = DeepSeekText

extension BedrockModel {
    public static let deepseek_r1_v1: BedrockModel = BedrockModel(
        id: "us.deepseek.r1-v1:0",
        modality: DeepSeekR1V1(
            parameters: TextGenerationParameters(
                minTemperature: 0,
                maxTemperature: 1,
                defaultTemperature: 1,
                minMaxTokens: 1,
                maxMaxTokens: 32_768,
                defaultMaxTokens: 4_000,
                minTopP: 0,
                maxTopP: 1,
                maxStopSequences: 10,
                defaultStopSequences: []
            )
        )
    )
}
