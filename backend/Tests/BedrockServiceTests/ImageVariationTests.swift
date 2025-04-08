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

import Testing

@testable import BedrockService
@testable import BedrockTypes

// Image variation

extension BedrockServiceTests {

    @Test(
        "Generate image variation using an implemented model",
        arguments: NovaTestConstants.imageGenerationModels
    )
    func generateImageVariationWithValidModel(model: BedrockModel) async throws {
        let mockBase64Image =
            "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
        let output: ImageGenerationOutput = try await bedrock.generateImageVariation(
            image: mockBase64Image,
            prompt: "This is a test",
            with: model,
            nrOfImages: 3
        )
        #expect(output.images.count == 3)
    }

    @Test(
        "Generate image variation using an invalid model",
        arguments: NovaTestConstants.textCompletionModels
    )
    func generateImageVariationWithInvalidModel(model: BedrockModel) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let mockBase64Image =
                "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
            let _: ImageGenerationOutput = try await bedrock.generateImageVariation(
                image: mockBase64Image,
                prompt: "This is a test",
                with: model,
                nrOfImages: 3
            )
        }
    }
}