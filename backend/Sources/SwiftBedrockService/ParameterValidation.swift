// //===----------------------------------------------------------------------===//
// //
// // This source file is part of the Swift Foundation Models Playground open source project
// //
// // Copyright (c) 2025 Amazon.com, Inc. or its affiliates
// //                    and the Swift Foundation Models Playground project authors
// // Licensed under Apache License v2.0
// //
// // See LICENSE.txt for license information
// // See CONTRIBUTORS.txt for the list of Swift Foundation Models Playground project authors
// //
// // SPDX-License-Identifier: Apache-2.0
// //
// //===----------------------------------------------------------------------===//

// import Foundation
// import SwiftBedrockTypes

// public extension SwiftBedrock {

//     /// Validate maxTokens is at least a minimum value
//     private func validateMaxTokens(_ maxTokens: Int, max: Int) throws {
//         guard maxTokens >= 1 else {
//             logger.trace(
//                 "Invalid maxTokens",
//                 metadata: ["maxTokens": .stringConvertible(maxTokens)]
//             )
//             throw SwiftBedrockError.invalidMaxTokens(
//                 "MaxTokens should be between 1 and \(max). MaxTokens: \(maxTokens)"
//             )
//         }
//     }

//     /// Validate temperature is between a minimum and a maximum value
//     private func validateTemperature(_ temperature: Double, min: Double, max: Double) throws {
//         guard temperature >= min && temperature <= max else {
//             logger.trace(
//                 "Invalid temperature",
//                 metadata: ["temperature": "\(temperature)"]
//             )
//             throw SwiftBedrockError.invalidTemperature(
//                 "Temperature should be a value between \(min) and \(max). Temperature: \(temperature)"
//             )
//         }
//     }

//     /// Validate topP is between a minimum and a maximum value
//     private func validateTopP(_ topP: Double, min: Double, max: Double) throws {
//         guard topP >= min && topP <= max else {
//             logger.trace(
//                 "Invalid topP",
//                 metadata: ["topP": "\(topP)"]
//             )
//             throw SwiftBedrockError.invalidTopP(
//                 "TopP should be a value between \(min) and \(max). TopP: \(topP)"
//             )
//         }
//     }

//     /// Validate topK is at least a minimum value
//     private func validateTopK(_ topK: Int, min: Int, max: Int) throws {
//         guard topK >= min else {
//             logger.trace(
//                 "Invalid topK",
//                 metadata: ["topK": .stringConvertible(topK)]
//             )
//             throw SwiftBedrockError.invalidTopK(
//                 "TopK should be between \(min) and \(max). TopK: \(topK)"
//             )
//         }
//     }

//     /// Validate prompt is not empty and does not consist of only whitespaces, tabs or newlines
//     /// Additionally validates that the prompt is not longer than the maxPromptTokens
//     private func validatePrompt(_ prompt: String, maxPromptTokens: Int) throws {
//         guard !prompt.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
//             logger.trace("Invalid prompt", metadata: ["prompt": .string(prompt)])
//             throw SwiftBedrockError.invalidPrompt("Prompt is not allowed to be empty.")
//         }
//         let length = prompt.utf8.count
//         guard length <= maxPromptTokens else {
//             logger.trace(
//                 "Invalid prompt",
//                 metadata: [
//                     "prompt": .string(prompt),
//                     "prompt.length": "\(length)",
//                     "maxPromptTokens": "\(maxPromptTokens)",
//                 ]
//             )
//             throw SwiftBedrockError.invalidPrompt(
//                 "Prompt is not allowed to be longer than \(maxPromptTokens) tokens. Prompt length: \(length)"
//             )
//         }
//     }

//     /// Validate nrOfImages is between a minimum and a maximum value
//     private func validateNrOfImages(_ nrOfImages: Int, min: Int, max: Int) throws {
//         guard nrOfImages >= min && nrOfImages <= max else {
//             logger.trace(
//                 "Invalid nrOfImages",
//                 metadata: ["nrOfImages": .stringConvertible(nrOfImages)]
//             )
//             throw SwiftBedrockError.invalidNrOfImages(
//                 "NrOfImages should be between \(min) and \(max). nrOfImages: \(nrOfImages)"
//             )
//         }
//     }

//     /// Validate similarity is between a minimum and a maximum value
//     private func validateSimilarity(_ similarity: Double, min: Double, max: Double) throws {
//         guard similarity >= min && similarity <= max else {
//             logger.trace(
//                 "Invalid similarity",
//                 metadata: ["similarity": .stringConvertible(similarity)]
//             )
//             throw SwiftBedrockError.invalidSimilarity(
//                 "Similarity should be between \(min) and \(max). similarity: \(similarity)"
//             )
//         }
//     }

//     /// Validate cfgScale is between a minimum and a maximum value
//     private func validateCfgScale(_ cfgScale: Double, min: Double, max: Double) throws {
//         guard cfgScale >= min && cfgScale <= max else {
//             logger.trace(
//                 "Invalid cfgScale",
//                 metadata: ["cfgScale": .stringConvertible(cfgScale)]
//             )
//             throw SwiftBedrockError.invalidCfgScale(
//                 "Similarity should be between \(min) and \(max). cfgScale: \(cfgScale)"
//             )
//         }
//     }

//     /// Validate seed is at least a minimum value
//     private func validateSeed(_ seed: Int, min: Int, max: Int) throws {
//         guard seed >= min else {
//             logger.trace(
//                 "Invalid seed",
//                 metadata: ["seed": .stringConvertible(seed)]
//             )
//             throw SwiftBedrockError.invalidSeed(
//                 "Seed should be between \(min) and \(max). Seed: \(seed)"
//             )
//         }
//     }

//     /// Validate that not more stopsequences than allowed were given
//     private func validateStopSequences(_ stopSequences: [String], maxNrOfStopSequences: Int) throws {
//         guard stopSequences.count <= maxNrOfStopSequences else {
//             logger.trace(
//                 "Invalid stopSequences",
//                 metadata: [
//                     "stopSequences": "\(stopSequences)",
//                     "stopSequences.count": "\(stopSequences.count)",
//                     "maxNrOfStopSequences": "\(maxNrOfStopSequences)",
//                 ]
//             )
//             throw SwiftBedrockError.invalidStopSequences(
//                 "You can only provide up to \(maxNrOfStopSequences) stop sequences. Number of stop sequences: \(stopSequences.count)"
//             )
//         }
//     }
// }