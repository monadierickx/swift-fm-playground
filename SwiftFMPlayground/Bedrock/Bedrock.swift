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
    
    var region: String = "us-east-1" //TODO: add a type safe way to express regions

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
    
    func invokeClaude(model: BedrockModel, request: ClaudeRequest) async throws -> ClaudeResponse {
        let expectedModel = "anthropic.claude"
        guard model.rawValue.starts(with: expectedModel) else {
            throw BedrockError.invalidModel("Expecting \(expectedModel)*")
        }
        let data = try await self.invokeModel(withId: model, params: request.encode())
        return try ClaudeResponse(from: data)
    }
    private func invokeModel(withId model: BedrockModel, params: Data) async throws -> Data {
        
        let request = InvokeModelInput(body: params,
                                       contentType: "application/json",
                                       modelId: model.rawValue)
        let response = try await bedrockRuntimeClient().invokeModel(input: request)
        
        guard response.contentType == "application/json",
              let data = response.body else {
            logger.debug("Invalid Bedrock response: \(response)")
            throw BedrockError.invalidResponse(response.body)
        }
        return data
    }
}

// MARK: - Errors

enum BedrockError: Error {
    case invalidResponse(Data?)
    case invalidModel(String)
}
