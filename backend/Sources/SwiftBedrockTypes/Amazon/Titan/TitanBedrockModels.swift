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

typealias TitanTextPremierV1 = TitanText
typealias TitanTextExpressV1 = TitanText
typealias TitanTextLiteV1 = TitanText

extension BedrockModel {
    public static let titan_text_g1_premier: BedrockModel = BedrockModel(
        id: "amazon.titan-text-premier-v1:0",
        modality: TitanTextPremierV1()
    )
    public static let titan_text_g1_express: BedrockModel = BedrockModel(
        id: "amazon.titan-text-express-v1",
        modality: TitanTextExpressV1()
    )
    public static let titan_text_g1_lite: BedrockModel = BedrockModel(
        id: "amazon.titan-text-lite-v1",
        modality: TitanTextLiteV1()
    )
}

// MARK: image generation

typealias TitanImageG1V1 = AmazonImage
typealias TitanImageG1V2 = AmazonImage

extension BedrockModel {
    public static let titan_image_g1_v1: BedrockModel = BedrockModel(
        id: "amazon.titan-image-generator-v1",
        modality: TitanImageG1V1()
    )
    public static let titan_image_g1_v2: BedrockModel = BedrockModel(
        id: "amazon.titan-image-generator-v2:0",
        modality: TitanImageG1V2()
    )
}
