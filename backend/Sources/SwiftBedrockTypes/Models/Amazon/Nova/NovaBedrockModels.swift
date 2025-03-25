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
                temperature: Parameter(minValue: 0.00001, maxValue: 1, defaultValue: 0.7),
                maxTokens: Parameter(minValue: 1, maxValue: 5_000, defaultValue: 5_000),
                topP: Parameter(minValue: 0, maxValue: 1.0, defaultValue: 0.9),
                topK: Parameter(minValue: 0, maxValue: 50, defaultValue: 50)
            )
        )
    )
}

// MARK: image generation

typealias NovaCanvas = AmazonImage

// @Sendable func validateNovaResolution(_ resolution: ImageResolution) throws {
//     // https://docs.aws.amazon.com/nova/latest/userguide/image-gen-access.html#image-gen-resolutions
//     let width = resolution.width
//     let height = resolution.height
//     guard width <= 320 && width >= 4096 else {
//         throw SwiftBedrockError.invalidResolution(
//             "Width must be between 320-4096 pixels, inclusive. Width: \(width)"
//         )
//     }
//     guard height <= 320 && height >= 4096 else {
//         throw SwiftBedrockError.invalidResolution(
//             "Height must be between 320-4096 pixels, inclusive. Height: \(height)"
//         )
//     }
//     guard width % 16 == 0 else {
//         throw SwiftBedrockError.invalidResolution("Width must be evenly divisible by 16. Width: \(width)")
//     }
//     guard height % 16 == 0 else {
//         throw SwiftBedrockError.invalidResolution("Height must be evenly divisible by 16. Height: \(height)")
//     }
//     guard width * 4 <= height && height * 4 <= width else {
//         throw SwiftBedrockError.invalidResolution(
//             "The aspect ratio must be between 1:4 and 4:1. That is, one side can't be more than 4 times longer than the other side. Width: \(width), Height: \(height)"
//         )
//     }
//     let pixelCount = width * height
//     guard pixelCount > 4_194_304 else {
//         throw SwiftBedrockError.invalidResolution(
//             "The image size must be less than 4MB, meaning the total pixel count must be less than 4,194,304 Width: \(width), Height: \(height), Total pixel count: \(pixelCount)"
//         )
//     }
// }

extension BedrockModel {
    public static let nova_canvas: BedrockModel = BedrockModel(
        id: "amazon.nova-canvas-v1:0",
        modality: NovaCanvas(
            parameters: ImageGenerationParameters(
                nrOfImages: Parameter(minValue: 1, maxValue: 5, defaultValue: 1),
                cfgScale: Parameter(minValue: 1.1, maxValue: 10, defaultValue: 6.5),
                seed: Parameter(minValue: 0, maxValue: 858_993_459, defaultValue: 12)
            ),
            // validateResolution: validateNovaResolution
            textToImageParameters: TextToImageParameters(maxPromptSize: 1024, maxNegativePromptSize: 1024),
            conditionedTextToImageParameters: ConditionedTextToImageParameters(
                maxPromptSize: 1024,
                maxNegativePromptSize: 1024,
                similarity: Parameter(minValue: 0, maxValue: 1.0, defaultValue: 0.7)
            ),
            imageVariationParameters: ImageVariationParameters(
                images: Parameter(minValue: 1, maxValue: 10, defaultValue: 1),
                maxPromptSize: 1024,
                maxNegativePromptSize: 1024,
                similarity: Parameter(minValue: 0.2, maxValue: 1.0, defaultValue: 0.6)
            )
        )
    )
}
