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

// MARK: text generation
// https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-titan-text.html

typealias TitanTextPremierV1 = TitanText
typealias TitanTextExpressV1 = TitanText
typealias TitanTextLiteV1 = TitanText

extension BedrockModel {
    public static let titan_text_g1_premier: BedrockModel = BedrockModel(
        id: "amazon.titan-text-premier-v1:0",
        modality: TitanTextPremierV1(
            parameters: TextGenerationParameters(
                temperature: Parameter(minValue: 0, maxValue: 1, defaultValue: 0.7),
                maxTokens: Parameter(minValue: 0, maxValue: 3_072, defaultValue: 512),
                topP: Parameter(minValue: 0, maxValue: 1, defaultValue: 0.9)
                // topK: Parameter(minValue: Int, maxValue: Int, defaultValue: Int),
                // maxPromptSize: Int,
                // maxStopSequences: Int,
                // defaultStopSequences: [String]
            )
        )
    )
    public static let titan_text_g1_express: BedrockModel = BedrockModel(
        id: "amazon.titan-text-express-v1",
        modality: TitanTextExpressV1(
            parameters: TextGenerationParameters(
                temperature: Parameter(minValue: 0, maxValue: 1, defaultValue: 0.7),
                maxTokens: Parameter(minValue: 0, maxValue: 8_192, defaultValue: 512),
                topP: Parameter(minValue: 0, maxValue: 1, defaultValue: 0.9)
            )
        )
    )
    public static let titan_text_g1_lite: BedrockModel = BedrockModel(
        id: "amazon.titan-text-lite-v1",
        modality: TitanTextLiteV1(
            parameters: TextGenerationParameters(
                temperature: Parameter(minValue: 0, maxValue: 1, defaultValue: 0.7),
                maxTokens: Parameter(minValue: 0, maxValue: 4_096, defaultValue: 512),
                topP: Parameter(minValue: 0, maxValue: 1, defaultValue: 0.9)
            )
        )
    )
}

// MARK: image generation
// https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-titan-image.html

typealias TitanImageG1V1 = AmazonImage
typealias TitanImageG1V2 = AmazonImage

// @Sendable func validateTitanResolution(_ resolution: ImageResolution) throws {
//     // https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-titan-image.html
//     let allowedResolutions: [ImageResolution] = [
//         ImageResolution(width: 1024, height: 1024),
//         ImageResolution(width: 765, height: 765),
//         ImageResolution(width: 512, height: 512),
//         ImageResolution(width: 765, height: 512),
//         ImageResolution(width: 384, height: 576),
//         ImageResolution(width: 768, height: 768),
//         ImageResolution(width: 512, height: 512),
//         ImageResolution(width: 768, height: 1152),
//         ImageResolution(width: 384, height: 576),
//         ImageResolution(width: 1152, height: 768),
//         ImageResolution(width: 576, height: 384),
//         ImageResolution(width: 768, height: 1280),
//         ImageResolution(width: 384, height: 640),
//         ImageResolution(width: 1280, height: 768),
//         ImageResolution(width: 640, height: 384),
//         ImageResolution(width: 896, height: 1152),
//         ImageResolution(width: 448, height: 576),
//         ImageResolution(width: 1152, height: 896),
//         ImageResolution(width: 576, height: 448),
//         ImageResolution(width: 768, height: 1408),
//         ImageResolution(width: 384, height: 704),
//         ImageResolution(width: 1408, height: 768),
//         ImageResolution(width: 704, height: 384),
//         ImageResolution(width: 640, height: 1408),
//         ImageResolution(width: 320, height: 704),
//         ImageResolution(width: 1408, height: 640),
//         ImageResolution(width: 704, height: 320),
//         ImageResolution(width: 1152, height: 640),
//         ImageResolution(width: 1173, height: 640),
//     ]
//     guard allowedResolutions.contains(resolution) else {
//         throw SwiftBedrockError.invalidResolution("Resolution is not a permissible size. Resolution: \(resolution)")
//     }
// }

extension BedrockModel {
    public static let titan_image_g1_v1: BedrockModel = BedrockModel(
        id: "amazon.titan-image-generator-v1",
        modality: TitanImageG1V1(
            parameters: ImageGenerationParameters(
                nrOfImages: Parameter(minValue: 1, maxValue: 5, defaultValue: 1),
                cfgScale: Parameter(minValue: 1.1, maxValue: 10, defaultValue: 8.0),
                seed: Parameter(minValue: 0, maxValue: 2_147_483_646, defaultValue: 42)
            ),
            textToImageParameters: TextToImageParameters(maxPromptSize: 512, maxNegativePromptSize: 512),
            conditionedTextToImageParameters: ConditionedTextToImageParameters(
                maxPromptSize: 512,
                maxNegativePromptSize: 512,
                similarity: Parameter(minValue: 0, maxValue: 1.0, defaultValue: 0.7)
            ),
            imageVariationParameters: ImageVariationParameters(
                images: Parameter(minValue: 1, maxValue: 5, defaultValue: 1),
                maxPromptSize: 512,
                maxNegativePromptSize: 512,
                similarity: Parameter(minValue: 0.2, maxValue: 1.0, defaultValue: 0.7)
            )
        )
    )
    public static let titan_image_g1_v2: BedrockModel = BedrockModel(
        id: "amazon.titan-image-generator-v2:0",
        modality: TitanImageG1V2(
            parameters: ImageGenerationParameters(),
            textToImageParameters: TextToImageParameters(),
            conditionedTextToImageParameters: ConditionedTextToImageParameters(),
            imageVariationParameters: ImageVariationParameters()
        )
    )
}
