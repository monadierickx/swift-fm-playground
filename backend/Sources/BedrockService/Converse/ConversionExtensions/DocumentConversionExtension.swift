//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Foundation Models Playground open source project
//
// Copyright (c) 2025 Amazon.com, Inc. or its affiliates
//                    and the Swift Foundation Models Playground project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of Swift Foundation Models Playground project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

@preconcurrency import AWSBedrockRuntime
import BedrockTypes
import Foundation

// extension DocumentBlock {
//     init(from sdkDocumentBlock: BedrockRuntimeClientTypes.DocumentBlock) throws {
//         return BedrockRuntimeClientTypes.DocumentBlock(
//             format: format,
//             name: ,
//             source: ,
//         )
//     }
// }

extension DocumentFormat {
    init(from sdkDocumentFormat: BedrockRuntimeClientTypes.DocumentFormat) throws {
        switch sdkDocumentFormat {
        case .csv: self = .csv
        case .doc: self = .doc
        case .docx: self = .docx
        case .html: self = .html
        case .md: self = .md
        case .pdf: self = .pdf
        case .txt: self = .txt
        case .xls: self = .xls
        case .xlsx: self = .xlsx
        case .sdkUnknown(let unknownDocumentFormat):
            throw BedrockServiceError.notImplemented(
                "DocumentFormat \(unknownDocumentFormat) is not implemented by BedrockRuntimeClientTypes"
            )
        }
    }

    func getSDKDocumentFormat() -> BedrockRuntimeClientTypes.DocumentFormat {
        switch self {
        case .csv: return .csv
        case .doc: return .doc
        case .docx: return .docx
        case .html: return .html
        case .md: return .md
        case .pdf: return .pdf
        case .txt: return .txt
        case .xls: return .xls
        case .xlsx: return .xlsx
        }
    }
}
