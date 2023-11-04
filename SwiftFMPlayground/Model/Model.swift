//
//  Model.swift
//  Swift FM Playground
//
//  Created by Stormacq, Sebastien on 06/10/2023.
//

import Foundation
import BedrockTypes

struct Model {

    // made statix to be usable in the mock
    static let claudeParameters: ModelParameters = [
        "temperature" : .double(BedrockModelParameterNumber<Double>(value: 1, label: "Temperature", minValue: 0.0, maxValue: 1.0)),
        "topp" : .double(BedrockModelParameterNumber<Double>(value: 0.7, label: "Top P", minValue: 0.0, maxValue: 1.0)),
        "topk" : .int(BedrockModelParameterNumber<Int>(value: 5, label: "Top K", minValue: 10, maxValue: 500)),
        "max_token_to_sample" : .int(BedrockModelParameterNumber<Int>(value: 256, label: "Length", minValue: 25, maxValue: 2048)),
        "stop_sequences" : .string(BedrockModelParameterString(value: ["\n\nHuman:"], label: "Stop sequences", maxValues: 5)) // 5 is an arbitray value
    ]
    

    var listFoundationModels: [BedrockModelSummaryUI] = []
    
    var allModelsParameters: AllModelParameters // var to be accessible in the mock, let otherwise
        
    init() {
        
        allModelsParameters = [
            // https://docs.anthropic.com/claude/reference/complete_post
            BedrockClaudeModel.instant.rawValue : Model.claudeParameters,
            BedrockClaudeModel.claudev1.rawValue : Model.claudeParameters,
            BedrockClaudeModel.claudev2.rawValue : Model.claudeParameters
        ]
    }
}


extension Model {
    static func mock() -> Model {
        
        var m = Model()
        m.listFoundationModels.append(BedrockModelSummaryUI(customizationsSupported: "true",
                                                            inputModalities: "text",
                                                            modelArn: "arn",
                                                            modelId: "id1",
                                                            modelName: "model 1",
                                                            outputModalities: "text",
                                                            providerName: "provider 1",
                                                            responseStreamingSupported: "yes"))
        m.listFoundationModels.append(BedrockModelSummaryUI(customizationsSupported: "true",
                                                            inputModalities: "text",
                                                            modelArn: "arn",
                                                            modelId: "id2",
                                                            modelName: "model 2",
                                                            outputModalities: "text,image",
                                                            providerName: "provider 1",
                                                            responseStreamingSupported: "yes"))
        m.listFoundationModels.append(BedrockModelSummaryUI(customizationsSupported: "true",
                                                            inputModalities: "text",
                                                            modelArn: "arn",
                                                            modelId: "id3",
                                                            modelName: "model 3",
                                                            outputModalities: "text",
                                                            providerName: "provider 2",
                                                            responseStreamingSupported: "yes"))
        
        m.allModelsParameters["id1"] = Model.claudeParameters
        return m
    }
}
