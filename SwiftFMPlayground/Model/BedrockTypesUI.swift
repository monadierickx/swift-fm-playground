//
//  BedrockTypesUI.swift
//  Swift FM Playground
//
//  Created by Stormacq, Sebastien on 31/10/2023.
//

import Foundation
import Algorithms

import AWSBedrock

/**
    A collection of container types and extensions to represent bedrock data in the user interface
 */

struct BedrockModelSummaryUI: Hashable, Identifiable {
    
    // to make it Identifiable
    public var id: String { modelArn }
    
    let customizationsSupported: String
    let inputModalities: String
    let modelArn: String
    let modelId: String
    let modelName: String
    let outputModalities: String
    let providerName: String
    let responseStreamingSupported: String
    
    static func from(_ response: ListFoundationModelsOutput) -> [BedrockModelSummaryUI] {
        guard let summaries = response.modelSummaries else {
            return []
        }
        return summaries.map{ model in
            return BedrockModelSummaryUI(customizationsSupported: model.customizationsSupported?.map { $0.rawValue }.joined(separator: ",") ?? "unknown",
                                         inputModalities: model.inputModalities?.map { $0.rawValue }.joined(separator: ",") ??  "unknown",
                                         modelArn: model.modelArn ?? "nil",
                                         modelId: model.modelId ?? "nil",
                                         modelName: model.modelName ?? "nil",
                                         outputModalities: model.outputModalities?.map { $0.rawValue }.joined(separator: ",") ?? "unknown",
                                         providerName: model.providerName ?? "nil",
                                         responseStreamingSupported: model.responseStreamingSupported?.description ?? "unknown")
        }
    }
}

enum InputCapabilities: String {
    case text = "TEXT"
    case image = "IMAGE"
}

enum OutputCapabilities: String {
    case text = "TEXT"
    case image = "IMAGE"
    case embedding = "EMBEDDING"
}

extension Array<BedrockModelSummaryUI> {
    
    /**
     Return the list of modelId for the given provider
     */
    private func modelsId(for provider: String?) -> [String] {
        self.filter {
            $0.providerName == provider
        }.map {
            $0.modelId
        }
    }

    /**
     Return a list with the unique provider names
     */
    private func providers() -> [String] {
        self.map {
            $0.providerName
        }
        .uniqued()
        .map {
            $0
        }
    }
    
    /**
     Return a list of unique provider names that have at least one model with specific input capability
     */
    func providers(withInputCapability inputCapability: InputCapabilities?,
                   andOutputCapability outputCapability: OutputCapabilities?) -> [String] {
        
        // when no capability is passed, return all providers
        guard let inputCapability, let outputCapability else {
            return self.providers()
        }
        
        // 1. filter
        return self.filter {
            
            $0.inputModalities.lowercased()
                .contains(inputCapability.rawValue.lowercased())
            
            &&
            
            $0.outputModalities.lowercased()
                .contains(outputCapability.rawValue.lowercased())
        }
        
        // 2. extract just the provider name
        .map {
            $0.providerName
        }
        
        // 3. keep only unique values
        .uniqued()
        
        // 4. tranform to [String]
        .map {
            $0
        }
    }
    
    /**
     Return a list of models that match the given input and output capability
     */
    func modelsId(forProvider provider: String?,
               withInputCapability inputCapability: InputCapabilities?,
               andOutpuCapability outputCapability: OutputCapabilities?) -> [String] {
        
        // when no capability is passed, return all models for this provider
        guard let inputCapability, let outputCapability else {
            return self.modelsId(for: provider)
        }

        // 1. filter
        return self.filter {
            
            $0.providerName == provider
            
            &&
            
            $0.inputModalities.lowercased()
                .contains(inputCapability.rawValue.lowercased())
            
            &&
            
            $0.outputModalities.lowercased()
                .contains(outputCapability.rawValue.lowercased())
        }
        
        // 2. extract just the model id
        .map {
            $0.modelId
        }
        
        // 3. keep only unique values
        .uniqued()
        
        // 4. tranform to [String]
        .map {
            $0
        }
    }

}

