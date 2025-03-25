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
    func getParameters() -> ImageGenerationParameters
    // func validateResolution(_ resolution: ImageResolution) throws
    func getImageResponseBody(from: Data) throws -> ContainsImageGeneration
}

public protocol TextToImageModality: Modality {
    func getTextToImageParameters() -> TextToImageParameters
    func getTextToImageRequestBody(
        prompt: String,
        negativeText: String?,
        nrOfImages: Int?,
        cfgScale: Double?,
        seed: Int?,
        quality: ImageQuality?,
        resolution: ImageResolution?
    ) throws -> BedrockBodyCodable
}

public protocol ConditionedTextToImageModality: Modality {
    func getConditionedTextToImageParameters() -> ConditionedTextToImageParameters
    func getConditionedTextToImageRequestBody(
        prompt: String,
        negativeText: String?,
        nrOfImages: Int?,
        cfgScale: Double?,
        seed: Int?,
        quality: ImageQuality?,
        resolution: ImageResolution?
    ) throws -> any BedrockBodyCodable
}

public protocol ImageVariationModality: Modality {
    func getImageVariationParameters() -> ImageVariationParameters

    func getImageVariationRequestBody(
        prompt: String?,
        negativeText: String?,
        image: String,
        similarity: Double?,
        nrOfImages: Int?,
        cfgScale: Double?,
        seed: Int?,
        quality: ImageQuality?,
        resolution: ImageResolution?
    ) throws -> BedrockBodyCodable
}
