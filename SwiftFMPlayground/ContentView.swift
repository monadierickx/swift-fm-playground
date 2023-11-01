//
//  ContentView.swift
//  Swift FM Playground
//
//  Created by Stormacq, Sebastien on 06/10/2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var viewModel: ViewModel
    
    @State var selectedPlayground: Playground?
    
    var body: some View {
        NavigationSplitView {
            List(viewModel.playgrounds(), selection: $selectedPlayground) { playground in
                
                HStack(spacing: 5) {
                    if let icon = playground.info.icon {
                        Text(Image(systemName: icon))
                    }
                    Text(playground.info.name)
                }
                .padding()
            }
            .padding(.top)
            .navigationSplitViewColumnWidth(250)
            
        } detail: {
            VStack {
                Spacer()
                if let selectedPlayground { 
                    selectedPlayground.info.view
                } else {
                    Text("👈 Select the playground on the left to get started.")
                }
                Spacer()
                StatusBar(state: viewModel.state)
            }
        }
        .navigationTitle("FM Playground")
    }
    
    private func toggleSidebar() {
#if os(iOS)
#else
        NSApp.sendAction(#selector(NSSplitViewController.toggleSidebar(_:)), to: nil, from: nil)
#endif
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewModel.mock())
}
