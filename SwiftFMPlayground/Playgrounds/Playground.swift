//
//  Playgrounds.swift
//  Swift FM Playground
//
//  Created by Stormacq, Sebastien on 06/10/2023.
//

import SwiftUI

typealias PlaygroundComponent = View

// the generic playground view.
// it is made of a common part and the component specific view
struct PlaygroundView: View {
    let component : Playground
    var showCommon: Bool = true
    var body: some View {
        VStack {
            if (showCommon) {
                ModelSelectionView(playground: component,
                                   inputCapability: component.info.supportedInput,
                                   outputCapability: component.info.supportedOutput)
            }
            Spacer()
            Section {
                component.view
            }
            Spacer()
        }
    }
}

enum Playground: Identifiable, CaseIterable {
    case listModels
    case text
    case chat
    case voice
    case image
    
    // to make it Identifiable
    var id: Playground { self }
    
    var info: (name: String, 
               icon: String?,
               supportedInput: InputCapabilities?,
               supportedOutput: OutputCapabilities?,
               view: PlaygroundView) {
        get {
            switch self {
            case .listModels:
                return ("List Foundation Models", 
                        "list.bullet",
                        nil, nil,
                        PlaygroundView(component: self, showCommon: false))
            case .text:
                return ("Text Playground", 
                        "doc",
                        .text, .text,
                        PlaygroundView(component: self))
            case .chat:
                return ("Chat Playground", 
                        "ellipsis.bubble",
                        .text, .text,
                        PlaygroundView(component: self))
            case .voice:
                return ("Voice Chat Playground", 
                        "message.badge.waveform",
                        .text, .text,
                        PlaygroundView(component: self))
            case .image:
                return ("Image Playground", 
                        "photo",
                        .text, .image,
                        PlaygroundView(component: self))
            }
        }
    }
    
    // the view of the playground component
    @ViewBuilder
    var view: some View {
        switch self {
        case .listModels: ListModelsPlayground()
        case .text: TextPlayground()
        case .chat: ChatPlayground()
        case .voice: VoicePlayground()
        case .image: ImagePlayground()
        }
    }
    
    static func all() -> [Playground] { return Playground.allCases }
}

#Preview("Body") {
    let pg : Playground = .text
    return PlaygroundView(component: pg)
        .environmentObject(ViewModel.mock())
        .frame(width: 600, height: 400)
}

