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

public struct ImageGenerationParameters: Parameters {
    public let prompt: PromptParams
    public let nrOfImages: Parameter<Int>
    public let similarity: Parameter<Double>

    public init(
        nrOfImages: Parameter<Int> = Parameter(minValue: 1, maxValue: 5, defaultValue: 1),
        similarity: Parameter<Double> = Parameter(minValue: 0.2, maxValue: 1.0, defaultValue: 0.6),
        maxPromptSize: Int = 25_000
    ) {
        self.prompt = PromptParams(maxSize: maxPromptSize)
        self.nrOfImages = nrOfImages
        self.similarity = similarity
    }
}
