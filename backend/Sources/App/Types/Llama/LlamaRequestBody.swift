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
import SwiftBedrockTypes

public struct LlamaRequestBody: BedrockBodyCodable {
    let prompt: String
    let max_gen_len: Int
    let temperature: Double
    let top_p: Double

    public init(prompt: String, maxTokens: Int = 512, temperature: Double = 0.5) {
        self.prompt = prompt
        self.max_gen_len = maxTokens
        self.temperature = temperature
        self.top_p = 0.9
    }
}