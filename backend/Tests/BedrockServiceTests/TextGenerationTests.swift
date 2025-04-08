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

// Text completion

extension BedrockServiceTests {

    @Test(
        "Complete text using an implemented model and no parameters",
        arguments: NovaTestConstants.textCompletionModels
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
        arguments: NovaTestConstants.imageGenerationModels
    )
    func completeTextWithInvalidModel(model: BedrockModel) async throws {
        await #expect(throws: BedrockServiceError.self) {
            let _: TextCompletion = try await bedrock.completeText(
                "This is a test",
                with: model
            )
        }
    }

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

}
