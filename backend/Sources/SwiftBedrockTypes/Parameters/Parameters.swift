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

public protocol Parameters: Sendable, Hashable, Equatable {}

public struct Parameter<T: Sendable & Hashable & Equatable>: Sendable, Hashable, Equatable {
    public let minValue: T
    public let maxValue: T
    public let defaultValue: T

    public init(minValue: T, maxValue: T, defaultValue: T) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.defaultValue = defaultValue
    }
}

public struct PromptParams: Parameters {
    public let maxSize: Int
}

public struct StopSequenceParams: Parameters {
    public let maxSequences: Int
    public let defaultValue: [String]
}
