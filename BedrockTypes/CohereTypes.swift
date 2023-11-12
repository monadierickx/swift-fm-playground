//
//  CohereTypes.swift
//  BedrockTypes
//
//  Created by Stormacq, Sebastien on 11/11/2023.
//

import Foundation

enum CohereEmbedInputType: String, Encodable {
    case searchDocument = "search_document"
    case searchQuery = "search_query"
    case clasification = "classification"
    case clustering = "clustering"
}
enum CohereEmbedTruncating: String, Encodable {
    case none = "NONE"
    case start = "START"
    case end = "END"
}
struct CohereEmbedDocument: Encodable {
    let texts: [String]
    let inputType: CohereEmbedInputType
    let truncate: CohereEmbedTruncating = .end
    
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
}
struct CohereEmbedResponse: Decodable, CustomStringConvertible {
    let embeddings: [[Double]]
    let id: String
    let texts: [String]
    
    init(from data: Data) throws {
        let decoder = JSONDecoder()
        self = try decoder.decode(CohereEmbedResponse.self, from: data)
    }
    
    var description: String {
        guard embeddings.count > 0 else {
            return "no embeddings"
        }
        let embedding = embeddings[0]
        let elementsToShow = min(5, embedding.count)
        return "[" +
        embedding[0..<elementsToShow].map { String(format: "%.3f", $0) }.joined(separator: ",")
        + ",...] (\(embedding.count) elements)"
    }
}
