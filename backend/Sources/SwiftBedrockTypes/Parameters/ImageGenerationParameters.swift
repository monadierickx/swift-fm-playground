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

public struct ImageGenerationParameters: Parameters {
    public let nrOfImages: Parameter<Int>
    public let cfgScale: Parameter<Double>
    public let seed: Parameter<Int>

    public init(
        nrOfImages: Parameter<Int> = Parameter(minValue: 1, maxValue: 5, defaultValue: 1),
        cfgScale: Parameter<Double> = Parameter(minValue: 0.0, maxValue: 30.0, defaultValue: 7.5),
        seed: Parameter<Int> = Parameter(minValue: 0, maxValue: 1_000_000, defaultValue: 0)
    ) {
        self.nrOfImages = nrOfImages
        self.cfgScale = cfgScale
        self.seed = seed
    }
}

public struct TextToImageParameters: Parameters {
    public let prompt: PromptParams
    public let negativePrompt: PromptParams

    public init(
        maxPromptSize: Int = 1_024,
        maxNegativePromptSize: Int = 1_024
    ) {
        self.prompt = PromptParams(maxSize: maxPromptSize)
        self.negativePrompt = PromptParams(maxSize: maxNegativePromptSize)
    }
}

public struct ConditionedTextToImageParameters: Parameters {
    public let prompt: PromptParams
    public let negativePrompt: PromptParams
    public let similarity: Parameter<Double>

    public init(
        maxPromptSize: Int = 1_024,
        maxNegativePromptSize: Int = 1_024,
        similarity: Parameter<Double> = Parameter(minValue: 0.0, maxValue: 1.0, defaultValue: 0.7)
    ) {
        self.prompt = PromptParams(maxSize: maxPromptSize)
        self.negativePrompt = PromptParams(maxSize: maxNegativePromptSize)
        self.similarity = similarity
    }
}

public struct ImageVariationParameters: Parameters {
    public let images: Parameter<Int>
    public let prompt: PromptParams
    public let negativePrompt: PromptParams
    public let similarity: Parameter<Double>

    public init(
        images: Parameter<Int> = Parameter(minValue: 1, maxValue: 5, defaultValue: 1),
        maxPromptSize: Int = 1_024,
        maxNegativePromptSize: Int = 1_024,
        similarity: Parameter<Double> = Parameter(minValue: 0.2, maxValue: 1.0, defaultValue: 0.7)
    ) {
        self.prompt = PromptParams(maxSize: maxPromptSize)
        self.negativePrompt = PromptParams(maxSize: maxNegativePromptSize)
        self.similarity = similarity
        self.images = images
    }
}

public struct ColorGuidedImageGenerationParameters: Parameters {
    public let colors: Parameter<Int>
    public let prompt: PromptParams
    public let negativePrompt: PromptParams

    public init(
        colors: Parameter<Int> = Parameter(minValue: 1, maxValue: 10, defaultValue: 1),
        maxPromptSize: Int = 1_024,
        maxNegativePromptSize: Int = 1_024,
        similarity: Parameter<Double> = Parameter(minValue: 0.2, maxValue: 1.0, defaultValue: 0.7)
    ) {
        self.prompt = PromptParams(maxSize: maxPromptSize)
        self.negativePrompt = PromptParams(maxSize: maxNegativePromptSize)
        self.colors = colors
    }
}
