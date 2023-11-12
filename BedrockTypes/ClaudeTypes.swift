//
//  ClaudeTypes.swift
//  BedrockTypes
//
//  Created by Stormacq, Sebastien on 11/11/2023.
//

import Foundation

public enum BedrockClaudeModel : BedrockModelIdentifier {
    case instant = "anthropic.claude-instant-v1"
    case claudev1 = "anthropic.claude-v1"
    case claudev2 = "anthropic.claude-v2"
}

public struct ClaudeParameters: Encodable {
    public init(prompt: String) {
        self.prompt = "Human: \(prompt)\n\nAssistant:"
    }
    public let prompt: String
    public let temperature: Double = 1.0
    public let topP: Double = 1.0
    public let topK: Int = 250
    public let maxTokensToSample: Int = 8191
    public let stopSequences: [String] = ["\n\nHuman:"]
    
    public func encode() throws -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return try encoder.encode(self)
    }
}

public struct ClaudeInvokeResponse: Decodable {
    public let completion: String
    public let stop_reason: String
    
    public init(from data: Data) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self = try decoder.decode(ClaudeInvokeResponse.self, from: data)
    }
}
