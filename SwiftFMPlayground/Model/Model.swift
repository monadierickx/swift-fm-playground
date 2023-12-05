//
//  Model.swift
//  Swift FM Playground
//
//  Created by Stormacq, Sebastien on 06/10/2023.
//

import Foundation
import BedrockTypes

struct Model {

    var listFoundationModels: [BedrockModelSummaryUI] = []
    
    // allows to inject values for the Mock
    func modelsParameters(for selectedModel: BedrockModel) -> ModelParameters?  { return allModelsParameters[selectedModel] }
    private var allModelsParameters: AllModelParameters =
        [
            // https://docs.anthropic.com/claude/reference/complete_post
            BedrockModel.instant : Model.claudeModelParameters,
            BedrockModel.claudev1 : Model.claudeModelParameters,
            BedrockModel.claudev2 : Model.claudeModelParameters,
            BedrockModel.claudev2_1 : Model.claudeModelParameters
        ]
    
    // this methods returns a container used by the UI
    private static let claudeModelParameters: ModelParameters = [
        "temperature" : .number(BedrockModelParameterNumber(value: 1.0, label: "Temperature", minValue: 0.0, maxValue: 1.0, displayOrder: 1)),
        "topp" : .number(BedrockModelParameterNumber(value: 0.7, label: "Top P", minValue: 0.0, maxValue: 1.0, displayOrder: 2)),
        "topk" : .number(BedrockModelParameterNumber(value: 5, label: "Top K", minValue: 10, maxValue: 500, displayOrder: 3)),
        "max_token_to_sample" : .number(BedrockModelParameterNumber(value: 256, label: "Length", minValue: 25, maxValue: 2048, displayOrder: 4)),
        "stop_sequences" : .string(BedrockModelParameterString(value: ["\\n\\nHuman:"], label: "Stop sequences", maxValues: 5, displayOrder: 5)) // 5 is an arbitray value
    ]
}

// mock
extension BedrockModel {
    static var mock1: BedrockModel { .init(rawValue: "id1") }
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
        
        m.allModelsParameters[.mock1] = Model.claudeModelParameters
        return m
    }
}
