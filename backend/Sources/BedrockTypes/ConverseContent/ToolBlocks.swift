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

public struct ToolUseBlock: Codable {
    public let id: String
    public let name: String
    // let input: [String: Any]

    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

public struct ToolResultBlock: Codable {
    public let content: String
    public let status: ToolStatus  // currently only supported by Anthropic Claude 3 models
    public let toolUseId: String
}

public enum ToolStatus: Codable {
    case success
    case error
}

public enum ToolResultContent: Codable {
    // case json([String: Any])
    case text(String)
    case image(ImageBlock)  // currently only supported by Anthropic Claude 3 models
    case document(DocumentBlock)
    case video(VideoBlock)
}
