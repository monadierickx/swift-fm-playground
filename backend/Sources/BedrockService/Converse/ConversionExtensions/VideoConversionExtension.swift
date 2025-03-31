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

extension VideoBlock {
    // init(from sdkVideoBlock: BedrockRuntimeClientTypes.VideoBlock) throws
    // func getSDKVideoBlock() throws -> BedrockRuntimeClientTypes.VideoBlock
}

extension VideoFormat {
    // init(from sdkVideoFormat: BedrockRuntimeClientTypes.VideoFormat) throws
    // func getSDKVideoFormat() throws -> BedrockRuntimeClientTypes.VideoFormat
}

extension VideoSource {
    init(from sdkVideoSource: BedrockRuntimeClientTypes.VideoSource) throws {
        switch sdkVideoSource {
        case .bytes(let data):
            self = .bytes(data.base64EncodedString())
        case .s3location(let sdkS3Location):
            self = .s3(try S3Location(from: sdkS3Location))
        case .sdkUnknown(let unknownVideoSource):
            throw BedrockServiceError.notImplemented(
                "VideoSource \(unknownVideoSource) is not implemented by BedrockRuntimeClientTypes"
            )
        }
    }

    func getSDKVideoSource() throws -> BedrockRuntimeClientTypes.VideoSource {
        switch self {
        case .bytes(let data):
            guard let sdkData = Data(base64Encoded: data) else {
                throw BedrockServiceError.decodingError(
                    "Could not decode video source from base64 string. String: \(data)"
                )
            }
            return .bytes(sdkData)
        case .s3(let s3Location):
            return .s3location(s3Location.getSDKS3Location())
        }
    }
}
