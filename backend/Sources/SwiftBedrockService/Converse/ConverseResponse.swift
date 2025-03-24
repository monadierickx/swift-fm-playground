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
import Foundation
import SwiftBedrockTypes

public struct ConverseResponse {
    let message: Message

    public init(_ output: BedrockRuntimeClientTypes.ConverseOutput) throws {
        guard case .message(let sdkMessage) = output else {
            throw SwiftBedrockError.invalidConverseOutput("Could not extract message from ConverseOutput")
        }
        self.message = try Message(from: sdkMessage)
    }

    func getReply() -> String {
        switch message.content.first {
        case .text(let text):
            return text
        default:
            return "Not found"  // FIXME
        }
    }
}
