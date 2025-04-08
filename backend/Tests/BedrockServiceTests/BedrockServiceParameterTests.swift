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

    // models
    static let textCompletionModels = [
        BedrockModel.nova_micro,
        BedrockModel.nova_lite,
        BedrockModel.nova_pro,
    ]
    static let imageGenerationModels = [
        BedrockModel.titan_image_g1_v1,
        BedrockModel.titan_image_g1_v2,
        BedrockModel.nova_canvas,
    ]

    // MARK: completeText

    // Models
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

    // Parameter combinations
    @Test(
        "Complete text using an implemented model and a valid combination of parameters"
    )
    func completeTextWithValidModelValidParameters() async throws {
        let completion: TextCompletion = try await bedrock.completeText(
            "This is a test",
            with: BedrockModel.nova_micro,
            maxTokens: 512,
            temperature: 0.5,
            topK: 10,
            stopSequences: ["END", "\n\nHuman:"]
        )
        #expect(completion.completion == "This is the textcompletion for: This is a test")
    }

    @Test(
        "Complete text using an implemented model and an invalid combination of parameters"
    )
    func completeTextWithInvalidModelInvalidParameters() async throws {
        await #expect(throws: BedrockServiceError.self) {
            let _: TextCompletion = try await bedrock.completeText(
                "This is a test",
                with: BedrockModel.nova_lite,
                temperature: 0.5,
                topP: 0.5
            )
        }
    }

    // Temperature
    @Test("Complete text using a valid temperature", arguments: NovaTestConstants.TextGeneration.validTemperature)
    func completeTextWithValidTemperature(temperature: Double) async throws {
        let completion: TextCompletion = try await bedrock.completeText(
            "This is a test",
            with: BedrockModel.nova_micro,
            temperature: temperature
        )
        #expect(completion.completion == "This is the textcompletion for: This is a test")
    }

    @Test("Complete text using an invalid temperature", arguments: NovaTestConstants.TextGeneration.invalidTemperature)
    func completeTextWithInvalidTemperature(temperature: Double) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let _: TextCompletion = try await bedrock.completeText(
                "This is a test",
                with: BedrockModel.nova_micro,
                temperature: temperature
            )
        }
    }

    // MaxTokens
    @Test(
        "Complete text using a valid maxTokens",
        arguments: NovaTestConstants.TextGeneration.validMaxTokens
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
        arguments: NovaTestConstants.TextGeneration.invalidMaxTokens
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

    // TopP
    @Test(
        "Complete text using a valid topP",
        arguments: NovaTestConstants.TextGeneration.validTopP
    )
    func completeTextWithValidTopP(topP: Double) async throws {
        let completion: TextCompletion = try await bedrock.completeText(
            "This is a test",
            with: BedrockModel.nova_micro,
            topP: topP
        )
        #expect(completion.completion == "This is the textcompletion for: This is a test")
    }

    @Test(
        "Complete text using an invalid topP",
        arguments: NovaTestConstants.TextGeneration.invalidTopP
    )
    func completeTextWithInvalidMaxTokens(topP: Double) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let _: TextCompletion = try await bedrock.completeText(
                "This is a test",
                with: BedrockModel.nova_micro,
                topP: topP
            )
        }
    }

    // TopK
    @Test(
        "Complete text using a valid topK",
        arguments: NovaTestConstants.TextGeneration.validTopK
    )
    func completeTextWithValidTopK(topK: Int) async throws {
        let completion: TextCompletion = try await bedrock.completeText(
            "This is a test",
            with: BedrockModel.nova_micro,
            topK: topK
        )
        #expect(completion.completion == "This is the textcompletion for: This is a test")
    }

    @Test(
        "Complete text using an invalid topK",
        arguments: NovaTestConstants.TextGeneration.invalidTopK
    )
    func completeTextWithInvalidTopK(topK: Int) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let _: TextCompletion = try await bedrock.completeText(
                "This is a test",
                with: BedrockModel.nova_micro,
                topK: topK
            )
        }
    }

    // StopSequences
    @Test(
        "Complete text using valid stopSequences",
        arguments: NovaTestConstants.TextGeneration.validStopSequences
    )
    func completeTextWithValidMaxTokens(stopSequences: [String]) async throws {
        let completion: TextCompletion = try await bedrock.completeText(
            "This is a test",
            with: BedrockModel.nova_micro,
            stopSequences: stopSequences
        )
        #expect(completion.completion == "This is the textcompletion for: This is a test")
    }

    // Prompt
    @Test(
        "Complete text using a valid prompt",
        arguments: NovaTestConstants.TextGeneration.validPrompts
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
        arguments: NovaTestConstants.TextGeneration.invalidPrompts
    )
    func completeTextWithInvalidPrompt(prompt: String) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let _: TextCompletion = try await bedrock.completeText(
                prompt,
                with: BedrockModel.nova_canvas,
                maxTokens: 10
            )
        }
    }

    // MARK: generateImage

    // Models
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
        "Generate image using a wrong model",
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

    // NrOfmages
    @Test(
        "Generate image using a valid nrOfImages",
        arguments: NovaTestConstants.ImageGeneration.validNrOfImages
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
        arguments: NovaTestConstants.ImageGeneration.invalidNrOfImages
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

    // CfgScale
    @Test(
        "Generate image using a valid cfgScale",
        arguments: NovaTestConstants.ImageGeneration.validCfgScale
    )
    func generateImageWithValidCfgScale(cfgScale: Double) async throws {
        let output: ImageGenerationOutput = try await bedrock.generateImage(
            "This is a test",
            with: BedrockModel.nova_canvas,
            cfgScale: cfgScale
        )
        #expect(output.images.count == 1)
    }

    @Test(
        "Generate image using an invalid cfgScale",
        arguments: NovaTestConstants.ImageGeneration.invalidCfgScale
    )
    func generateImageWithInvalidCfgScale(cfgScale: Double) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let _: ImageGenerationOutput = try await bedrock.generateImage(
                "This is a test",
                with: BedrockModel.nova_canvas,
                cfgScale: cfgScale
            )
        }
    }

    // Seed
    @Test(
        "Generate image using a valid seed",
        arguments: NovaTestConstants.ImageGeneration.validSeed
    )
    func generateImageWithValidSeed(seed: Int) async throws {
        let output: ImageGenerationOutput = try await bedrock.generateImage(
            "This is a test",
            with: BedrockModel.nova_canvas,
            seed: seed
        )
        #expect(output.images.count == 1)
    }

    @Test(
        "Generate image using an invalid seed",
        arguments: NovaTestConstants.ImageGeneration.invalidSeed
    )
    func generateImageWithInvalidSeed(seed: Int) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let _: ImageGenerationOutput = try await bedrock.generateImage(
                "This is a test",
                with: BedrockModel.nova_canvas,
                seed: seed
            )
        }
    }

    // Prompt
    @Test(
        "Generate image using a valid prompt",
        arguments: NovaTestConstants.ImageGeneration.validImagePrompts
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
        arguments: NovaTestConstants.ImageGeneration.invalidImagePrompts
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

    // Models
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

    // NrOfImages
    @Test(
        "Generate image variation using a valid nrOfImages",
        arguments: NovaTestConstants.ImageGeneration.validNrOfImages
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
        arguments: NovaTestConstants.ImageGeneration.invalidNrOfImages
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

    // Similarity
    @Test(
        "Generate image variation using a valid similarity",
        arguments: NovaTestConstants.ImageVariation.validSimilarity
    )
    func generateImageVariationWithValidSimilarity(similarity: Double) async throws {
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
        arguments: NovaTestConstants.ImageVariation.invalidSimilarity
    )
    func generateImageVariationWithInvalidSimilarity(similarity: Double) async throws {
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

    // Number of reference images
    @Test(
        "Generate image variation using a valid number of reference images",
        arguments: NovaTestConstants.ImageVariation.validNrOfReferenceImages
    )
    func generateImageVariationWithValidNrOfReferenceImages(nrOfReferenceImages: Int) async throws {
        let mockBase64Image =
            "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
        let mockImages = Array(repeating: mockBase64Image, count: nrOfReferenceImages)
        let output: ImageGenerationOutput = try await bedrock.generateImageVariation(
            images: mockImages,
            prompt: "This is a test",
            with: BedrockModel.nova_canvas
        )
        #expect(output.images.count == 1)
    }

    @Test(
        "Generate image variation using an invalid number of reference images",
        arguments: NovaTestConstants.ImageVariation.invalidNrOfReferenceImages
    )
    func generateImageVariationWithInvalidNrOfReferenceImages(nrOfReferenceImages: Int) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let mockBase64Image =
                "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="
            let mockImages = Array(repeating: mockBase64Image, count: nrOfReferenceImages)
            let _: ImageGenerationOutput = try await bedrock.generateImageVariation(
                images: mockImages,
                prompt: "This is a test",
                with: BedrockModel.nova_canvas
            )
        }
    }

    // Prompt
    @Test(
        "Generate image variation using a valid prompt",
        arguments: NovaTestConstants.ImageGeneration.validImagePrompts
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
        arguments: NovaTestConstants.ImageGeneration.invalidImagePrompts
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

    // Prompt
    @Test(
        "Continue conversation using a valid prompt",
        arguments: NovaTestConstants.TextGeneration.validPrompts
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
        arguments: NovaTestConstants.TextGeneration.invalidPrompts
    )
    func converseWithInvalidPrompt(prompt: String) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let _ = try await bedrock.converse(
                with: BedrockModel.nova_micro,
                prompt: prompt
            )
        }
    }

    // Temperature
    @Test(
        "Continue conversation using a valid temperature",
        arguments: NovaTestConstants.TextGeneration.validTemperature
    )
    func converseWithValidTemperature(temperature: Double) async throws {
        let prompt = "This is a test"
        let (output, _) = try await bedrock.converse(
            with: BedrockModel.nova_micro,
            prompt: prompt,
            temperature: temperature
        )
        #expect(output == "Your prompt was: \(prompt)")
    }

    @Test(
        "Continue conversation variation using an invalid temperature",
        arguments: NovaTestConstants.TextGeneration.invalidTemperature
    )
    func converseWithInvalidTemperature(temperature: Double) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let prompt = "This is a test"
            let _ = try await bedrock.converse(
                with: BedrockModel.nova_micro,
                prompt: prompt,
                temperature: temperature
            )
        }
    }

    // MaxTokens
    @Test(
        "Continue conversation using a valid maxTokens",
        arguments: NovaTestConstants.TextGeneration.validMaxTokens
    )
    func converseWithValidMaxTokens(maxTokens: Int) async throws {
        let prompt = "This is a test"
        let (output, _) = try await bedrock.converse(
            with: BedrockModel.nova_micro,
            prompt: prompt,
            maxTokens: maxTokens
        )
        #expect(output == "Your prompt was: \(prompt)")
    }

    @Test(
        "Continue conversation variation using an invalid maxTokens",
        arguments: NovaTestConstants.TextGeneration.invalidMaxTokens
    )
    func converseWithInvalidMaxTokens(maxTokens: Int) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let prompt = "This is a test"
            let _ = try await bedrock.converse(
                with: BedrockModel.nova_micro,
                prompt: prompt,
                maxTokens: maxTokens
            )
        }
    }

    // TopP
    @Test(
        "Continue conversation using a valid temperature",
        arguments: NovaTestConstants.TextGeneration.validTopP
    )
    func converseWithValidTopP(topP: Double) async throws {
        let prompt = "This is a test"
        let (output, _) = try await bedrock.converse(
            with: BedrockModel.nova_micro,
            prompt: prompt,
            topP: topP
        )
        #expect(output == "Your prompt was: \(prompt)")
    }

    @Test(
        "Continue conversation variation using an invalid temperature",
        arguments: NovaTestConstants.TextGeneration.invalidTopP
    )
    func converseWithInvalidTopP(topP: Double) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let prompt = "This is a test"
            let _ = try await bedrock.converse(
                with: BedrockModel.nova_micro,
                prompt: prompt,
                topP: topP
            )
        }
    }

    // StopSequences
    @Test(
        "Continue conversation using a valid stopSequences",
        arguments: NovaTestConstants.TextGeneration.validStopSequences
    )
    func converseWithValidTopK(stopSequences: [String]) async throws {
        let prompt = "This is a test"
        let (output, _) = try await bedrock.converse(
            with: BedrockModel.nova_micro,
            prompt: prompt,
            stopSequences: stopSequences
        )
        #expect(output == "Your prompt was: \(prompt)")
    }
}
