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

public struct Tool {
    public let name: String
    public let inputSchema: [String: Any]
    public let description: String?

    init(name: String, inputSchema: [String: Any], description: String? = nil) {
        self.name = name
        self.inputSchema = inputSchema
        self.description = description
    }

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
        let inputSchema = try smithyDocument.asStringMap()
        self = Tool(
            name: name,
            inputSchema: inputSchema,
            description: sdkToolSpecification.description
        )
    }
}