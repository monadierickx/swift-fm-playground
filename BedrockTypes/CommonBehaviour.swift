//
//  CommonBehaviour.swift
//  BedrockTypes
//
//  Created by Stormacq, Sebastien on 31/10/2023.
//

import Foundation

//public protocol BedrockType: Codable {
//    func payload(forPrompt: String) throws -> Data
//    func result(from: Data) throws -> String
//}
//
//public protocol BedrockTypeCoders {
//    var encoder: JSONEncoder { get }
//    var decoder: JSONDecoder { get }
//}
//
//public extension BedrockTypeCoders {
//    // json encoding and decoding tools
//    var encoder: JSONEncoder {
//        get {
//            let result = JSONEncoder()
//            result.keyEncodingStrategy = .convertToSnakeCase
//            return result
//        }
//    }
//    var decoder: JSONDecoder {
//        get {
//            let result = JSONDecoder()
//            result.keyDecodingStrategy = .convertFromSnakeCase
//            return result
//        }
//    }
//}

public extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
