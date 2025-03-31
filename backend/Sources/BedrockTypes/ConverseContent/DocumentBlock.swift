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

struct DocumentBlock: Codable {
    let name: String
    let format: DocumentFormat
    let source: String  // 64 encoded
}

public enum DocumentFormat: Codable {
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
