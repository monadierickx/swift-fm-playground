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

@preconcurrency import AWSBedrockRuntime
import BedrockTypes
import Foundation

extension ToolUseBlock {
    init(from sdkToolUseBlock: BedrockRuntimeClientTypes.ToolUseBlock) throws {
        guard let sdkId = sdkToolUseBlock.toolUseId else {
            throw BedrockServiceError.decodingError(
                "Could not extract toolUseId from BedrockRuntimeClientTypes.ToolUseBlock"
            )
        }
        guard let sdkName = sdkToolUseBlock.name else {
            throw BedrockServiceError.decodingError(
                "Could not extract name from BedrockRuntimeClientTypes.ToolUseBlock"
            )
        }
        self = ToolUseBlock(
            id: sdkId,
            name: sdkName
            // input: sdkToolUseBlock.input
        )
    }

    func getSDKToolUseBlock() throws -> BedrockRuntimeClientTypes.ToolUseBlock {
        .init(
            name: name,
            toolUseId: id
            // input: input
        )
    }
}