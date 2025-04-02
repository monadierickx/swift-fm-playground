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
import Hummingbird
import BedrockTypes

extension Message: ResponseCodable {}

struct ChatInput: Codable {
    let prompt: String
    let history: [Message]?
    let imageFormat: ImageBlock.Format?
    let imageBytes: String?
    let maxTokens: Int?
    let temperature: Double?
    let topP: Double?
    let stopSequences: [String]?
    let systemPrompts: [String]?
    let tools: [Tool]?
}

struct ChatOutput: ResponseCodable {
    let reply: String
    let history: [Message]
}
