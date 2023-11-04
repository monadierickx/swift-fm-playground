//
//  Parameter.swift
//  Swift FM Playground
//
//  Created by Stormacq, Sebastien on 02/11/2023.
//
import BedrockTypes

enum BedrockModelParameter  {
    case double(BedrockModelParameterNumber<Double>)
    case int(BedrockModelParameterNumber<Int>)
    case string(BedrockModelParameterString)
}


// parameter name : value (and other characteristics for UI, such as minValue, maxValue, UI Label ...)
typealias ModelParameters = [String: BedrockModelParameter]

// modelid => list of model parameters
typealias AllModelParameters = [BedrockModelIdentifier: ModelParameters]


protocol BedrockNumericalValue {
    associatedtype Number
//    func value() -> Number
}
//struct AnyBedrockNumericalValue<Number>:BedrockNumericalValue {
//    private let _value: () -> Number
//    init<V: BedrockNumericalValue>(wrappedValue: V) where V.Number == Number {
//        self._value = wrappedValue.value
//    }
//    func value() -> Number {
//        return _value()
//    }
//}
extension Int: BedrockNumericalValue {
    typealias Number = Int
//    func value() -> Int {
//        return self
//    }
    
}
extension Double:BedrockNumericalValue {
    typealias Number = Double
//    func value() -> Double {
//        return self
//    }
}

struct BedrockModelParameterNumber<T : BedrockNumericalValue> {
//    var value: AnyBedrockNumericalValue<T>
    var value: any BedrockNumericalValue = 0.0
    let label: String
    let minValue: Double
    let maxValue: Double
    init (value: any BedrockNumericalValue, label: String, minValue: Double, maxValue: Double) {
//    init (value: AnyBedrockNumericalValue<T>, label: String, minValue: Double, maxValue: Double) {
        self.value = value
        self.label = label
        self.minValue = minValue
        self.maxValue = maxValue
    }
    // TODO: there must be a more elegant want to write the code below, using the associated type and type erasue ?
    var intValue: Int  {
        get {
            if let result = value as? Int { return result }
            if let result = value as? Double { return Int(result) }
            fatalError("unless I made a mistake, it is impossible to arrive here")
        }
    }
    var doubleValue: Double {
        get {
            if let result = value as? Int { return Double(result) }
            if let result = value as? Double { return result }
            fatalError("unless I made a mistake, it is impossible to arrive here")
        }
        set {
            self.value = newValue
        }
    }
    var stringValue: String {
        get {
            if let result = value as? Int { return String(format:"%.3d",result) }
            if let result = value as? Double { return String(format:"%.3f",result) }
            fatalError("unless I made a mistake, it is impossible to arrive here")

        }
    }
//    var doubleXXValue : AnyBedrockNumericalValue<Double> {
//        if let result = value as? Double {
//            return AnyBedrockNumericalValue(wrappedValue: result)
//        } else if let result = value as? Int {
//            return AnyBedrockNumericalValue(wrappedValue: Double(result))
//        } else {
//            fatalError("impossible")
//        }
//    }
}
struct BedrockModelParameterString {
    var value: [String] = []
    let label: String
    let maxValues: Int
    init (value: [String], label: String, maxValues: Int = 1) {
        self.value = value
        self.label = label
        self.maxValues = maxValues
    }
}
