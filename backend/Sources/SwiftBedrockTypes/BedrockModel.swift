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

public struct BedrockModel: Hashable, Sendable, Equatable, RawRepresentable {
    public var rawValue: String { id }  // FIXME: kill these two lines later
    public typealias RawValue = String

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
        case BedrockModel.titan_text_g1_premier.id:
            self = BedrockModel.titan_text_g1_premier
        case BedrockModel.titan_text_g1_express.id:
            self = BedrockModel.titan_text_g1_express
        case BedrockModel.titan_text_g1_lite.id:
            self = BedrockModel.titan_text_g1_lite
        case BedrockModel.nova_micro.id:
            self = BedrockModel.nova_micro
        case BedrockModel.titan_image_g1_v2.id:
            self = BedrockModel.titan_image_g1_v2
        case BedrockModel.titan_image_g1_v1.id:
            self = BedrockModel.titan_image_g1_v1
        case BedrockModel.nova_canvas.id:
            self = BedrockModel.nova_canvas
        case BedrockModel.deepseek_r1_v1.id:
            self = BedrockModel.deepseek_r1_v1
        default:
            return nil
        }
    }

    /// Checks if the model supports text generation
    /// - Returns: True if the model supports text generation
    public func hasTextModality() -> Bool {
        guard let _ = modality as? any TextModality else {
            return false
        }
        return true
    }

    /// Checks if the model supports text generation and returns TextModality
    /// - Returns: TextModality if the model supports text modality
    public func getTextModality() throws -> any TextModality {
        guard let textModality = modality as? any TextModality else {
            throw SwiftBedrockError.invalidModel(
                "Model \(id) does not support text generation"
            )
        }
        return textModality
    }

    /// Checks if the model supports image generation
    /// - Returns: True if the model supports image generation
    public func hasImageModality() -> Bool {
        guard let _ = modality as? any TextModality else {
            return false
        }
        return true
    }

    /// Checks if the model supports image generation and returns ImageModality
    /// - Returns: TextModality if the model supports image modality
    public func getImageModality() throws -> any ImageModality {
        guard let imageModality = modality as? any ImageModality else {
            throw SwiftBedrockError.invalidModel(
                "Model \(id) does not support text generation"
            )
        }
        return imageModality
    }
}
