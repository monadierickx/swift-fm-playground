//
//  TextPlayground.swift
//  Swift FM Playground
//
//  Created by Stormacq, Sebastien on 06/10/2023.
//

import SwiftUI
import BedrockTypes

struct TextPlayground: PlaygroundComponent {
    @EnvironmentObject var viewModel: ViewModel
    
    @State var text: String = "hello world"
    
    var body: some View {
                
        VStack(alignment: .leading) {
            // placeholder
            // https://stackoverflow.com/a/72411388/663360
            TextEditor(text: $text)
                .disableAutocorrection(true)
                .scrollContentBackground(.hidden)
                .foregroundColor(Color.secondary)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary, lineWidth: 1)
                )
                .padding([.leading, .trailing, .top])
            HStack {
                Spacer()
                Button(action: {
                    print("send")
                }, label: {
                    Text("Send \(Image(systemName: "paperplane"))")
                })
            }
            .padding([.bottom, .trailing])
        }
    }
}



#Preview {
    TextPlayground()
        .environmentObject(ViewModel.mock())
        .frame(width:600, height:400)
}
