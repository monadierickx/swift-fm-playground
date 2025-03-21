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
                minTemperature: 0,
                maxTemperature: 1,
                defaultTemperature: 0.7,
                maxMaxTokens: 3_072,
                defaultMaxTokens: 512,
                minTopP: 0,
                maxTopP: 1,
                defaultTopP: 0.9
            )
        )
    )
    public static let titan_text_g1_express: BedrockModel = BedrockModel(
        id: "amazon.titan-text-express-v1",
        modality: TitanTextExpressV1(
            parameters: TextGenerationParameters(
                minTemperature: 0,
                maxTemperature: 1,
                defaultTemperature: 0.7,
                maxMaxTokens: 8_192,
                defaultMaxTokens: 512,
                minTopP: 0,
                maxTopP: 1,
                defaultTopP: 0.9
            )
        )
    )
    public static let titan_text_g1_lite: BedrockModel = BedrockModel(
        id: "amazon.titan-text-lite-v1",
        modality: TitanTextLiteV1(
            parameters: TextGenerationParameters(
                minTemperature: 0,
                maxTemperature: 1,
                defaultTemperature: 0.7,
                maxMaxTokens: 4_096,
                defaultMaxTokens: 512,
                minTopP: 0,
                maxTopP: 1,
                defaultTopP: 0.9
            )
        )
    )
}

// MARK: image generation
// https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-titan-image.html

typealias TitanImageG1V1 = AmazonImage
typealias TitanImageG1V2 = AmazonImage

extension BedrockModel {
    public static let titan_image_g1_v1: BedrockModel = BedrockModel(
        id: "amazon.titan-image-generator-v1",
        modality: TitanImageG1V1(
            parameters:
                ImageGenerationParameters(
                    minNrOfImages: 1,
                    maxNrOfImages: 5,
                    defaultNrOfImages: 1
                )
        )
    )
    public static let titan_image_g1_v2: BedrockModel = BedrockModel(
        id: "amazon.titan-image-generator-v2:0",
        modality: TitanImageG1V2(
            parameters:
                ImageGenerationParameters(
                minNrOfImages: 1,
                maxNrOfImages: 5,
                defaultNrOfImages: 1
                )
        )
    )
}
