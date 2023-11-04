//
//  BedrockTypes.swift
//  Swift FM Playground
//
//  Created by Stormacq, Sebastien on 31/10/2023.
//

import Foundation

// MARK: - Data structures

public enum BedrockModelProvider : String {
    case titan = "Amazon"
    case claude = "Anthropic"
    case stabledifusion = "Stability AI"
    case j2 = "AI21 Labs"
    case meta = "Meta"
}

public typealias BedrockModelIdentifier = String
public enum BedrockClaudeModel : BedrockModelIdentifier {
    case instant = "anthropic.claude-instant-v1"
    case claudev1 = "anthropic.claude-v1"
    case claudev2 = "anthropic.claude-v2"
}

public struct BedrockClaudeModelParameters: Encodable {
    public init(prompt: String) {
        self.prompt = "Human: \(prompt)\n\nAssistant:"
    }
    public let prompt: String
    public let temperature: Double = 1.0
    public let topP: Double = 1.0
    public let topK: Int = 250
    public let maxTokensToSample: Int = 8191
    public let stopSequences: [String] = ["\n\nHuman:"]
}

public struct BedrockInvokeClaudeResponse: Decodable {
    public let completion: String
    public let stop_reason: String
}
