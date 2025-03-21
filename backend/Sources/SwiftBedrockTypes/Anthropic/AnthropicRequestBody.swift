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

public struct AnthropicRequestBody: BedrockBodyCodable {
    private let anthropic_version: String
    private let max_tokens: Int
    private let temperature: Double
    private let messages: [AnthropicMessage]

    public init(prompt: String, maxTokens: Int = 200, temperature: Double = 1) {
        self.anthropic_version = "bedrock-2023-05-31"
        self.max_tokens = maxTokens
        self.temperature = temperature
        self.messages = [
            AnthropicMessage(role: .user, content: [AnthropicContent(text: "\n\nHuman:\(prompt)\n\nAssistant:")])
        ]
    }

    private struct AnthropicMessage: Codable {
        let role: Role
        let content: [AnthropicContent]
    }

    private struct AnthropicContent: Codable {
        let type: String
        let text: String

        init(text: String) {
            self.type = "text"
            self.text = text
        }
    }
}
