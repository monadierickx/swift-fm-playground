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

// For the parameter tests the Nova models are used as an example
@Suite("BedrockService Model Parameter Tests")
struct BedrockServiceParameterTests {
    let bedrock: BedrockService

    init() async throws {
        self.bedrock = try await BedrockService(
            bedrockClient: MockBedrockClient(),
            bedrockRuntimeClient: MockBedrockRuntimeClient()
        )
    }

    // MARK: constants based on the Nova parameters
    static let validTemperature = [0.00001, 0.2, 0.6, 1]
    static let invalidTemperature = [-2.5, -1, 0, 1.00001, 2]
    static let validMaxTokens = [1, 10, 100, 5_000]
    static let invalidMaxTokens = [0, -2, 5_001]
    static let validTopP = [0.00001, 0.2, 0.6, 1]
    static let invalidTopP = [-2.5, -1, 0, 1.00001, 2]
    static let validTopK = [0, 50]
    static let invalidTopK = [-1]
    static let validStopSequences = [
        ["\n\nHuman:"],
        ["\n\nHuman:", "\n\nAI:"],
        ["\n\nHuman:", "\n\nAI:", "\n\nHuman:"],
    ]
    static let validPrompts = [
        "This is a test",
        "!@#$%^&*()_+{}|:<>?",
        String(repeating: "test ", count: 10),
    ]
    static let invalidPrompts = [
        "", " ", " \n  ", "\t",
    ]

    static let validNrOfImages = [1, 2, 3, 4, 5]
    static let invalidNrOfImages = [-4, 0, 6, 20]
    static let validSimilarity = [0.2, 0.5, 1]
    static let invalidSimilarity = [-4, 0, 0.1, 1.1, 2]

    static let textCompletionModels = [
        BedrockModel.nova_micro
    ]
    static let imageGenerationModels = [
        BedrockModel.titan_image_g1_v1,
        BedrockModel.titan_image_g1_v2,
        BedrockModel.nova_canvas,
    ]

    // MARK: completeText

    @Test(
        "Complete text using an implemented model",
        arguments: textCompletionModels
    )
    func completeTextWithValidModel(model: BedrockModel) async throws {
        let completion: TextCompletion = try await bedrock.completeText(
            "This is a test",
            with: model
        )
        #expect(completion.completion == "This is the textcompletion for: This is a test")
    }

    @Test(
        "Complete text using an invalid model",
        arguments: imageGenerationModels
    )
    func completeTextWithInvalidModel(model: BedrockModel) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let _: TextCompletion = try await bedrock.completeText(
                "This is a test",
                with: model,
                temperature: 0.8
            )
        }
    }

    @Test("Complete text using a valid temperature", arguments: validTemperature)
    func completeTextWithValidTemperature(temperature: Double) async throws {
        let completion: TextCompletion = try await bedrock.completeText(
            "This is a test",
            with: BedrockModel.nova_micro,
            temperature: temperature
        )
        #expect(completion.completion == "This is the textcompletion for: This is a test")
    }

    @Test("Complete text using an invalid temperature", arguments: invalidTemperature)
    func completeTextWithInvalidTemperature(temperature: Double) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let _: TextCompletion = try await bedrock.completeText(
                "This is a test",
                with: BedrockModel.nova_micro,
                temperature: temperature
            )
        }
    }

    @Test(
        "Complete text using a valid maxTokens",
        arguments: validMaxTokens
    )
    func completeTextWithValidMaxTokens(maxTokens: Int) async throws {
        let completion: TextCompletion = try await bedrock.completeText(
            "This is a test",
            with: BedrockModel.nova_micro,
            maxTokens: maxTokens
        )
        #expect(completion.completion == "This is the textcompletion for: This is a test")
    }

    @Test(
        "Complete text using an invalid maxTokens",
        arguments: invalidMaxTokens
    )
    func completeTextWithInvalidMaxTokens(maxTokens: Int) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let _: TextCompletion = try await bedrock.completeText(
                "This is a test",
                with: BedrockModel.nova_micro,
                maxTokens: maxTokens
            )
        }
    }

    @Test(
        "Complete text using a valid prompt",
        arguments: validPrompts
    )
    func completeTextWithValidPrompt(prompt: String) async throws {
        let completion: TextCompletion = try await bedrock.completeText(
            prompt,
            with: BedrockModel.nova_micro,
            maxTokens: 200
        )
        #expect(completion.completion == "This is the textcompletion for: \(prompt)")
    }

    @Test(
        "Complete text using an invalid prompt",
        arguments: invalidPrompts
    )
    func completeTextWithInvalidPrompt(prompt: String) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let _: TextCompletion = try await bedrock.completeText(
                prompt,
                with: BedrockModel.nova_micro,
                maxTokens: 10
            )
        }
    }

    // MARK: generateImage

    @Test(
        "Generate image using an implemented model",
        arguments: imageGenerationModels
    )
    func generateImageWithValidModel(model: BedrockModel) async throws {
        let output: ImageGenerationOutput = try await bedrock.generateImage(
            "This is a test",
            with: model
        )
        #expect(output.images.count == 1)
    }

    @Test(
        "Generate image using an implemented model",
        arguments: textCompletionModels
    )
    func generateImageWithInvalidModel(model: BedrockModel) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let _: ImageGenerationOutput = try await bedrock.generateImage(
                "This is a test",
                with: model,
                nrOfImages: 3
            )
        }
    }

    @Test(
        "Generate image using a valid nrOfImages",
        arguments: validNrOfImages
    )
    func generateImageWithValidNrOfImages(nrOfImages: Int) async throws {
        let output: ImageGenerationOutput = try await bedrock.generateImage(
            "This is a test",
            with: BedrockModel.nova_canvas,
            nrOfImages: nrOfImages
        )
        #expect(output.images.count == nrOfImages)
    }

    @Test(
        "Generate image using an invalid nrOfImages",
        arguments: invalidNrOfImages
    )
    func generateImageWithInvalidNrOfImages(nrOfImages: Int) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let _: ImageGenerationOutput = try await bedrock.generateImage(
                "This is a test",
                with: BedrockModel.nova_canvas,
                nrOfImages: nrOfImages
            )
        }
    }

    @Test(
        "Generate image using a valid prompt",
        arguments: validPrompts
    )
    func generateImageWithValidPrompt(prompt: String) async throws {
        let output: ImageGenerationOutput = try await bedrock.generateImage(
            prompt,
            with: BedrockModel.nova_canvas,
            nrOfImages: 3
        )
        #expect(output.images.count == 3)
    }

    @Test(
        "Generate image using an invalid prompt",
        arguments: invalidPrompts
    )
    func generateImageWithInvalidPrompt(prompt: String) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let _: ImageGenerationOutput = try await bedrock.generateImage(
                prompt,
                with: BedrockModel.nova_canvas
            )
        }
    }

    // MARK: generateImageVariation

    @Test(
        "Generate image variation using an implemented model",
        arguments: imageGenerationModels
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
        arguments: textCompletionModels
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

    @Test(
        "Generate image variation using a valid nrOfImages",
        arguments: validNrOfImages
    )
    func generateImageVariationWithValidNrOfImages(nrOfImages: Int) async throws {
        let mockBase64Image =
            "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
        let output: ImageGenerationOutput = try await bedrock.generateImageVariation(
            image: mockBase64Image,
            prompt: "This is a test",
            with: BedrockModel.nova_canvas,
            nrOfImages: nrOfImages
        )
        #expect(output.images.count == nrOfImages)
    }

    @Test(
        "Generate image variation using an invalid nrOfImages",
        arguments: invalidNrOfImages
    )
    func generateImageVariationWithInvalidNrOfImages(nrOfImages: Int) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let mockBase64Image =
                "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
            let _: ImageGenerationOutput = try await bedrock.generateImageVariation(
                image: mockBase64Image,
                prompt: "This is a test",
                with: BedrockModel.nova_canvas,
                nrOfImages: nrOfImages
            )
        }
    }

    @Test(
        "Generate image variation using a valid similarity",
        arguments: validSimilarity
    )
    func generateImageVariationWithValidNr(similarity: Double) async throws {
        let mockBase64Image =
            "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
        let output: ImageGenerationOutput = try await bedrock.generateImageVariation(
            image: mockBase64Image,
            prompt: "This is a test",
            with: BedrockModel.nova_canvas,
            similarity: similarity,
            nrOfImages: 3
        )
        #expect(output.images.count == 3)
    }

    @Test(
        "Generate image variation using an invalid similarity",
        arguments: invalidSimilarity
    )
    func generateImageVariationWithInvalidNrOfImages(similarity: Double) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let mockBase64Image =
                "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
            let _: ImageGenerationOutput = try await bedrock.generateImageVariation(
                image: mockBase64Image,
                prompt: "This is a test",
                with: BedrockModel.nova_canvas,
                similarity: similarity,
                nrOfImages: 3
            )
        }
    }

    @Test(
        "Generate image variation using a valid prompt",
        arguments: validPrompts
    )
    func generateImageVariationWithValidPrompt(prompt: String) async throws {
        let mockBase64Image =
            "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
        let output: ImageGenerationOutput = try await bedrock.generateImageVariation(
            image: mockBase64Image,
            prompt: prompt,
            with: BedrockModel.nova_canvas,
            similarity: 0.6
        )
        #expect(output.images.count == 1)
    }

    @Test(
        "Generate image variation using an invalid prompt",
        arguments: invalidPrompts
    )
    func generateImageVariationWithInvalidPrompt(prompt: String) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let mockBase64Image =
                "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
            let _: ImageGenerationOutput = try await bedrock.generateImageVariation(
                image: mockBase64Image,
                prompt: prompt,
                with: BedrockModel.nova_canvas,
                similarity: 0.6
            )
        }
    }

    // MARK: converse

    @Test(
        "Continue conversation using a valid prompt",
        arguments: validPrompts
    )
    func converseWithValidPrompt(prompt: String) async throws {
        let (output, _) = try await bedrock.converse(
            with: BedrockModel.nova_micro,
            prompt: prompt
        )
        #expect(output == "Your prompt was: \(prompt)")
    }

    @Test(
        "Continue conversation variation using an invalid prompt",
        arguments: invalidPrompts
    )
    func converseWithInvalidPrompt(prompt: String) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let _ = try await bedrock.converse(
                with: BedrockModel.nova_micro,
                prompt: prompt
            )
        }
    }
}
