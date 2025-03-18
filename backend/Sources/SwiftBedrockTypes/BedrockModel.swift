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

private actor ModelRegistry {
    static let shared = ModelRegistry()

    private var modelMap: [String: BedrockModel] = [
        BedrockModel.instant.id: .instant,
        BedrockModel.claudev1.id: .claudev1,
        BedrockModel.claudev2.id: .claudev2,
        BedrockModel.claudev2_1.id: .claudev2_1,
        BedrockModel.claudev3_haiku.id: .claudev3_haiku,
        BedrockModel.claudev3_5_haiku.id: .claudev3_5_haiku,
        BedrockModel.titan_text_g1_premier.id: .titan_text_g1_premier,
        BedrockModel.titan_text_g1_express.id: .titan_text_g1_express,
        BedrockModel.titan_text_g1_lite.id: .titan_text_g1_lite,
        BedrockModel.nova_micro.id: .nova_micro,
        BedrockModel.titan_image_g1_v2.id: .titan_image_g1_v2,
        BedrockModel.titan_image_g1_v1.id: .titan_image_g1_v1,
        BedrockModel.nova_canvas.id: .nova_canvas,
        BedrockModel.deepseek_r1_v1.id: .deepseek_r1_v1,
    ]

    func register(model: BedrockModel) {
        modelMap[model.id] = model
    }

    func getModel(id: String) -> BedrockModel? {
        modelMap[id]
    }
}

public struct BedrockModel: Equatable, Hashable, Sendable {
    // CHECK: RawRepresentable was taken out to allow async initializer from rawValue

    public var rawValue: String { id }
    public typealias RawValue = String

    public var id: String
    public let family: ModelFamily
    public let inputModality: [ModelModality]
    public let outputModality: [ModelModality]

    /// Creates a BedrockModel instance from a raw string value
    /// - Parameter rawValue: The model identifier string
    /// - Returns: The corresponding BedrockModel instance
    public init(rawValue: String) async {
        if let model = await ModelRegistry.shared.getModel(id: rawValue) {
            self = model
        } else {
            self = BedrockModel(id: rawValue, family: .unknown)
        }
    }

    public static func register(model: BedrockModel) async {
        await ModelRegistry.shared.register(model: model)
    }

    /// Creates a new BedrockModel instance
    /// - Parameters:
    ///   - id: The unique identifier for the model
    ///   - family: The model family this model belongs to
    ///   - inputModality: Array of supported input modalities (defaults to [.text])
    ///   - outputModality: Array of supported output modalities (defaults to [.text])
    public init(
        id: String,
        family: ModelFamily,
        inputModality: [ModelModality] = [.text],
        outputModality: [ModelModality] = [.text]
    ) {
        self.id = id
        self.family = family
        self.inputModality = inputModality
        self.outputModality = outputModality
    }

    /// Checks if the model supports specific input and output modalities
    /// - Parameters:
    ///   - inputs: The required input modalities
    ///   - outputs: The required output modalities
    /// - Returns: True if the model supports all specified modalities
    public func supports(input: [ModelModality], output: [ModelModality]) -> Bool {
        input.allSatisfy { inputModality.contains($0) } && output.allSatisfy { outputModality.contains($0) }
    }

    /// Checks if the model supports specific input and output modalities
    /// - Parameters:
    ///   - input: The required input modality
    ///   - output: The required output modality
    /// - Returns: True if the model supports the specified modalities
    public func supports(input: ModelModality, output: ModelModality) -> Bool {
        inputModality.contains(input) && outputModality.contains(output)
    }
}
