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
    var allModelsParameters: AllModelParameters = [:]
    
    init() {
        self.allModelsParameters = BedrockModelParameters.allModelsParameters
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
        
        m.allModelsParameters["id1"] = BedrockClaudeModelParameters.parameters
        return m
    }
}
