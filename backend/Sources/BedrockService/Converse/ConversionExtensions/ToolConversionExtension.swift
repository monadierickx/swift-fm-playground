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


extension ToolStatus {
    init(from sdkToolStatus: BedrockRuntimeClientTypes.ToolResultStatus) throws {
        switch sdkToolStatus {
        case .success: self = .success
        case .error: self = .error
        case .sdkUnknown(let unknownToolStatus):
            throw BedrockServiceError.notImplemented(
                "ToolResultStatus \(unknownToolStatus) is not implemented by BedrockRuntimeClientTypes"
            )
        }
    }

    func getSDKToolStatus() -> BedrockRuntimeClientTypes.ToolResultStatus {
        switch self {
        case .success: .success
        case .error: .error
        }
    }
}

extension ToolResultContent {
    init(from sdkToolResultContent: BedrockRuntimeClientTypes.ToolResultContentBlock) throws {
        switch sdkToolResultContent {
        case .document(let sdkDocumentBlock):
            self = .document(try DocumentBlock(from: sdkDocumentBlock))
        case .image(let sdkImageBlock):
            self = .image(try ImageBlock(from: sdkImageBlock))
        case .text(let text):
            self = .text(text)
        case .video(let sdkVideoBlock):
            self = .video(try VideoBlock(from: sdkVideoBlock))
        // case .json(let sdkJSON):
        //     self = .json()
        case .sdkUnknown(let unknownToolResultContent):
            throw BedrockServiceError.notImplemented(
                "ToolResultContentBlock \(unknownToolResultContent) is not implemented by BedrockRuntimeClientTypes"
            )
        default:
            throw BedrockServiceError.notImplemented(
                "ToolResultContentBlock \(sdkToolResultContent) is not implemented by BedrockTypes"
            )
        }
    }
}
