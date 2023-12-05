//
//  ClaudeTypes.swift
//  BedrockTypes
//
//  Created by Stormacq, Sebastien on 11/11/2023.
//

import Foundation

public struct ClaudeRequest: BedrockRequest {
    
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

public struct ClaudeResponse: BedrockResponse {
    
    public let completion: String
    public let stop_reason: String
    
    public init(from data: Data) throws {
        self = try ClaudeResponse.decode(data)
    }
}
