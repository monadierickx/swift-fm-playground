//
//  Bedrock.swift
//  Swift FM Playground
//
//  Created by Stormacq, Sebastien on 07/10/2023.
//

import Foundation
import Logging
import AWSBedrock
import AWSBedrockRuntime

import BedrockTypes

struct Bedrock {
    
    private var logger = Logger(label: "Bedrock")
    
    var region: String = "us-east-1"

    init() {
#if DEBUG
        // https://www.swift.org/server/guides/libraries/log-levels.html
        self.logger.logLevel = .debug
#endif
    }
    
    private func bedrockClient() async throws -> BedrockClient {
        let config = try await BedrockClient
                              .BedrockClientConfiguration(region: region)
        return BedrockClient(config: config)
    }
    
    private func bedrockRuntimeClient() async throws -> BedrockRuntimeClient {
        let config = try await BedrockRuntimeClient
                              .BedrockRuntimeClientConfiguration(region: region)
        return BedrockRuntimeClient(config: config)
    }

    func listModels() async throws -> ListFoundationModelsOutput {
        let request = ListFoundationModelsInput(byInferenceType: .onDemand)
        return try await bedrockClient().listFoundationModels(input: request)
    }
    
    func invokeModel(withId modelId: BedrockClaudeModel, prompt: String) async throws -> BedrockInvokeClaudeResponse {
        
        let params = BedrockClaudeModelParameters(prompt: prompt)
        let request = InvokeModelInput(body: try self.encode(params),
                                       contentType: "application/json",
                                       modelId: modelId.rawValue)
        let response = try await bedrockRuntimeClient().invokeModel(input: request)
        
        guard response.contentType == "application/json",
              let data = response.body else {
            logger.debug("Invalid Bedrock response: \(response)")
            throw BedrockError.invalidResponse(response.body)
        }
        return try self.decode(data)
    }
    
    private func decode<T: Decodable>(_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    private func decode<T: Decodable>(json: String) throws -> T {
        let data = json.data(using: .utf8)!
        return try self.decode(data)
    }
    private func encode<T: Encodable>(_ value: T) throws -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return try encoder.encode(value)
    }
    private func encode<T: Encodable>(_ value: T) throws -> String {
        let data : Data =  try self.encode(value)
        return String(data: data, encoding: .utf8) ?? "error when encoding the string"
    }
}

// MARK: - Errors

enum BedrockError: Error {
    case invalidResponse(Data?)
}
