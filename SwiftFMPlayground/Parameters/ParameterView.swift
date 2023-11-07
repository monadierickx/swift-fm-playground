//
//  ParameterView.swift
//  Swift FM Playground
//
//  Created by Stormacq, Sebastien on 02/11/2023.
//

import SwiftUI
import BedrockTypes

struct NumericalParameter: View  {
    @State var p: BedrockModelParameterNumber
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(p.label)
                Text(p.stringValue())
            }
            Slider(value: $p.value, in:p.minValue...p.maxValue)
        }
    }
}

struct StringParameter: View {
    @State var oneValue: String = "enter additional stop sequences"
    @State var p: BedrockModelParameterString

    var body: some View {
        VStack(alignment: .leading) {
            Text(p.label)
            HStack {
                
                TextField(p.label, text: $oneValue)
                
                let mv = p.maxValues
                Button(action: {
                    p.value.append(oneValue)
                    oneValue = ""
                }, label: {
                    Text("Add")
                })
                .disabled(p.value.count >= mv)
            }
            VStack(alignment: .leading) {
                ForEach(p.value, id: \.self) { element in
                    HStack {
                        Text("\"\(element)\"")
                            .lineLimit(1)
                            .fixedSize()
                        Button(action: {
                            if let index = p.value.firstIndex(of: element) {
                                p.value.remove(at: index)
                            }
                        }, label: {
                            Text(Image(systemName: "xmark.circle"))
                        }).buttonStyle(BorderlessButtonStyle())
                    }
                    .padding(5)
                    .foregroundStyle(.primary)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                }
            }
        }
    }
}


#Preview("All") {
    let dp = BedrockModelParameterNumber(value: 0.5,
                                                 label: "Temperature:",
                                                 minValue: 0.0,
                                                 maxValue: 1.0)
    let ip = BedrockModelParameterNumber(value: 100,
                                              label: "Length:",
                                              minValue: 10, maxValue: 256)
    let sp = BedrockModelParameterString(value: ["/n/nHuman"],
                                         label: "Stop sequence:",
                                         maxValues: 5)
    return VStack {
        Group {
            NumericalParameter(p: dp)
            NumericalParameter(p: ip)
            StringParameter(p: sp)
        }
        .padding()
    }
}

#Preview("Double") {
    let dp = BedrockModelParameterNumber(value: 0.5,
                                                 label: "Temperature:",
                                                 minValue: 0.0,
                                                 maxValue: 1.0)
    return NumericalParameter(p: dp)
}

#Preview("Int") {
    let ip = BedrockModelParameterNumber(value: 100,
                                              label: "Length:",
                                              minValue: 10, maxValue: 256)
    return NumericalParameter(p: ip)
}

#Preview("String") {
    let sp = BedrockModelParameterString(value: ["/n/nHuman"],
                                         label: "Stop sequence:",
                                         maxValues: 5)
    return StringParameter(p: sp)
}
