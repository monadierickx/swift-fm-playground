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

public protocol Parameters: Sendable, Hashable, Equatable {}

public struct TextGenerationParameters: Parameters {
    public let temperature: Temperature
    public let maxTokens: MaxTokens
    public let prompt: Prompt
    public let topP: TopP
    public let topK: TopK
    public let stopSequences: StopSequences

    public init(
        minTemperature: Double = 0,
        maxTemperature: Double = 1,
        defaultTemperature: Double = 0.5,
        maxMaxTokens: Int = 25_000,
        defaultMaxTokens: Int = 512,
        maxPromptSize: Int = 25_000,
        minTopP: Double = 0,
        maxTopP: Double = 1,
        defaultTopP: Double = 0.9,
        minTopK: Int = 0,
        maxTopK: Int = 500,
        defaultTopK: Int = 250,
        maxStopSequences: Int = 10,
        defaultStopSequences: [String] = []
    ) {
        self.temperature = Temperature(min: minTemperature, max: maxTemperature, defaultVal: defaultTemperature)
        self.maxTokens = MaxTokens(max: maxMaxTokens, defaultVal: defaultMaxTokens)
        self.prompt = Prompt(maxSize: maxPromptSize)
        self.topP = TopP(min: minTopP, max: maxTopP, defaultVal: defaultTopP)
        self.topK = TopK(min: minTopK, max: maxTopK, defaultVal: defaultTopK)
        self.stopSequences = StopSequences(maxSequences: maxStopSequences, defaultVal: defaultStopSequences)
    }

    public struct Temperature: Parameters {
        public let min: Double
        public let max: Double
        public let defaultVal: Double
    }

    public struct MaxTokens: Parameters {
        public let max: Int
        public let defaultVal: Int
    }

    public struct Prompt: Parameters {
        public let maxSize: Int
    }

    public struct TopP: Parameters {
        public let min: Double
        public let max: Double
        public let defaultVal: Double
    }

    public struct TopK: Parameters {
        public let min: Int
        public let max: Int
        public let defaultVal: Int
    }

    public struct StopSequences: Parameters {
        public let maxSequences: Int
        public let defaultVal: [String]
    }
}

public struct ImageGenerationParameters: Parameters {
    public let prompt: Prompt
    public let nrOfImages: NrOfImages
    public let similarity: Similarity

    public init(
        maxPromptSize: Int = 25_000,
        minNrOfImages: Int = 1,
        maxNrOfImages: Int = 5,
        defaultNrOfImages: Int = 1,
        minSimilarity: Double = 0.2,
        maxSimilarity: Double = 1.0,
        defaultSimilarity: Double = 0.6
    ) {
        self.prompt = Prompt(maxSize: maxPromptSize)
        self.nrOfImages = NrOfImages(min: minNrOfImages, max: maxNrOfImages, defaultVal: defaultNrOfImages)
        self.similarity = Similarity(min: minSimilarity, max: maxSimilarity, defaultVal: defaultSimilarity)
    }

    public struct Prompt: Parameters {
        public let maxSize: Int
    }

    public struct NrOfImages: Parameters {
        public let min: Int
        public let max: Int
        public let defaultVal: Int
    }

    public struct Similarity: Parameters {
        public let min: Double
        public let max: Double
        public let defaultVal: Double
    }
}
