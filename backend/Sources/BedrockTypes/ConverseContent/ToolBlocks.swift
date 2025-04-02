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
    public let input: JSON

    public init(id: String, name: String, input: JSON) {
        self.id = id
        self.name = name
        self.input = input
    }
}

public struct ToolResultBlock: Codable {
    public let id: String
    public let content: [ToolResultContent]
    public let status: ToolStatus?  // currently only supported by Anthropic Claude 3 models

    public init(id: String, content: [ToolResultContent], status: ToolStatus? = nil) {
        self.id = id
        self.content = content
        self.status = status
    }
}

public enum ToolStatus: Codable {
    case success
    case error
}

public enum ToolResultContent {
    // case json([String: Any]) // Just Data
    // case json(Data)
    case json(JSON)
    case text(String)
    case image(ImageBlock)  // currently only supported by Anthropic Claude 3 models
    case document(DocumentBlock)
    case video(VideoBlock)
}

extension ToolResultContent: Codable {
    private enum CodingKeys: String, CodingKey {
        case json, text, image, document, video
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .json(let json):
            try container.encode(json, forKey: .json)
        case .text(let text):
            try container.encode(text, forKey: .text)
        case .image(let image):
            try container.encode(image, forKey: .image)
        case .document(let doc):
            try container.encode(doc, forKey: .document)
        case .video(let video):
            try container.encode(video, forKey: .video)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let json = try container.decodeIfPresent(JSON.self, forKey: .json) {
            self = .json(json)
        } else if let text = try container.decodeIfPresent(String.self, forKey: .text) {
            self = .text(text)
        } else if let image = try container.decodeIfPresent(ImageBlock.self, forKey: .image) {
            self = .image(image)
        } else if let doc = try container.decodeIfPresent(DocumentBlock.self, forKey: .document) {
            self = .document(doc)
        } else if let video = try container.decodeIfPresent(VideoBlock.self, forKey: .video) {
            self = .video(video)
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Invalid tool result content"
                )
            )
        }
    }
}
