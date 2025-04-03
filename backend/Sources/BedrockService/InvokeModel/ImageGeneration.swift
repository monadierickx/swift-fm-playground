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

// @preconcurrency import AWSBedrockRuntime
// import BedrockTypes
// import Foundation

// extension BedrockService {

//     /// Generates 1 to 5 image(s) from a text prompt using a specific model.
//     /// - Parameters:
//     ///   - prompt: the prompt describing the image that should be generated
//     ///   - model: the BedrockModel that will be used to generate the image
//     ///   - nrOfImages: the number of images that will be generated (must be a number between 1 and 5) optional, default 3
//     /// - Throws: BedrockServiceError.invalidNrOfImages if nrOfImages is not between 1 and 5
//     ///           BedrockServiceError.invalidPrompt if the prompt is empty
//     ///           BedrockServiceError.invalidResponse if the response body is missing
//     /// - Returns: a ImageGenerationOutput object containing an array of generated images
//     public func generateImage(
//         _ prompt: String,
//         with model: BedrockModel,
//         negativePrompt: String? = nil,
//         nrOfImages: Int? = nil,
//         cfgScale: Double? = nil,
//         seed: Int? = nil,
//         quality: ImageQuality? = nil,
//         resolution: ImageResolution? = nil
//     ) async throws -> ImageGenerationOutput {
//         logger.trace(
//             "Generating image(s)",
//             metadata: [
//                 "model.id": .string(model.id),
//                 "model.modality": .string(model.modality.getName()),
//                 "prompt": .string(prompt),
//                 "negativePrompt": .stringConvertible(negativePrompt ?? "not defined"),
//                 "nrOfImages": .stringConvertible(nrOfImages ?? "not defined"),
//                 "cfgScale": .stringConvertible(cfgScale ?? "not defined"),
//                 "seed": .stringConvertible(seed ?? "not defined"),
//             ]
//         )
//         do {
//             let modality = try model.getImageModality()
//             try validateImageGenerationParams(
//                 modality: modality,
//                 nrOfImages: nrOfImages,
//                 cfgScale: cfgScale,
//                 resolution: resolution,
//                 seed: seed
//             )
//             let textToImageModality = try model.getTextToImageModality()
//             try validateTextToImageParams(modality: textToImageModality, prompt: prompt, negativePrompt: negativePrompt)

//             let request: InvokeModelRequest = try InvokeModelRequest.createTextToImageRequest(
//                 model: model,
//                 prompt: prompt,
//                 negativeText: negativePrompt,
//                 nrOfImages: nrOfImages,
//                 cfgScale: cfgScale,
//                 seed: seed,
//                 quality: quality,
//                 resolution: resolution
//             )
//             let input: InvokeModelInput = try request.getInvokeModelInput()
//             logger.trace(
//                 "Sending request to invokeModel",
//                 metadata: [
//                     "model": .string(model.id), "request": .string(String(describing: input)),
//                 ]
//             )
//             let response = try await self.bedrockRuntimeClient.invokeModel(input: input)
//             guard let responseBody = response.body else {
//                 logger.trace(
//                     "Invalid response",
//                     metadata: [
//                         "response": .string(String(describing: response)),
//                         "hasBody": .stringConvertible(response.body != nil),
//                     ]
//                 )
//                 throw BedrockServiceError.invalidSDKResponse(
//                     "Something went wrong while extracting body from response."
//                 )
//             }
//             let invokemodelResponse: InvokeModelResponse = try InvokeModelResponse.createImageResponse(
//                 body: responseBody,
//                 model: model
//             )
//             return try invokemodelResponse.getGeneratedImage()
//         } catch {
//             logger.trace("Error while generating image", metadata: ["error": "\(error)"])
//             throw error
//         }
//     }
// }
