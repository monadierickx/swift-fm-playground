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

public struct BedrockModel: Hashable, Sendable, Equatable, RawRepresentable {  // Encodable? -> only stuff we need
    public var rawValue: String { id }  // FIXME: kill these two lines later

    public var id: String
    public let modality: any Modality

    /// Creates a new BedrockModel instance
    /// - Parameters:
    ///   - id: The unique identifier for the model
    ///   - modality: The modality of the model
    public init(
        id: String,
        modality: any Modality
    ) {
        self.id = id
        self.modality = modality
    }

    /// Creates an implemented BedrockModel instance from a raw string value
    /// - Parameter rawValue: The model identifier string
    /// - Returns: The corresponding BedrockModel instance or nil if the model is not implemented
    public init?(rawValue: String) {
        switch rawValue {
        // claude
        case BedrockModel.instant.id:
            self = BedrockModel.instant
        case BedrockModel.claudev1.id:
            self = BedrockModel.claudev1
        case BedrockModel.claudev2.id:
            self = BedrockModel.claudev2
        case BedrockModel.claudev2_1.id:
            self = BedrockModel.claudev2_1
        case BedrockModel.claudev3_haiku.id:
            self = BedrockModel.claudev3_haiku
        case BedrockModel.claudev3_5_haiku.id:
            self = BedrockModel.claudev3_5_haiku
        case BedrockModel.claudev3_opus.id:
            self = BedrockModel.claudev3_opus
        case BedrockModel.claudev3_5_sonnet.id:
            self = BedrockModel.claudev3_5_sonnet
        case BedrockModel.claudev3_5_sonnet_v2.id:
            self = BedrockModel.claudev3_5_sonnet_v2
        case BedrockModel.claudev3_7_sonnet.id:
            self = BedrockModel.claudev3_7_sonnet
        // titan
        case BedrockModel.titan_text_g1_premier.id:
            self = BedrockModel.titan_text_g1_premier
        case BedrockModel.titan_text_g1_express.id:
            self = BedrockModel.titan_text_g1_express
        case BedrockModel.titan_text_g1_lite.id:
            self = BedrockModel.titan_text_g1_lite
        // nova
        case BedrockModel.nova_micro.id:
            self = BedrockModel.nova_micro
        case BedrockModel.titan_image_g1_v2.id:
            self = BedrockModel.titan_image_g1_v2
        case BedrockModel.titan_image_g1_v1.id:
            self = BedrockModel.titan_image_g1_v1
        case BedrockModel.nova_canvas.id:
            self = BedrockModel.nova_canvas
        // deepseek
        case BedrockModel.deepseek_r1_v1.id:
            self = BedrockModel.deepseek_r1_v1
        // llama
        case BedrockModel.llama_3_8b_instruct.id: self = BedrockModel.llama_3_8b_instruct
        case BedrockModel.llama3_70b_instruct.id: self = BedrockModel.llama3_70b_instruct
        case BedrockModel.llama3_1_8b_instruct.id: self = BedrockModel.llama3_1_8b_instruct
        case BedrockModel.llama3_1_70b_instruct.id: self = BedrockModel.llama3_1_70b_instruct
        case BedrockModel.llama3_2_1b_instruct.id: self = BedrockModel.llama3_2_1b_instruct
        case BedrockModel.llama3_2_3b_instruct.id: self = BedrockModel.llama3_2_3b_instruct
        case BedrockModel.llama3_3_70b_instruct.id: self = BedrockModel.llama3_3_70b_instruct
        default:
            return nil
        }
    }

    /// Checks if the model supports text generation
    /// - Returns: True if the model supports text generation
    public func hasTextModality() -> Bool {
        modality as? any TextModality != nil
    }

    /// Checks if the model supports text generation and returns TextModality
    /// - Returns: TextModality if the model supports text modality
    public func getTextModality() throws -> any TextModality {
        guard let textModality = modality as? any TextModality else {
            throw SwiftBedrockError.invalid(
                .modality,
                "Model \(id) does not support text generation"
            )
        }
        return textModality
    }

    /// Checks if the model supports image generation
    /// - Returns: True if the model supports image generation
    public func hasImageModality() -> Bool {
        modality as? any ImageModality != nil
    }

    /// Checks if the model supports image generation and returns ImageModality
    /// - Returns: TextModality if the model supports image modality
    public func getImageModality() throws -> any ImageModality {
        guard let imageModality = modality as? any ImageModality else {
            throw SwiftBedrockError.invalid(
                .modality,
                "Model \(id) does not support image generation"
            )
        }
        return imageModality
    }

    /// Checks if the model supports text to image generation and returns TextToImageModality
    /// - Returns: TextToImageModality if the model supports image modality
    public func getTextToImageModality() throws -> any TextToImageModality {
        guard let textToImageModality = modality as? any TextToImageModality else {
            throw SwiftBedrockError.invalid(
                .modality,
                "Model \(id) does not support text to image generation"
            )
        }
        return textToImageModality
    }

    /// Checks if the model supports image variation and returns ImageVariationModality
    /// - Returns: ImageVariationModality if the model supports image modality
    public func getImageVariationModality() throws -> any ImageVariationModality {
        guard let modality = modality as? any ImageVariationModality else {
            throw SwiftBedrockError.invalid(
                .modality,
                "Model \(id) does not support image variation"
            )
        }
        return modality
    }
}
