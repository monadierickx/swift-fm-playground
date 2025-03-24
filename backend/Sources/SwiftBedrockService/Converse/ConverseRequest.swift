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

public struct ConverseRequest {
    let model: BedrockModel
    let messages: [Message]

    init(model: BedrockModel, messages: [Message] = []) {
        self.messages = messages
        self.model = model
    }

    func getConverseInput() -> ConverseInput {
        ConverseInput(
            messages: getSDKMessages(),
            modelId: model.id
        )
    }

    private func getSDKMessages() -> [BedrockRuntimeClientTypes.Message] {
        messages.map { $0.getSDKMessage() }
    }
}
