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

extension Content {

    init(from sdkContentBlock: BedrockRuntimeClientTypes.ContentBlock) throws {
        switch sdkContentBlock {
        case .text(let text):
            self = .text(text)
        case .image(let sdkImage):
            self = .image(try ImageBlock(from: sdkImage))
        case .document(let sdkDocumentBlock):
            self = .document(try DocumentBlock(from: sdkDocumentBlock))
        case .tooluse(let sdkToolUseBlock):
            self = .toolUse(try ToolUseBlock(from: sdkToolUseBlock))
        case .toolresult(let sdkToolResultBlock):
            self = .toolResult(try ToolResultBlock(from: sdkToolResultBlock))
        case .video(let sdkVideoBlock):
            self = .video(try VideoBlock(from: sdkVideoBlock))
        case .sdkUnknown(let unknownContentBlock):
            throw BedrockServiceError.notImplemented(
                "ContentBlock \(unknownContentBlock) is not implemented by BedrockRuntimeClientTypes"
            )
        default:
            throw BedrockServiceError.notImplemented(
                "\(sdkContentBlock.self) is not implemented by this library"
            )
        }
    }

    func getSDKContentBlock() throws -> BedrockRuntimeClientTypes.ContentBlock {
        switch self {
        case .text(let text):
            return BedrockRuntimeClientTypes.ContentBlock.text(text)
        case .image(let imageBlock):
            return BedrockRuntimeClientTypes.ContentBlock.image(try imageBlock.getSDKImageBlock())
        case .document(let documentBlock):
            return BedrockRuntimeClientTypes.ContentBlock.document(try documentBlock.getSDKDocumentBlock())
        default:
            print("TODO")
            return BedrockRuntimeClientTypes.ContentBlock.text("TODO")
        }
    }
}
