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

public enum SwiftBedrockError: Error {
    case invalid(InvalidParameter, String)
    case invalidSDKResponse(String)
    case invalidSDKResponseBody(Data?)
    case completionNotFound(String)
    case encodingError(String)
    case decodingError(String)
    case notImplemented(String)
    case notSupported(String)
}

public enum InvalidParameter: Sendable {
    case model
    case modality
    case prompt
    case maxTokens
    case temperature
    case topK
    case topP
    case nrOfImages
    case images
    case similarity
    case stopSequences
    case cfgScale
    case seed
    case resolution
}
