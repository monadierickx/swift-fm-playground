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
import SwiftBedrockTypes

extension Message {

    public init(from sdkMessage: BedrockRuntimeClientTypes.Message) throws {
        guard let sdkRole = sdkMessage.role else {
            throw SwiftBedrockError.decodingError("Could not extract role from BedrockRuntimeClientTypes.Message")
        }
        guard let sdkContent = sdkMessage.content else {
            throw SwiftBedrockError.decodingError("Could not extract content from BedrockRuntimeClientTypes.Message")
        }
        let content = sdkContent.map { Content(from: $0) }
        self = Message(from: Role(from: sdkRole), content: content)
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

    init(from sdkContentBlock: BedrockRuntimeClientTypes.ContentBlock) {
        switch sdkContentBlock {
        case .text(let text):
            self = .text(text)
        case .sdkUnknown(let unknown):
            self = .unknown(unknown)
        default:
            self = .unknown("Unknown content block type")  // FIXME: add all other options too
        }
    }

    func getSDKContentBlock() -> BedrockRuntimeClientTypes.ContentBlock {
        switch self {
        case .text(let text):
            return BedrockRuntimeClientTypes.ContentBlock.text(text)
        case .unknown(let unknown):
            return BedrockRuntimeClientTypes.ContentBlock.sdkUnknown(unknown)
        }
    }
}

extension Role {
    init(from sdkConversationRole: BedrockRuntimeClientTypes.ConversationRole) {
        switch sdkConversationRole {
        case .user: self = .user
        case .assistant: self = .assistant
        case .sdkUnknown(_): self = .unknown  // .customRole(name)  // FIXME: should we allow for a custom role?
        }
    }

    func getSDKConversationRole() -> BedrockRuntimeClientTypes.ConversationRole {
        switch self {
        case .user: return .user
        case .assistant: return .assistant
        case .unknown: return .sdkUnknown("Unknown")  // FIXME: if we allow a custom role we should call it that and give it a string so we know what it is
        }
    }
}
