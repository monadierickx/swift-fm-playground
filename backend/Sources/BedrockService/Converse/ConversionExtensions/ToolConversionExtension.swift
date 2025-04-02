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
import Smithy

extension Tool {
    init(from sdkToolSpecification: BedrockRuntimeClientTypes.ToolSpecification) throws {
        guard let name = sdkToolSpecification.name else {
            throw BedrockServiceError.decodingError(
                "Could not extract name from BedrockRuntimeClientTypes.ToolSpecification"
            )
        }
        guard let sdkInputSchema = sdkToolSpecification.inputSchema else {
            throw BedrockServiceError.decodingError(
                "Could not extract inputSchema from BedrockRuntimeClientTypes.ToolSpecification"
            )
        }
        guard case .json(let smithyDocument) = sdkInputSchema else {
            throw BedrockServiceError.decodingError(
                "Could not extract JSON from BedrockRuntimeClientTypes.ToolSpecification.inputSchema"
            )
        }
        let inputSchema = try smithyDocument.toJSON()
        self = Tool(
            name: name,
            inputSchema: inputSchema,
            description: sdkToolSpecification.description
        )
    }

    func getSDKToolSpecification() throws -> BedrockRuntimeClientTypes.ToolSpecification {
        BedrockRuntimeClientTypes.ToolSpecification(
            description: description,
            inputSchema: .json(try inputSchema.toDocument()),
            name: name
        )
    }
}

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
        guard let sdkInput = sdkToolUseBlock.input else {
            throw BedrockServiceError.decodingError(
                "Could not extract input from BedrockRuntimeClientTypes.ToolUseBlock"
            )
        }
        self = ToolUseBlock(
            id: sdkId,
            name: sdkName,
            input: try sdkInput.toJSON()
        )
    }

    func getSDKToolUseBlock() throws -> BedrockRuntimeClientTypes.ToolUseBlock {
        .init(
            input: try input.toDocument(),
            name: name,
            toolUseId: id
        )
    }
}

extension ToolResultBlock {
    init(from sdkToolResultBlock: BedrockRuntimeClientTypes.ToolResultBlock) throws {
        guard let sdkToolResultContent = sdkToolResultBlock.content else {
            throw BedrockServiceError.decodingError(
                "Could not extract content from BedrockRuntimeClientTypes.ToolResultBlock"
            )
        }
        guard let id = sdkToolResultBlock.toolUseId else {
            throw BedrockServiceError.decodingError(
                "Could not extract toolUseId from BedrockRuntimeClientTypes.ToolResultBlock"
            )
        }
        let sdkToolStatus: BedrockRuntimeClientTypes.ToolResultStatus? = sdkToolResultBlock.status
        var status: ToolStatus? = nil
        if let sdkToolStatus = sdkToolStatus {
            status = try ToolStatus(from: sdkToolStatus)
        }
        let toolContents = try sdkToolResultContent.map { try ToolResultContent(from: $0) }
        self = ToolResultBlock(id: id, content: toolContents, status: status)
    }

    func getSDKToolResultBlock() throws -> BedrockRuntimeClientTypes.ToolResultBlock {
        BedrockRuntimeClientTypes.ToolResultBlock(
            content: try content.map { try $0.getSDKToolResultContentBlock() },
            status: status?.getSDKToolStatus(),
            toolUseId: id
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
        case .json(let document):
            self = .json(try document.toJSON())
        // case .json(let document):
        //     self = .json(document.data(using: .utf8))
        case .sdkUnknown(let unknownToolResultContent):
            throw BedrockServiceError.notImplemented(
                "ToolResultContentBlock \(unknownToolResultContent) is not implemented by BedrockRuntimeClientTypes"
            )
        // default:
        //     throw BedrockServiceError.notImplemented(
        //         "ToolResultContentBlock \(sdkToolResultContent) is not implemented by BedrockTypes"
        //     )
        }
    }

    func getSDKToolResultContentBlock() throws -> BedrockRuntimeClientTypes.ToolResultContentBlock {
        switch self {
        // case .json(let data):
        //     .json(try Document.make(from: data))
        case .json(let json):
            .json(try json.toDocument())
        case .document(let documentBlock):
            .document(try documentBlock.getSDKDocumentBlock())
        case .image(let imageBlock):
            .image(try imageBlock.getSDKImageBlock())
        case .text(let text):
            .text(text)
        case .video(let videoBlock):
            .video(try videoBlock.getSDKVideoBlock())
        }
    }
}
