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

public struct ConverseRequest {
    let model: BedrockModel
    let messages: [Message]

    public init(model: BedrockModel, messages: [Message] = []) {
        self.messages = messages
        self.model = model
    }

    func getBedrockRuntimeClientTypesMessages() -> [BedrockRuntimeClientTypes.Message] {
        messages.map { $0.getBedrockRuntimeClientTypesMessage() }
    }

    func getConverseInput() -> ConverseInput {
        ConverseInput(
            messages: getBedrockRuntimeClientTypesMessages(),
            modelId: model.id
        )
    }
}

public struct ConverseResponse {
    let message: Message

    public init(_ output: BedrockRuntimeClientTypes.ConverseOutput) throws {
        guard case .message(let sdkMessage) = output else {
            throw SwiftBedrockError.invalidConverseOutput("Could not extract message from ConverseOutput")
        }
        self.message = Message(from: sdkMessage)
    }

    func getReply() -> String {
        switch message.content.first {
        case .text(let text):
            return text
        default:
            return "Not found"  // FIXME
        }
    }
}

public struct Message: Codable {
    public let role: Role
    public let content: [Content]

    // public static func createTextMessage(from role: Role, text: String) -> Self {
    //     Message(from: role, content: [.text(text)])
    // }

    public init(from role: Role, content: [Content]) {
        self.role = role
        self.content = content
    }

    public init(from sdkMessage: BedrockRuntimeClientTypes.Message) {
        self.role = Role(from: sdkMessage.role!) // FIXME: guard
        self.content = sdkMessage.content!.map { Content(from: $0) } // FIXME: guard
    }

    func getBedrockRuntimeClientTypesMessage() -> BedrockRuntimeClientTypes.Message {
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

public enum Content: Codable {
    case text(String)
    case unknown(String)

    init(from sdkContentBlock: BedrockRuntimeClientTypes.ContentBlock) {
        switch sdkContentBlock {
        case .text(let text):
            self = .text(text)
        case .sdkUnknown(let unknown):
            self = .unknown(unknown)
        default:
            self = .unknown("Unknown content block type")  // FIXME
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
        case .sdkUnknown(_): self = .unknown  // .unknown(customRole)  // FIXME
        }
    }

    func getSDKConversationRole() -> BedrockRuntimeClientTypes.ConversationRole {
        switch self {
        case .user: return .user
        case .assistant: return .assistant
        case .unknown: return .sdkUnknown("Unknown")  // FIXME
        }
    }
}
