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

extension BedrockModel {
    public static let llama_3_8b_instruct: BedrockModel = BedrockModel(
        id: "meta.llama3-8b-instruct-v1:0",
        modality: LlamaText(
            parameters: TextGenerationParameters()
        )
    )
    public static let llama3_70b_instruct: BedrockModel = BedrockModel(
        id: "meta.llama3-70b-instruct-v1:0",
        modality: LlamaText(
            parameters: TextGenerationParameters()
        )
    )
    public static let llama3_1_8b_instruct: BedrockModel = BedrockModel(
        id: "us.meta.llama3-1-8b-instruct-v1:0",
        modality: LlamaText(
            parameters: TextGenerationParameters()
        )
    )
    public static let llama3_1_70b_instruct: BedrockModel = BedrockModel(
        id: "us.meta.llama3-1-70b-instruct-v1:0",
        modality: LlamaText(
            parameters: TextGenerationParameters()

        )
    )
    public static let llama3_2_1b_instruct: BedrockModel = BedrockModel(
        id: "us.meta.llama3-2-1b-instruct-v1:0",
        modality: LlamaText(
            parameters: TextGenerationParameters()

        )
    )
    public static let llama3_2_3b_instruct: BedrockModel = BedrockModel(
        id: "us.meta.llama3-2-3b-instruct-v1:0",
        modality: LlamaText(
            parameters: TextGenerationParameters()

        )
    )
    public static let llama3_3_70b_instruct: BedrockModel = BedrockModel(
        id: "us.meta.llama3-3-70b-instruct-v1:0",
        modality: LlamaText(
            parameters: TextGenerationParameters()

        )
    )
    public static let llama3_8b_instruct: BedrockModel = BedrockModel(
        id: "meta.llama3-8b-instruct-v1:0",
        modality: LlamaText(
            parameters: TextGenerationParameters()

        )
    )
}
