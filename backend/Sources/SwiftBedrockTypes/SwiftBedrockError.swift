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
    case invalidModel(String)
    case invalidMaxTokens(String)
    case invalidTemperature(String)
    case invalidNrOfImages(String)
    case invalidPrompt(String)
    case invalidSimilarity(String)
    case invalidStopSequences(String)
    case invalidTopK(String)
    case invalidTopP(String)
    case invalidCfgScale(String)
    case invalidSeed(String)
    case invalidResolution(String)
    
    case invalidConverseOutput(String)
    case invalidRequest(String)
    case invalidResponse(String)
    case invalidResponseBody(Data?)
    case completionNotFound(String)
    case encodingError(String)
    case decodingError(String)

    case notImplemented(String)
    case notSupported(String)
}

public enum InvalidParameter: Sendable {
    case model
    case maxTokens
    case temperature
    case nrOfImages
    case prompt
    case similarity
    case stopSequences
    case topK
    case topP
    case cfgScale
    case seed
    case resolution
}
