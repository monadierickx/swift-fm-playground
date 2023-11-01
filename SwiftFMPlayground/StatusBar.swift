//
//  StatusBar.swift
//  Swift FM Playground
//
//  Created by Stormacq, Sebastien on 09/10/2023.
//

import SwiftUI

enum Status: Equatable {
    
    case ready(msg: String = "Ready.")
    case busy(msg: String = "Loading...")
    case streaming(msg: String = "Receiving...")
    func image() -> some View {
        switch self {
        case .ready:
            return Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
        case .busy:
            return Image(systemName: "hourglass.circle.fill").foregroundStyle(.orange)
        case .streaming:
            return Image(systemName: "icloud.and.arrow.down.fill").foregroundStyle(.orange)
        }
    }
    func message() -> String {
        switch self {
        case .ready(let msg):
            return msg
        case .busy(let msg):
            return msg
        case .streaming(let msg):
            return msg
        }
    }
}

struct StatusBar: View {
    
    var state: Status
    
    var body: some View {
        HStack {
            Spacer()
            state.image()
            Text(state.message())
        }
        .animation(.easeOut, value: state)
        .padding()
        .border(.quinary) // TODO: put line on top only
    }
}

#Preview("Ready") {
    StatusBar(state: .ready())
}

#Preview("Busy") {
    StatusBar(state: .busy())
}

#Preview("Streaming") {
    StatusBar(state: .streaming())
}
