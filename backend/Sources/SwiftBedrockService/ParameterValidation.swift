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
import SwiftBedrockTypes

extension SwiftBedrock {

    /// Validate parameters for a text completion request
    public func validateTextCompletionParams(
        modality: any TextModality,
        prompt: String?,
        maxTokens: Int?,
        temperature: Double?,
        topP: Double?,
        topK: Int?,
        stopSequences: [String]?
    ) throws {
        let parameters = modality.getParameters()
        if maxTokens != nil {
            try validateMaxTokens(maxTokens!, max: parameters.maxTokens.maxValue)
        }
        if temperature != nil {
            try validateTemperature(
                temperature!,
                min: parameters.temperature.minValue,
                max: parameters.temperature.maxValue
            )
        }
        if topP != nil {
            try validateTopP(topP!, min: parameters.topP.minValue, max: parameters.topP.maxValue)
        }
        if topK != nil {
            try validateTopK(topK!, min: parameters.topK.minValue, max: parameters.topK.maxValue)
        }
        if stopSequences != nil {
            try validateStopSequences(stopSequences!, maxNrOfStopSequences: parameters.stopSequences.maxSequences)
        }
        if prompt != nil {
            try validatePrompt(prompt!, maxPromptTokens: parameters.prompt.maxSize)
        }
    }

    /// Validate parameters for an image generation request
    public func validateImageGenerationParams(
        modality: any ImageModality,
        nrOfImages: Int?,
        cfgScale: Double?,
        resolution: ImageResolution?,
        seed: Int?
    ) throws {
        let parameters = modality.getParameters()
        if nrOfImages != nil {
            try validateNrOfImages(
                nrOfImages!,
                min: parameters.nrOfImages.minValue,
                max: parameters.nrOfImages.maxValue
            )
        }
        if cfgScale != nil {
            try validateCfgScale(
                cfgScale!,
                min: parameters.cfgScale.minValue,
                max: parameters.cfgScale.maxValue
            )
        }
        if seed != nil {
            try validateSeed(
                seed!,
                min: parameters.seed.minValue,
                max: parameters.seed.maxValue
            )
        }
        if resolution != nil {
            try modality.validateResolution(resolution!)
        }
    }

    /// Validate specific parameters for a text to image request
    public func validateTextToImageParams(
        modality: any TextToImageModality,
        prompt: String,
        negativePrompt: String?
    ) throws {
        let textToImageParameters = modality.getTextToImageParameters()
        try validatePrompt(prompt, maxPromptTokens: textToImageParameters.prompt.maxSize)
        if negativePrompt != nil {
            try validatePrompt(negativePrompt!, maxPromptTokens: textToImageParameters.negativePrompt.maxSize)
        }
    }

    /// Validate specific parameters for an image variation request
    public func validateImageVariationParams(
        modality: any ImageVariationModality,
        images: [String],
        prompt: String?,
        similarity: Double?,
        negativePrompt: String?
    ) throws {
        let imageVariationParameters = modality.getImageVariationParameters()
        try validateImages(
            images,
            min: imageVariationParameters.images.maxValue,
            max: imageVariationParameters.images.maxValue
        )
        if prompt != nil {
            try validatePrompt(prompt!, maxPromptTokens: imageVariationParameters.prompt.maxSize)
        }
        if similarity != nil {
            try validateSimilarity(
                similarity!,
                min: imageVariationParameters.similarity.minValue,
                max: imageVariationParameters.similarity.maxValue
            )
        }
        if negativePrompt != nil {
            try validatePrompt(negativePrompt!, maxPromptTokens: imageVariationParameters.negativePrompt.maxSize)
        }
    }

    /// Validate parameters for a converse request
    public func validateConverseParams(
        modality: any TextModality,
        prompt: String,
        history: [Message],
        maxTokens: Int?,
        temperature: Double?,
        topP: Double?,
        stopSequences: [String]?
    ) throws {
        let parameters = modality.getParameters()
        try validatePrompt(prompt, maxPromptTokens: parameters.prompt.maxSize)
        if maxTokens != nil {
            try validateMaxTokens(maxTokens!, max: parameters.maxTokens.maxValue)
        }
        if temperature != nil {
            try validateTemperature(
                temperature!,
                min: parameters.temperature.minValue,
                max: parameters.temperature.maxValue
            )
        }
        if topP != nil {
            try validateTopP(topP!, min: parameters.topP.minValue, max: parameters.topP.maxValue)
        }
        if stopSequences != nil {
            try validateStopSequences(stopSequences!, maxNrOfStopSequences: parameters.stopSequences.maxSequences)
        }
    }

    // MARK: private helpers

    /// Validate images is at least a minimum value
    private func validateImages(_ images: [String], min: Int, max: Int) throws {
        guard images.count <= max else {
            logger.trace(
                "Invalid stopSequences",
                metadata: [
                    "stopSequences": "\(images)",
                    "stopSequences.count": "\(images.count)",
                    "stopSequences.min": "\(min)",
                    "stopSequences.max": "\(max)",
                ]
            )
            throw SwiftBedrockError.invalidStopSequences(
                "You should provide at least \(min) and at most \(max) images. Number of images provided: \(images.count)"
            )
        }
    }

    /// Validate maxTokens is at least a minimum value
    private func validateMaxTokens(_ maxTokens: Int, max: Int) throws {
        guard maxTokens >= 1 else {
            logger.trace(
                "Invalid maxTokens",
                metadata: ["maxTokens": .stringConvertible(maxTokens)]
            )
            throw SwiftBedrockError.invalidMaxTokens(
                "MaxTokens should be between 1 and \(max). MaxTokens: \(maxTokens)"
            )
        }
    }

    /// Validate temperature is between a minimum and a maximum value
    private func validateTemperature(_ temperature: Double, min: Double, max: Double) throws {
        guard temperature >= min && temperature <= max else {
            logger.trace(
                "Invalid temperature",
                metadata: ["temperature": "\(temperature)"]
            )
            throw SwiftBedrockError.invalidTemperature(
                "Temperature should be a value between \(min) and \(max). Temperature: \(temperature)"
            )
        }
    }

    /// Validate topP is between a minimum and a maximum value
    private func validateTopP(_ topP: Double, min: Double, max: Double) throws {
        guard topP >= min && topP <= max else {
            logger.trace(
                "Invalid topP",
                metadata: ["topP": "\(topP)"]
            )
            throw SwiftBedrockError.invalidTopP(
                "TopP should be a value between \(min) and \(max). TopP: \(topP)"
            )
        }
    }

    /// Validate topK is at least a minimum value
    private func validateTopK(_ topK: Int, min: Int, max: Int) throws {
        guard topK >= min else {
            logger.trace(
                "Invalid topK",
                metadata: ["topK": .stringConvertible(topK)]
            )
            throw SwiftBedrockError.invalidTopK(
                "TopK should be between \(min) and \(max). TopK: \(topK)"
            )
        }
    }

    /// Validate prompt is not empty and does not consist of only whitespaces, tabs or newlines
    /// Additionally validates that the prompt is not longer than the maxPromptTokens
    private func validatePrompt(_ prompt: String, maxPromptTokens: Int) throws {
        guard !prompt.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            logger.trace("Invalid prompt", metadata: ["prompt": .string(prompt)])
            throw SwiftBedrockError.invalidPrompt("Prompt is not allowed to be empty.")
        }
        let length = prompt.utf8.count
        guard length <= maxPromptTokens else {
            logger.trace(
                "Invalid prompt",
                metadata: [
                    "prompt": .string(prompt),
                    "prompt.length": "\(length)",
                    "maxPromptTokens": "\(maxPromptTokens)",
                ]
            )
            throw SwiftBedrockError.invalidPrompt(
                "Prompt is not allowed to be longer than \(maxPromptTokens) tokens. Prompt length: \(length)"
            )
        }
    }

    /// Validate nrOfImages is between a minimum and a maximum value
    private func validateNrOfImages(_ nrOfImages: Int, min: Int, max: Int) throws {
        guard nrOfImages >= min && nrOfImages <= max else {
            logger.trace(
                "Invalid nrOfImages",
                metadata: ["nrOfImages": .stringConvertible(nrOfImages)]
            )
            throw SwiftBedrockError.invalidNrOfImages(
                "NrOfImages should be between \(min) and \(max). nrOfImages: \(nrOfImages)"
            )
        }
    }

    /// Validate similarity is between a minimum and a maximum value
    private func validateSimilarity(_ similarity: Double, min: Double, max: Double) throws {
        guard similarity >= min && similarity <= max else {
            logger.trace(
                "Invalid similarity",
                metadata: ["similarity": .stringConvertible(similarity)]
            )
            throw SwiftBedrockError.invalidSimilarity(
                "Similarity should be between \(min) and \(max). similarity: \(similarity)"
            )
        }
    }

    /// Validate cfgScale is between a minimum and a maximum value
    private func validateCfgScale(_ cfgScale: Double, min: Double, max: Double) throws {
        guard cfgScale >= min && cfgScale <= max else {
            logger.trace(
                "Invalid cfgScale",
                metadata: ["cfgScale": .stringConvertible(cfgScale)]
            )
            throw SwiftBedrockError.invalidCfgScale(
                "Similarity should be between \(min) and \(max). cfgScale: \(cfgScale)"
            )
        }
    }

    /// Validate seed is at least a minimum value
    private func validateSeed(_ seed: Int, min: Int, max: Int) throws {
        guard seed >= min else {
            logger.trace(
                "Invalid seed",
                metadata: ["seed": .stringConvertible(seed)]
            )
            throw SwiftBedrockError.invalidSeed(
                "Seed should be between \(min) and \(max). Seed: \(seed)"
            )
        }
    }

    /// Validate that not more stopsequences than allowed were given
    private func validateStopSequences(_ stopSequences: [String], maxNrOfStopSequences: Int) throws {
        guard stopSequences.count <= maxNrOfStopSequences else {
            logger.trace(
                "Invalid stopSequences",
                metadata: [
                    "stopSequences": "\(stopSequences)",
                    "stopSequences.count": "\(stopSequences.count)",
                    "maxNrOfStopSequences": "\(maxNrOfStopSequences)",
                ]
            )
            throw SwiftBedrockError.invalidStopSequences(
                "You can only provide up to \(maxNrOfStopSequences) stop sequences. Number of stop sequences: \(stopSequences.count)"
            )
        }
    }
}
