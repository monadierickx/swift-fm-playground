//
//  BEdrockModelParametersUI.swift
//  Bedrock Types
//
//  Created by Stormacq, Sebastien on 02/11/2023.
//
// a generic way to represent model parameters to display in the UI

import BedrockTypes

// modelid => list of model parameters
public typealias AllModelParameters = [BedrockModelIdentifier: ModelParameters]

public enum BedrockModelParameter: Encodable  {
    case number(BedrockModelParameterNumber)
    case string(BedrockModelParameterString)
}

// parameter name : value (and other characteristics for UI, such as minValue, maxValue, UI Label ...)
public typealias ModelParameters = [String: BedrockModelParameter]

public struct BedrockModelParameterNumber: Encodable {
    public var value: Double
    public let label: String
    public let minValue: Double
    public let maxValue: Double
    public private(set) var isInt: Bool = false
    public let displayOrder: Int
    public init (value: Double, label: String, minValue: Double, maxValue: Double, displayOrder: Int) {
        self.value = value
        self.label = label
        self.minValue = minValue
        self.maxValue = maxValue
        self.displayOrder = displayOrder
    }
    public init (value: Int, label: String, minValue: Double, maxValue: Double, displayOrder: Int) {
        self.init(value: Double(value), label: label, minValue: minValue, maxValue: maxValue, displayOrder: displayOrder)
        self.isInt = true
    }
    public var intValue: Int  {
        get { Int(self.value) }
        set {
            self.isInt = true
            self.value = Double(newValue)
        }
    }
    public func stringValue() -> String {
        isInt ? String(format: "%3d", Int(self.value)) : String(format: "%.3f", self.value)
    }

    enum CodingKeys: String, CodingKey {
      case value
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try? container.encode(self.value)
    }
}
public struct BedrockModelParameterString: Encodable {
    public var value: [String] = []
    public let label: String
    public let maxValues: Int
    public let displayOrder: Int
    public init (value: [String], label: String, maxValues: Int = 1, displayOrder: Int) {
        self.value = value
        self.label = label
        self.maxValues = maxValues
        self.displayOrder = displayOrder
    }
}
