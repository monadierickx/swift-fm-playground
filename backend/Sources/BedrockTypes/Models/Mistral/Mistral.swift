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

import Foundation

struct MistralConverse: ConverseModality {
    func getName() -> String { "Mistral Converse Modality" }

    let converseParameters: ConverseParameters
    let converseFeatures: [ConverseFeature]

    init(parameters: ConverseParameters, features: [ConverseFeature]) {
        self.converseParameters = parameters
        self.converseFeatures = features
    }
}
