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

struct Titan: ModelFamily {
    let name: String = "Titan"

    func getTextRequestBody(prompt: String, maxTokens: Int, temperature: Double) throws -> BedrockBodyCodable {
        throw SwiftBedrockError.notImplemented("getTextRequestBody is not implemented for Titan")
    }
    
    func getTextResponseBody(from data: Data) throws -> ContainsTextCompletion {
        throw SwiftBedrockError.notImplemented("getTextResponseBody is not implemented for Titan")
    }

    func getImageRequestBody() throws -> BedrockBodyCodable {
        throw SwiftBedrockError.notImplemented("getImageRequestBody is not implemented for Titan")
    }
    
    func getImageResponseBody() throws -> ContainsImageGeneration {
        throw SwiftBedrockError.notImplemented("getImageResponseBody is not implemented for Titan")
    }

}