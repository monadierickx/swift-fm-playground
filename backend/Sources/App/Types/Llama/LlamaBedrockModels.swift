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
import SwiftBedrockTypes

extension BedrockModel {
    public static let llama3_70b_instruct: BedrockModel = BedrockModel(
        id: "meta.llama3-70b-instruct-v1:0",
        modality: LlamaText()
    )
    // public static let llama3_1_8b_instruct: BedrockModel = BedrockModel(
    //     id: "meta.llama3-1-8b-instruct-v1:0",
    //     modality: LlamaText()
    // )
    // public static let llama3_1_70b_instruct: BedrockModel = BedrockModel(
    //     id: "meta.llama3-1-70b-instruct-v1:0",
    //     modality: LlamaText()
    // )
    // public static let llama3_2_3b_instruct: BedrockModel = BedrockModel(
    //     id: "meta.llama3-2-3b-instruct-v1:0",
    //     modality: LlamaText()
    // )
}

extension BedrockModel {
    init?(llamaId: String) {
        switch llamaId {
        case "meta.llama3-70b-instruct-v1:0": self = .llama3_70b_instruct
        // case "meta.llama3-1-8b-instruct-v1:0": self = .llama3_1_8b_instruct
        // case "meta.llama3-1-70b-instruct-v1:0": self = .llama3_1_70b_instruct
        // case "meta.llama3-2-3b-instruct-v1:0": self = .llama3_2_3b_instruct
        default:
            return nil
        }
    }
}
