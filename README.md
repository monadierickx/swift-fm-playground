# SwiftBedrockService

This library is a work in progress, feel free to open an issue, but do not use it in your projects just yet. 

## How to get started with BedrockService

1. Import the BedrockService and BedrockTypes

```swift 
import BedrockService
import BedrockTypes
```

2. Initialize the BedrockService

Choose what Region to use, whether to use AWS SSO authentication instead of standard credentials and pass a logger. If no region is passed it will default to `.useast1`, if no logger is provided a default logger with the name `bedrock.service` is created. The log level will be set to the environment variable `SWIFT_BEDROCK_LOG_LEVEL` or default to `.trace`. If `useSSO` is not defined it will default to `false` and use the standard credentials for authentication.

```swift 
let bedrock = try await BedrockService(
    region: .uswest1,
    logger: logger,
    useSSO: true
) 
```

3. List the available models

Use the `listModels()` function to test your set-up. This function will return an array of `ModelSummary` objects, each one representing a model supported by Amazon Bedrock. The ModelSummaries that contain a `BedrockModel` object are the models supported by BedrockService. 

```swift
let models = try await bedrock.listModels()
```

## How to generate text using the InvokeModel API

Choose a BedrockModel that supports text generation, you can verify this using the `hasTextModality` function. when calling the `completeText` function you can provide some inference parameters: 

- `maxTokens`: The maximum amount of tokens that the model is allowed to return
- `temperature`: Controls the randomness of the model's output
- `topP`: Nucleus sampling, this parameter controls the cumulative probability threshold for token selection
- `topK`: Limits the number of tokens the model considers for each step of text generation to the K most likely ones
- `stopSequences`: An array of strings that will cause the model to stop generating further text when encountered

The function returns a `TextCompletion` object containg the generated text.

```swift
let model = .anthropicClaude3Sonnet

guard model.hasTextModality() else {
    print("\(model.name) does not support text completion")
}

let textCompletion = try await bedrock.completeText(
    "Write a story about a space adventure",
    with: model,
    maxTokens: 1000,
    temperature: 0.7,
    topP: 0.9,
    topK: 250,
    stopSequences: ["THE END"]
)
```

Note that the minimum, maximum and default values for each parameter are model specific and defined when the BedrockModel is created. Some parameters might not be supported by certain models.

## How to generate an image using the InvokeModel API

Choose a BedrockModel that supports image generation - you can verify this using the `hasImageModality` and the `hasTextToImageModality` function. The `generateImage` function allows you to create images from text descriptions with various optional parameters:

- `prompt`: Text description of the desired image
- `negativePrompt`: Text describing what to avoid in the generated image
- `nrOfImages`: Number of images to generate
- `cfgScale`: Classifier free guidance scale to control how closely the image follows the prompt
- `seed`: Seed for reproducible image generation
- `quality`: Parameter to control the quality of generated images
- `resolution`: Desired image resolution for the generated images

The function returns an ImageGenerationOutput object containing an array of generated images in base64 format.

```swift
let model = .nova_canvas

guard model.hasImageModality(),
      model.hasTextToImageModality() else {
    print("\(model.name) does not support image generation")
}

let imageGeneration = try await bedrock.generateImage(
    "A serene landscape with mountains at sunset",
    with: model,
    negativePrompt: "dark, stormy, people",
    nrOfImages: 3,
    cfgScale: 7.0,
    seed: 42,
    quality: .standard,
    resolution: ImageResolution(width: 100, height: 100)
)
```

Note that the minimum, maximum and default values for each parameter are model specific and defined when the BedrockModel is created. Some parameters might not be supported by certain models.

## How to generate image variations using the InvokeModel API
Choose a BedrockModel that supports image variations - you can verify this using the `hasImageVariationModality` and the `hasImageVariationModality` function. The `generateImageVariation` function allows you to create variations of an existing image with these parameters:

- `images`: The base64-encoded source images used to create variations from
- `negativePrompt`: Text describing what to avoid in the generated image
- `similarity`: Controls how similar the variations will be to the source images
- `nrOfImages`: Number of variations to generate
- `cfgScale`: Classifier free guidance scale to control how closely variations follow the original image
- `seed`: Seed for reproducible variation generation
- `quality`: Parameter to control the quality of generated variations
- `resolution`: Desired resolution for the output variations

This function returns an `ImageGenerationOutput` object containing an array of generated image variations in base64 format. Each variation will maintain key characteristics of the source images while introducing creative differences.

```swift
let model = .nova_canvas

guard model.hasImageVariationModality(),
      model.hasImageVariationModality() else {
    print("\(model.name) does not support image variations")
}

let imageVariations = try await bedrock.generateImageVariation(
    images: [base64EncodedImage],
    prompt: "A dog drinking out of this teacup",
    with: model,
    negativePrompt: "Cats, worms, rain",
    similarity: 0.8,
    nrOfVariations: 4,
    cfgScale: 7.0,
    seed: 42,
    quality: .standard,
    resolution: ImageResolution(width: 100, height: 100)
)
```

Note that the minimum, maximum and default values for each parameter are model specific and defined when the BedrockModel is created. Some parameters might not be supported by certain models.

## How to chat using the Converse API

### Text prompt

### Vision

### Tools

## How to add a BedrockModel

### Text

### Image

### Converse


