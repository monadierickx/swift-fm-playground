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
// https://docs.aws.amazon.com/nova/latest/userguide/complete-request-schema.html

typealias NovaMicro = NovaText

extension BedrockModel {
    public static let nova_micro: BedrockModel = BedrockModel(
        id: "amazon.nova-micro-v1:0",
        modality: NovaText(
            parameters: TextGenerationParameters(
                minTemperature: 0.00001,
                maxTemperature: 1,
                defaultTemperature: 0.7,
                maxMaxTokens: 5_000,
                defaultMaxTokens: 5_000,
                minTopP: 0,
                maxTopP: 1,
                defaultTopP: 0.9,
                minTopK: 0,
                maxTopK: 50
            )
        )
    )
}

// MARK: image generation

typealias NovaCanvas = AmazonImage

extension BedrockModel {
    public static let nova_canvas: BedrockModel = BedrockModel(
        id: "amazon.nova-canvas-v1:0",
        modality: NovaCanvas(
            parameters: ImageGenerationParameters(
                // maxPromptSize: Int,
                // minNrOfImages: Int,
                // maxNrOfImages: Int,
                // defaultNrOfImages: Int
            )
        )
    )
}
