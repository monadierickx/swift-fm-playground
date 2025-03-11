//
//  ViewModel.swift
//  Swift FM Playground
//
//  Created by Stormacq, Sebastien on 06/10/2023.
//

import Foundation
import Logging
import OrderedCollections
import BedrockTypes

@MainActor
final class ViewModel: ObservableObject {
    
    private var logger = Logger(label: "ViewModel")

    @Published var data : Model
    @Published var state: Status = .ready()
    
    @Published var selectedModel: BedrockModelSummaryUI? = nil

    init(model: Model = Model()) {
#if DEBUG
        self.logger.logLevel = .debug
#endif
        self.data = model
    }
    
    func playgrounds() -> [Playground] { return Playground.all() }
    
    @discardableResult
    func listModels() async throws -> [BedrockModelSummaryUI] {
        if self.data.listFoundationModels.count == 0 {
            let response = try await Bedrock().listModels()
            self.data.listFoundationModels = BedrockModelSummaryUI.from(response)
        }
        return self.data.listFoundationModels
    }
    func selectedBedrockModel() -> BedrockModel? {
        return BedrockModel.init(from: selectedModel?.modelId)
    }
    func selectedModelParameter() throws -> OrderedDictionary<String, BedrockModelParameter> {
        
        guard let selectedModel = selectedBedrockModel(),
              let rawParameters = self.data.modelsParameters(for: selectedModel) else {
            return [:]
        }

        // https://stackoverflow.com/a/68023633/663360
        var parameters = OrderedDictionary(uniqueKeysWithValues: rawParameters)
        
        // TODO: should I move the sorting code to the struct 
        parameters.sort(by: { element1, element2 in
            guard let rp1 = rawParameters[element1.key],
                  let rp2 = rawParameters[element2.key] else {
                  return false
            }
            let order1: Int
            switch rp1 {
            case .number(let numberModelParameter): order1 = numberModelParameter.displayOrder
            case .string(let stringModelParamter): order1 = stringModelParamter.displayOrder
            }
            let order2: Int
            switch rp2 {
            case .number(let numberModelParameter): order2 = numberModelParameter.displayOrder
            case .string(let stringModelParamter): order2 = stringModelParamter.displayOrder
            }
            return order1 < order2
        })

        return parameters
    }
    
    func invoke(with text: String) async throws -> String {
        guard let model = selectedBedrockModel() else {
            return "model is nil"
        }
        
        let bedrock = Bedrock()
        
        if model.isAnthropic() {
            // TODO: update status bar
            // TODO: show a progress() UI 
            // TODO: include input parameters
            let request = ClaudeRequest(prompt: text)
            let response = try await bedrock.invokeClaude(model: model, request: request)
            return response.completion.trim()
        } else {
            return "not implemented"
        }
    }
}

// MARK: Control the status bar
extension ViewModel {
    func ready(message: String? = nil) {
        if let message {
            state = .ready(msg: message)
        } else {
            state = .ready()
        }
    }
    func busy(message: String? = nil) {
        if let message {
            state = .busy(msg: message)
        } else {
            state = .busy()
        }
    }
    func streaming(message: String? = nil) {
        if let message {
            state = .streaming(msg: message)
        } else {
            state = .streaming()
        }
    }
}

//MARK: Mock for the preview
extension ViewModel {
    static func mock() -> ViewModel {
        let viewModel = ViewModel()
        let mock = Model.mock()
        viewModel.data = mock
        return viewModel
    }
}


