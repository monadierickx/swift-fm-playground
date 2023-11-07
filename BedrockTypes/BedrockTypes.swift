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
    
    public static let parameters: ModelParameters = [
        "temperature" : .number(BedrockModelParameterNumber(value: 1.0, label: "Temperature", minValue: 0.0, maxValue: 1.0)),
        "topp" : .number(BedrockModelParameterNumber(value: 0.7, label: "Top P", minValue: 0.0, maxValue: 1.0)),
        "topk" : .number(BedrockModelParameterNumber(value: 5, label: "Top K", minValue: 10, maxValue: 500)),
        "max_token_to_sample" : .number(BedrockModelParameterNumber(value: 256, label: "Length", minValue: 25, maxValue: 2048)),
        "stop_sequences" : .string(BedrockModelParameterString(value: ["\n\nHuman:"], label: "Stop sequences", maxValues: 5)) // 5 is an arbitray value
    ]

}

// modelid => list of model parameters
public typealias AllModelParameters = [BedrockModelIdentifier: ModelParameters]

public struct BedrockModelParameters {

    public static let allModelsParameters: AllModelParameters = [
        // https://docs.anthropic.com/claude/reference/complete_post
        BedrockClaudeModel.instant.rawValue : BedrockClaudeModelParameters.parameters,
        BedrockClaudeModel.claudev1.rawValue : BedrockClaudeModelParameters.parameters,
        BedrockClaudeModel.claudev2.rawValue : BedrockClaudeModelParameters.parameters
    ]
}

//TODO: simplify the above with :
//public struct BedrockClaudeModelParameters: Encodable {
//    public init(prompt: String) {
//        self.prompt = "Human: \(prompt)\n\nAssistant:"
//    }
//    public let prompt: String
//    public let modelParameters : ModelParameters? = nil
//}

public struct BedrockInvokeClaudeResponse: Decodable {
    public let completion: String
    public let stop_reason: String
}
