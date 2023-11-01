//
//  ListModels.swift
//  Swift FM Playground
//
//  Created by Stormacq, Sebastien on 06/10/2023.
//

import SwiftUI
import BedrockTypes

struct ListModelsPlayground: PlaygroundComponent {
    
    @EnvironmentObject private var viewModel: ViewModel
    @State var loading: Bool = true
    
    @State private var sortOrder = [KeyPathComparator(\BedrockModelSummaryUI.providerName)]

    var body: some View {
        
        switch loading {
        case true:
            let msg = "Loading..."
            loadingView(msg)
                .onAppear {
                    viewModel.busy(message: msg)
                    Task {
                        try await viewModel.listModels()
                        self.loading = false
                        viewModel.ready()
                    }
                }
        case false:
            Table(self.viewModel.data.listFoundationModels, sortOrder: $sortOrder) {
                TableColumn("Provider", value: \.providerName )
                TableColumn("Model Name", value: \.modelName )
                TableColumn("Model Id", value: \.modelId )
                TableColumn("Streaming Supported", value: \.responseStreamingSupported )
                TableColumn("Input Modalities", value: \.inputModalities )
                TableColumn("Output Modalities", value: \.outputModalities )
                TableColumn("Customizations Supported", value: \.customizationsSupported )
            }
            .onChange(of: sortOrder) { oldValue, newValue in
                self.viewModel.data.listFoundationModels.sort(using: oldValue)
            }
        }
    }
    
    @ViewBuilder
    func loadingView(_ msg: String = "Loading...") -> some View {
        VStack {
            ProgressView()
                .padding(.bottom)
            Text(msg)
        }
    }
}

#Preview {
    return ListModelsPlayground()
        .environmentObject(ViewModel.mock())
        .frame(width:600, height: 400)
}
