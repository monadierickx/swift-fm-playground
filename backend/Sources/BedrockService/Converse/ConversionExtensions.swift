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

extension Message {

    init(from sdkMessage: BedrockRuntimeClientTypes.Message) throws {
        guard let sdkRole = sdkMessage.role else {
            throw BedrockServiceError.decodingError("Could not extract role from BedrockRuntimeClientTypes.Message")
        }
        guard let sdkContent = sdkMessage.content else {
            throw BedrockServiceError.decodingError("Could not extract content from BedrockRuntimeClientTypes.Message")
        }
        let content: [Content] = try sdkContent.map { try Content(from: $0) }
        self = Message(from: try Role(from: sdkRole), content: content)
    }

    func getSDKMessage() throws -> BedrockRuntimeClientTypes.Message {
        let contentBlocks: [BedrockRuntimeClientTypes.ContentBlock] = try content.map {
            content -> BedrockRuntimeClientTypes.ContentBlock in
            return try content.getSDKContentBlock()
        }
        return BedrockRuntimeClientTypes.Message(
            content: contentBlocks,
            role: role.getSDKConversationRole()
        )
    }
}

extension Content {

    init(from sdkContentBlock: BedrockRuntimeClientTypes.ContentBlock) throws {
        switch sdkContentBlock {
        case .text(let text):
            self = .text(text)
        case .image(let sdkImage):
            guard let sdkFormat = sdkImage.format else {
                throw BedrockServiceError.decodingError(
                    "Could not extract format from BedrockRuntimeClientTypes.ImageBlock"
                )
            }
            guard let sdkImageSource = sdkImage.source else {
                throw BedrockServiceError.decodingError(
                    "Could not extract source from BedrockRuntimeClientTypes.ImageBlock"
                )
            }
            switch sdkImageSource {
            case .bytes(let data):
                self = .image(format: try Content.ImageFormat(from: sdkFormat), source: data.base64EncodedString())
            case .sdkUnknown(let unknownImageSource):
            throw BedrockServiceError.notImplemented(
                    "ImageSource \(unknownImageSource) is not implemented by BedrockRuntimeClientTypes"
                )
            }
        case .sdkUnknown(let unknownContentBlock):
            throw BedrockServiceError.notImplemented(
                "ContentBlock \(unknownContentBlock) is not implemented by BedrockRuntimeClientTypes"
            )
        default:
            throw BedrockServiceError.notImplemented(
                "\(sdkContentBlock.self) is not implemented by this library"
            )
        }
    }

    func getSDKContentBlock() throws -> BedrockRuntimeClientTypes.ContentBlock {
        switch self {
        case .text(let text):
            return BedrockRuntimeClientTypes.ContentBlock.text(text)
        case .image(let format, let source):
            guard let data = Data(base64Encoded: source) else {
                throw BedrockServiceError.decodingError(
                    "Could not decode image source from base64 string. String: \(source)"
                )
            }
            return BedrockRuntimeClientTypes.ContentBlock.image(
                BedrockRuntimeClientTypes.ImageBlock(
                    format: format.getSDKImageFormat(),
                    source: BedrockRuntimeClientTypes.ImageSource.bytes(data)
                )
            )
        }
    }
}

extension Content.ImageFormat {

    init(from sdkImageFormat: BedrockRuntimeClientTypes.ImageFormat) throws {
        switch sdkImageFormat {
        case .gif: self = .gif
        case .jpeg: self = .jpeg
        case .png: self = .png
        case .webp: self = .webp
        case .sdkUnknown(let unknownImageFormat):
            throw BedrockServiceError.notImplemented(
                "ImageFormat \(unknownImageFormat) is not implemented by BedrockRuntimeClientTypes"
            )
        }
    }

    func getSDKImageFormat() -> BedrockRuntimeClientTypes.ImageFormat {
        switch self {
        case .gif: return .gif
        case .jpeg: return .jpeg
        case .png: return .png
        case .webp: return .webp
        }
    }

}

extension Role {
    init(from sdkConversationRole: BedrockRuntimeClientTypes.ConversationRole) throws {
        switch sdkConversationRole {
        case .user: self = .user
        case .assistant: self = .assistant
        case .sdkUnknown(let unknownRole):
            throw BedrockServiceError.notImplemented(
                "Role \(unknownRole) is not implemented by BedrockRuntimeClientTypes"
            )
        }
    }

    func getSDKConversationRole() -> BedrockRuntimeClientTypes.ConversationRole {
        switch self {
        case .user: return .user
        case .assistant: return .assistant
        }
    }
}
