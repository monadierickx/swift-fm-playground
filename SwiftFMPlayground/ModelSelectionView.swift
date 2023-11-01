//
//  ModelSeclectionView.swift
//  Swift FM Playground
//
//  Created by Stormacq, Sebastien on 01/11/2023.
//

import SwiftUI

struct ModelSelectionView: View {
    @EnvironmentObject private var viewModel: ViewModel

    @State var selectedProvider: String = ""
    @State var selectedModel: String = ""
    
    // just used to observe changes and reset provider list accordingly
    // I don't like adding this dependency but this is the simplest way
    // I found to monitor changes
    let playground: Playground

    // filter models based on the playground capabilities
    // in terms of managing input and output types
    var inputCapability: InputCapabilities? = nil
    var outputCapability: OutputCapabilities? = nil
    
    var body: some View {
        
        let models = viewModel.data.listFoundationModels
        
        if models.count == 0 {
            VStack {
                ProgressView()
                Text("No model provider loaded, loading the list...")
                    .padding()
                Divider()
            }
            .task {
                // trying to load the models
                _ = try? await viewModel.listModels()
            }
            
        } else {
            VStack {
                HStack {
                    Picker("Provider:", selection: $selectedProvider) {
                        Text("").tag("") // silence runtime warning when selection is ""
                        
                        //  list all providers that can handle that specific input and output
                        ForEach(models.providers(withInputCapability: inputCapability,
                                                 andOutputCapability: outputCapability),
                                id:\.self) {
                            Text($0)
                        }
                    }
                    // ensure the first provider in the list is displayed
                    .onAppear() {
                        if models.count > 0 {
                            selectedProvider = models[0].providerName
                        }
                    }
                    Picker("Model:", selection: $selectedModel) {
                        Text("").tag("") // silence runtime warning when selection is ""
                        
                        //  list all models that can handle that specific input and output
                        ForEach(models.modelsId(forProvider: selectedProvider,
                                                withInputCapability: inputCapability,
                                                andOutpuCapability: outputCapability),
                                id: \.self) {
                            Text($0)
                        }
                    }
                    // synchronize the model picker based on the value of the provider
                    .onChange(of: selectedProvider) {
                        let m = models.modelsId(forProvider: selectedProvider,
                                                    withInputCapability: inputCapability,
                                                    andOutpuCapability: outputCapability)
                        selectedModel = m.count > 0 ? m[0] : ""
                    }
                }.padding()
                
                Divider()
            }
            .onChange(of: playground) {
                let availableProviders = models.providers(withInputCapability: self.inputCapability,
                                                          andOutputCapability: self.outputCapability)
                selectedProvider = availableProviders.count > 0 ? availableProviders[0] : ""
            }

        }
    }
}

#Preview("models") {
    let mock = ViewModel.mock()
    return ModelSelectionView(playground: .text, inputCapability: nil, outputCapability: nil)
            .environmentObject(mock)
            .frame(width:500, height:60)
}

#Preview("no data loaded") {
    return ModelSelectionView(playground: .text, inputCapability: nil, outputCapability: nil)
            .environmentObject(ViewModel())
            .frame(width:500, height:60)
}
