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
import Foundation
import BedrockTypes

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

    func getSDKMessage() -> BedrockRuntimeClientTypes.Message {
        let contentBlocks: [BedrockRuntimeClientTypes.ContentBlock] = content.map {
            content -> BedrockRuntimeClientTypes.ContentBlock in
            return content.getSDKContentBlock()
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

    func getSDKContentBlock() -> BedrockRuntimeClientTypes.ContentBlock {
        switch self {
        case .text(let text):
            return BedrockRuntimeClientTypes.ContentBlock.text(text)
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
