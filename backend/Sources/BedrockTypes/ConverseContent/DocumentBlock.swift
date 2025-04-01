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

public struct DocumentBlock: Codable {
    public let name: String
    public let format: Format
    public let source: String  // 64 encoded

    public init(name: String, format: Format, source: String) {
        self.name = name
        self.format = format
        self.source = source
    }

    public enum Format: Codable {
        case csv
        case doc
        case docx
        case html
        case md
        case pdf
        case txt
        case xls
        case xlsx
    }
}
