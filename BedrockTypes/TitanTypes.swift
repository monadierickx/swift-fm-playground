//
//  TitanTypes.swift
//  swift-fm-playground
//
//  Created by Stormacq, Sebastien on 11/11/2023.
//

import Foundation

struct TitanEmbedDocument: Encodable {
    let inputText: String
    
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
}

struct TitanEmbedResponse: Decodable, CustomStringConvertible {
    
    let embedding: [Double]
    let inputTextTokenCount: Int
    
    init(from data: Data) throws {
        let decoder = JSONDecoder()
        self = try decoder.decode(TitanEmbedResponse.self, from: data)
    }
    
    var description: String {
        let elementsToShow = min(5, embedding.count)
        return "[" +
        embedding[0..<elementsToShow].map { String(format: "%.3f", $0) }.joined(separator: ",")
        + ",...] (\(embedding.count) elements)"
    }
}
