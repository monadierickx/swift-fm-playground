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

typealias ClaudeInstantV1 = AnthropicText
typealias ClaudeV1 = AnthropicText
typealias ClaudeV2 = AnthropicText
typealias ClaudeV2_1 = AnthropicText
typealias ClaudeV3Haiku = AnthropicText
typealias ClaudeV3_5Haiku = AnthropicText
typealias ClaudeV3Opus = AnthropicText
typealias ClaudeV3_5Sonnet = AnthropicText
typealias ClaudeV3_7Sonnet = AnthropicText

extension BedrockModel {
    public static let instant: BedrockModel = BedrockModel(
        id: "anthropic.claude-instant-v1",
        modality: ClaudeInstantV1()
    )
    public static let claudev1: BedrockModel = BedrockModel(
        id: "anthropic.claude-v1",
        modality: ClaudeV1()
    )
    public static let claudev2: BedrockModel = BedrockModel(
        id: "anthropic.claude-v2",
        modality: ClaudeV2()
    )
    public static let claudev2_1: BedrockModel = BedrockModel(
        id: "anthropic.claude-v2:1",
        modality: ClaudeV2_1()
    )
    public static let claudev3_haiku: BedrockModel = BedrockModel(
        id: "anthropic.claude-3-haiku-20240307-v1:0",
        modality: ClaudeV3Haiku()
    )
    public static let claudev3_5_haiku: BedrockModel = BedrockModel(
        id: "us.anthropic.claude-3-5-haiku-20241022-v1:0",
        modality: ClaudeV3_5Haiku()
    )
    public static let claudev3_opus: BedrockModel = BedrockModel(
        id: "us.anthropic.claude-3-opus-20240229-v1:0",
        modality: ClaudeV3Opus()
    )
    public static let claudev3_5_sonnet: BedrockModel = BedrockModel(
        id: "us.anthropic.claude-3-5-sonnet-20240620-v1:0",
        modality: ClaudeV3_5Sonnet()
    )
    public static let claudev3_5_sonnet_v2: BedrockModel = BedrockModel(
        id: "us.anthropic.claude-3-5-sonnet-20241022-v2:0",
        modality: ClaudeV3_5Sonnet()
    )
    public static let claudev3_7_sonnet: BedrockModel = BedrockModel(
        id: "us.anthropic.claude-3-7-sonnet-20250219-v1:0",
        modality: ClaudeV3_7Sonnet()
    )
}
