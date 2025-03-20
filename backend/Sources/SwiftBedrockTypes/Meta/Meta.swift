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

struct MetaText: TextModality {
    func getName() -> String { "Meta" }

    func getTextRequestBody(prompt: String, maxTokens: Int, temperature: Double) throws -> BedrockBodyCodable {
        throw SwiftBedrockError.notImplemented("getTextRequestBody is not implemented for Meta")
    }

    func getTextResponseBody(from data: Data) throws -> ContainsTextCompletion {
        throw SwiftBedrockError.notImplemented("getTextResponseBody is not implemented for Meta")
    }
}
