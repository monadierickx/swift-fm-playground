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

@preconcurrency import AWSBedrock
import Foundation
import SwiftBedrockTypes

// comment to explain difference

// extension ModelSummary: Encodable {
//     public func encode(to encoder: Encoder) throws {
//         var container = encoder.container(keyedBy: CodingKeys.self)
//         try container.encode(providerName, forKey: .providerName)
//         if let model: BedrockModel = bedrockModel {
//             try container.encode(model.name, forKey: .modelName)
//             try container.encode(model.id, forKey: .modelId)
//             try container.encode(String(describing: type(of: model.modality)), forKey: .supportedModality)
//             // Encode parameters based on modality type
//             // print("Model has text modality: \(model.hasTextModality())")
//             if model.hasTextModality() {
//                 // try encodeTextParameters(to: &container)
//                 let textModality = try model.getTextModality()
//                 let params = textModality.getParameters()
//                 print("Temperature supported: \(params.temperature.isSupported)")
//                 print("MaxTokens supported: \(params.maxTokens.isSupported)")
//                 if params.temperature.isSupported {
//                     var tempContainer = container.nestedContainer(keyedBy: RangeKeys.self, forKey: .temperatureRange)
//                     try tempContainer.encode(params.temperature.minValue, forKey: .min)
//                     try tempContainer.encode(params.temperature.maxValue, forKey: .max)
//                     try tempContainer.encode(params.temperature.defaultValue, forKey: .default)
//                 }
//                 if params.maxTokens.isSupported {
//                     var tokenContainer = container.nestedContainer(keyedBy: RangeKeys.self, forKey: .maxTokenRange)
//                     try tokenContainer.encode(params.maxTokens.minValue, forKey: .min)
//                     try tokenContainer.encode(params.maxTokens.maxValue, forKey: .max)
//                     try tokenContainer.encode(params.maxTokens.defaultValue, forKey: .default)
//                 }
//                 if params.topP.isSupported {
//                     var topPContainer = container.nestedContainer(keyedBy: RangeKeys.self, forKey: .topPRange)
//                     try topPContainer.encode(params.topP.minValue, forKey: .min)
//                     try topPContainer.encode(params.topP.maxValue, forKey: .max)
//                     try topPContainer.encode(params.topP.defaultValue, forKey: .default)
//                 }
//                 if params.topK.isSupported {
//                     var topKContainer = container.nestedContainer(keyedBy: RangeKeys.self, forKey: .topKRange)
//                     try topKContainer.encode(params.topK.minValue, forKey: .min)
//                     try topKContainer.encode(params.topK.maxValue, forKey: .max)
//                     try topKContainer.encode(params.topK.defaultValue, forKey: .default)
//                 }
//             }
//             if model.hasImageModality() {
//                 // try encodeImageParameters(to: &container)
//                 let imageModality = try model.getImageModality()
//                 let params = imageModality.getParameters()
//                 // General image generation inference parameters
//                 if params.nrOfImages.isSupported {
//                     var imagesContainer = container.nestedContainer(keyedBy: RangeKeys.self, forKey: .nrOfImagesRange)
//                     try imagesContainer.encode(params.nrOfImages.minValue, forKey: .min)
//                     try imagesContainer.encode(params.nrOfImages.maxValue, forKey: .max)
//                     try imagesContainer.encode(params.nrOfImages.defaultValue, forKey: .default)
//                 }
//                 if params.cfgScale.isSupported {
//                     var cfgScaleContainer = container.nestedContainer(keyedBy: RangeKeys.self, forKey: .cfgScaleRange)
//                     try cfgScaleContainer.encode(params.cfgScale.minValue, forKey: .min)
//                     try cfgScaleContainer.encode(params.cfgScale.maxValue, forKey: .max)
//                     try cfgScaleContainer.encode(params.cfgScale.defaultValue, forKey: .default)
//                 }
//                 if params.seed.isSupported {
//                     var seedContainer = container.nestedContainer(keyedBy: RangeKeys.self, forKey: .seedRange)
//                     try seedContainer.encode(params.seed.minValue, forKey: .min)
//                     try seedContainer.encode(params.seed.maxValue, forKey: .max)
//                     try seedContainer.encode(params.seed.defaultValue, forKey: .default)
//                 }
//                 // If the model supports image variation, encode similarity range
//                 if model.hasImageVariationModality() {
//                     let variationModality = try model.getImageVariationModality()
//                     let variationParams = variationModality.getImageVariationParameters()
//                     if variationParams.similarity.isSupported {
//                         var similarityContainer = container.nestedContainer(
//                             keyedBy: RangeKeys.self,
//                             forKey: .similarityRange
//                         )
//                         try similarityContainer.encode(variationParams.similarity.minValue, forKey: .min)
//                         try similarityContainer.encode(variationParams.similarity.maxValue, forKey: .max)
//                         try similarityContainer.encode(variationParams.similarity.defaultValue, forKey: .default)
//                     }
//                 }
//             }
//         } else {
//             try container.encode(modelName, forKey: .modelName)
//             try container.encode(modelId, forKey: .modelId)
//         }
//     }
//     private enum CodingKeys: String, CodingKey {
//         case modelName
//         case modelId
//         case providerName
//         case temperatureRange
//         case maxTokenRange
//         case topPRange
//         case topKRange
//         case nrOfImagesRange
//         case cfgScaleRange
//         case seedRange
//         case similarityRange
//         case supportedModality
//     }
//     private enum RangeKeys: String, CodingKey {
//         case min
//         case max
//         case `default`
//     }
// }

public struct ModelSummary: Encodable {
    let modelName: String
    let providerName: String
    let modelId: String
    let modelArn: String
    let modelLifecylceStatus: Status
    let responseStreamingSupported: Bool
    let bedrockModel: BedrockModel?

    public static func getModelSummary(from sdkModelSummary: BedrockClientTypes.FoundationModelSummary) throws -> Self {

        guard let modelName = sdkModelSummary.modelName else {
            throw SwiftBedrockError.notFound("BedrockClientTypes.FoundationModelSummary does not have a modelName")
        }
        guard let providerName = sdkModelSummary.providerName else {
            throw SwiftBedrockError.notFound("BedrockClientTypes.FoundationModelSummary does not have a providerName")
        }
        guard let modelId = sdkModelSummary.modelId else {
            throw SwiftBedrockError.notFound("BedrockClientTypes.FoundationModelSummary does not have a modelId")
        }
        guard let modelArn = sdkModelSummary.modelArn else {
            throw SwiftBedrockError.notFound("BedrockClientTypes.FoundationModelSummary does not have a modelArn")
        }
        guard let modelLifecycle = sdkModelSummary.modelLifecycle else {
            throw SwiftBedrockError.notFound("BedrockClientTypes.FoundationModelSummary does not have a modelLifecycle")
        }
        guard let sdkStatus = modelLifecycle.status else {
            throw SwiftBedrockError.notFound(
                "BedrockClientTypes.FoundationModelSummary does not have a modelLifecycle.status"
            )
        }
        let status = try Status(sdkStatus: sdkStatus)
        var responseStreamingSupported = false
        if sdkModelSummary.responseStreamingSupported != nil {
            // throw SwiftBedrockError.notFound(
            //     "BedrockClientTypes.FoundationModelSummary does not have responseStreamingSupported"
            // )
            responseStreamingSupported = sdkModelSummary.responseStreamingSupported!
        }
        let bedrockModel = BedrockModel(rawValue: modelId) ?? BedrockModel(rawValue: "us.\(modelId)")

        return ModelSummary(
            modelName: modelName,
            providerName: providerName,
            modelId: modelId,
            modelArn: modelArn,
            modelLifecylceStatus: status,
            responseStreamingSupported: responseStreamingSupported,
            bedrockModel: bedrockModel
        )
    }

    enum Status: Codable {
        case active
        case legacy

        init(sdkStatus: BedrockClientTypes.FoundationModelLifecycleStatus) throws {
            switch sdkStatus {
            case .active:
                self = .active
            case .legacy:
                self = .legacy
            default: throw SwiftBedrockError.notSupported("Unknown BedrockClientTypes.FoundationModelLifecycleStatus")
            }
        }
    }
}

// public struct ModelInfo: Codable {
//     let modelName: String
//     let providerName: String
//     let modelId: String
//     let modelArn: String
//     let modelLifecylce: Status
//     let inputModalities: [String]
//     // add everything that gets returned
//     // let modalitiesList: [ModalityName] -> computed value
//     // let model: BedrockModel?

//     public init(modelName: String, providerName: String, modelId: String) {
//         self.modelName = modelName
//         self.providerName = providerName
//         self.modelId = modelId
//     }

//     struct Status: Codable {
//         let status: String
//     }
// }


extension BedrockModel: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // Encode basic information
        try container.encode(name, forKey: .modelName)
        try container.encode(id, forKey: .modelId)
        try container.encode(String(describing: type(of: modality)), forKey: .supportedModality)

        if hasTextModality() {
            try encodeTextParameters(to: &container)
        }

        if hasImageModality() {
            try encodeImageParameters(to: &container)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case modelName
        case modelId
        case temperatureRange
        case maxTokenRange
        case topPRange
        case topKRange
        case nrOfImagesRange
        case cfgScaleRange
        case seedRange
        case similarityRange
        case supportedModality
    }

    private enum RangeKeys: String, CodingKey {
        case min
        case max
        case `default`
    }

    private func encodeTextParameters(to container: inout KeyedEncodingContainer<CodingKeys>) throws {
        let textModality = try getTextModality()
        let params = textModality.getParameters()

        if params.temperature.isSupported {
            var tempContainer = container.nestedContainer(keyedBy: RangeKeys.self, forKey: .temperatureRange)
            try tempContainer.encode(params.temperature.minValue, forKey: .min)
            try tempContainer.encode(params.temperature.maxValue, forKey: .max)
            try tempContainer.encode(params.temperature.defaultValue, forKey: .default)
        }
        if params.maxTokens.isSupported {
            var tokenContainer = container.nestedContainer(keyedBy: RangeKeys.self, forKey: .maxTokenRange)
            try tokenContainer.encode(params.maxTokens.minValue, forKey: .min)
            try tokenContainer.encode(params.maxTokens.maxValue, forKey: .max)
            try tokenContainer.encode(params.maxTokens.defaultValue, forKey: .default)
        }
        if params.topP.isSupported {
            var topPContainer = container.nestedContainer(keyedBy: RangeKeys.self, forKey: .topPRange)
            try topPContainer.encode(params.topP.minValue, forKey: .min)
            try topPContainer.encode(params.topP.maxValue, forKey: .max)
            try topPContainer.encode(params.topP.defaultValue, forKey: .default)
        }
        if params.topK.isSupported {
            var topKContainer = container.nestedContainer(keyedBy: RangeKeys.self, forKey: .topKRange)
            try topKContainer.encode(params.topK.minValue, forKey: .min)
            try topKContainer.encode(params.topK.maxValue, forKey: .max)
            try topKContainer.encode(params.topK.defaultValue, forKey: .default)
        }
    }

    private func encodeImageParameters(to container: inout KeyedEncodingContainer<CodingKeys>) throws {
        let imageModality = try getImageModality()
        let params = imageModality.getParameters()

        // General image generation inference parameters
        if params.nrOfImages.isSupported {
            var imagesContainer = container.nestedContainer(keyedBy: RangeKeys.self, forKey: .nrOfImagesRange)
            try imagesContainer.encode(params.nrOfImages.minValue, forKey: .min)
            try imagesContainer.encode(params.nrOfImages.maxValue, forKey: .max)
            try imagesContainer.encode(params.nrOfImages.defaultValue, forKey: .default)
        }
        if params.cfgScale.isSupported {
            var cfgScaleContainer = container.nestedContainer(keyedBy: RangeKeys.self, forKey: .cfgScaleRange)
            try cfgScaleContainer.encode(params.cfgScale.minValue, forKey: .min)
            try cfgScaleContainer.encode(params.cfgScale.maxValue, forKey: .max)
            try cfgScaleContainer.encode(params.cfgScale.defaultValue, forKey: .default)
        }
        if params.seed.isSupported {
            var seedContainer = container.nestedContainer(keyedBy: RangeKeys.self, forKey: .seedRange)
            try seedContainer.encode(params.seed.minValue, forKey: .min)
            try seedContainer.encode(params.seed.maxValue, forKey: .max)
            try seedContainer.encode(params.seed.defaultValue, forKey: .default)
        }

        // If the model supports image variation, encode similarity range
        if hasImageVariationModality() {
            let variationModality = try getImageVariationModality()
            let variationParams = variationModality.getImageVariationParameters()
            if variationParams.similarity.isSupported {
                var similarityContainer = container.nestedContainer(
                    keyedBy: RangeKeys.self,
                    forKey: .similarityRange
                )
                try similarityContainer.encode(variationParams.similarity.minValue, forKey: .min)
                try similarityContainer.encode(variationParams.similarity.maxValue, forKey: .max)
                try similarityContainer.encode(variationParams.similarity.defaultValue, forKey: .default)
            }
        }
    }
}