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

public struct Tool: Codable {
    public let name: String
    public let inputSchema: JSON
    public let description: String?

    public init(name: String, inputSchema: JSON, description: String? = nil) {
        self.name = name
        self.inputSchema = inputSchema
        self.description = description
    }
}
