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

public struct VideoBlock: Codable {
    public let format: Format
    public let source: Source

    public init(format: Format, source: Source) {
        self.format = format
        self.source = source
    }

    public enum Source: Codable {
        case bytes(String)  // base64
        case s3(S3Location)
    }

    public enum Format: Codable {
        case flv
        case mkv
        case mov
        case mp4
        case mpeg
        case mpg
        case threeGp
        case webm
        case wmv
    }
}
