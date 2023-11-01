//
//  ViewModel.swift
//  Swift FM Playground
//
//  Created by Stormacq, Sebastien on 06/10/2023.
//

import Foundation
import Logging
import AWSBedrock

@MainActor
final class ViewModel: ObservableObject {
    
    private var logger = Logger(label: "ViewModel")

    @Published var data : Model
    @Published var state: Status = .ready()
    
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
}

// MARK: Control the status bar
extension ViewModel {
    func ready(message: String? = nil) {
        print("ViewModel.ready")
        if let message {
            state = .ready(msg: message)
        } else {
            state = .ready()
        }
    }
    func busy(message: String? = nil) {
        print("ViewModel.busy")
        if let message {
            state = .busy(msg: message)
        } else {
            state = .busy()
        }
    }
    func streaming(message: String? = nil) {
        print("ViewModel.streaming")
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


