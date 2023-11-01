//
//  Swift_FM_PlaygroundApp.swift
//  Swift FM Playground
//
//  Created by Stormacq, Sebastien on 06/10/2023.
//

import SwiftUI

@main
struct SwiftFMPlaygroundApp: App {
    
    @EnvironmentObject var viewModel : ViewModel
    
    var body: some Scene {
        Window("Foundation Models Playground", id: "main") {
            ContentView()
        }.commands {
            SidebarCommands()
        }
        .environmentObject(ViewModel())
    }
}
