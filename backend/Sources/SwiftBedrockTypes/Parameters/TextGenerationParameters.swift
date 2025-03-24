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

public struct TextGenerationParameters: Parameters {
    public let temperature: Parameter<Double>
    public let maxTokens: Parameter<Int>
    public let topP: Parameter<Double>
    public let topK: Parameter<Int>
    public let prompt: PromptParams
    public let stopSequences: StopSequenceParams

    public init(
        temperature: Parameter<Double> = Parameter<Double>(minValue: 0, maxValue: 1, defaultValue: 0.5),
        maxTokens: Parameter<Int> = Parameter<Int>(minValue: 1, maxValue: 25_000, defaultValue: 512),
        topP: Parameter<Double> = Parameter<Double>(minValue: 0, maxValue: 1, defaultValue: 0.9),
        topK: Parameter<Int> = Parameter<Int>(minValue: 0, maxValue: 500, defaultValue: 250),
        maxPromptSize: Int = 25_000,
        maxStopSequences: Int = 10,
        defaultStopSequences: [String] = []
    ) {
        self.temperature = temperature
        self.maxTokens = maxTokens
        self.topP = topP
        self.topK = topK
        self.prompt = PromptParams(maxSize: maxPromptSize)
        self.stopSequences = StopSequenceParams(maxSequences: maxStopSequences, defaultVal: defaultStopSequences)
    }
}
