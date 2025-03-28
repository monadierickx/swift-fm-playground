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
import BedrockTypes

extension BedrockService {

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
            try validateParameterValue(maxTokens!, parameter: parameters.maxTokens)
        }
        if temperature != nil {
            try validateParameterValue(temperature!, parameter: parameters.temperature)
        }
        if topP != nil {
            try validateParameterValue(topP!, parameter: parameters.topP)
        }
        if topK != nil {
            try validateParameterValue(topK!, parameter: parameters.topK)
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
            try validateParameterValue(nrOfImages!, parameter: parameters.nrOfImages)
        }
        if cfgScale != nil {
            try validateParameterValue(cfgScale!, parameter: parameters.cfgScale)
        }
        if seed != nil {
            try validateParameterValue(seed!, parameter: parameters.seed)
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
        try validateParameterValue(images.count, parameter: imageVariationParameters.images)
        if prompt != nil {
            try validatePrompt(prompt!, maxPromptTokens: imageVariationParameters.prompt.maxSize)
        }
        if similarity != nil {
            try validateParameterValue(similarity!, parameter: imageVariationParameters.similarity)
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
            try validateParameterValue(maxTokens!, parameter: parameters.maxTokens)
        }
        if temperature != nil {
            try validateParameterValue(temperature!, parameter: parameters.temperature)
        }
        if topP != nil {
            try validateParameterValue(topP!, parameter: parameters.topP)
        }
        if stopSequences != nil {
            try validateStopSequences(stopSequences!, maxNrOfStopSequences: parameters.stopSequences.maxSequences)
        }
    }

    // MARK: private helpers

    // Validate a parameter value with the min and max value saved in the Parameter
    private func validateParameterValue<T: Numeric & Comparable>(_ value: T, parameter: Parameter<T>) throws {
        guard parameter.isSupported else {
            logger.trace("Unsupported parameter", metadata: ["parameter": "\(parameter.name)"])
            throw BedrockServiceError.notSupported("Parameter \(parameter.name) is not supported.")
        }
        if let min = parameter.minValue {
            guard value >= min else {
                logger.trace(
                    "Invalid parameter",
                    metadata: [
                        "parameter": "\(parameter.name)",
                        "value": "\(value)",
                        "value.min": "\(min)",
                    ]
                )
                throw BedrockServiceError.invalidParameter(
                    parameter.name,
                    "Parameter \(parameter.name) should be at least \(min). Value: \(value)"
                )
            }
        }
        if let max = parameter.maxValue {
            guard value <= max else {
                logger.trace(
                    "Invalid parameter",
                    metadata: [
                        "parameter": "\(parameter.name)",
                        "value": "\(value)",
                        "value.max": "\(max)",
                    ]
                )
                throw BedrockServiceError.invalidParameter(
                    parameter.name,
                    "Parameter \(parameter.name) should be at most \(max). Value: \(value)"
                )
            }
        }
        logger.trace(
            "Valid parameter",
            metadata: [
                "parameter": "\(parameter.name)", "value": "\(value)",
                "value.min": "\(String(describing: parameter.minValue))",
                "value.max": "\(String(describing: parameter.maxValue))"
            ]
        )
    }

    /// Validate prompt is not empty and does not consist of only whitespaces, tabs or newlines
    /// Additionally validates that the prompt is not longer than the maxPromptTokens
    private func validatePrompt(_ prompt: String, maxPromptTokens: Int?) throws {
        guard !prompt.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            logger.trace("Invalid prompt", metadata: ["prompt": .string(prompt)])
            throw BedrockServiceError.invalidPrompt("Prompt is not allowed to be empty.")
        }
        if let maxPromptTokens = maxPromptTokens {
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
                throw BedrockServiceError.invalidPrompt(
                    "Prompt is not allowed to be longer than \(maxPromptTokens) tokens. Prompt lengt \(length)"
                )
            }
        }
    }

    /// Validate that not more stopsequences than allowed were given
    private func validateStopSequences(_ stopSequences: [String], maxNrOfStopSequences: Int?) throws {
        if let maxNrOfStopSequences = maxNrOfStopSequences {
            guard stopSequences.count <= maxNrOfStopSequences else {
                logger.trace(
                    "Invalid stopSequences",
                    metadata: [
                        "stopSequences": "\(stopSequences)",
                        "stopSequences.count": "\(stopSequences.count)",
                        "maxNrOfStopSequences": "\(maxNrOfStopSequences)",
                    ]
                )
                throw BedrockServiceError.invalidStopSequences(
                    stopSequences,
                    "You can only provide up to \(maxNrOfStopSequences) stop sequences. Number of stop sequences: \(stopSequences.count)"
                )
            }
        }
    }
}
