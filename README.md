# SwiftBedrockService

Work in progress, feel free to open issue, but do not use in your projects. 

## How to add a new model family?

As an example we will add the Llama 3.1 70B Instruct model from the Meta family as an example.

"meta.llama3-70b-instruct-v1:0"

### 1. Add create BedrockModel instance

```swift
extension BedrockModel {
    public static let llama3_70b_instruct: BedrockModel = BedrockModel(
        id: "meta.llama3-70b-instruct-v1:0",
        modality: LlamaText()
    )
}
```

### 2. Create family-specific request and response struct

Make sure to create a struct that reflects exactly how the body of the request for an invokeModel call to this family should look. Make sure to add the public initializer with parameters `prompt`, `maxTokens` and `temperature` to comply to the `BedrockBodyCodable` protocol. 

```json
{
    "prompt": "\(prompt)",
    "temperature": 1, 
    "top_p": 0.9,
    "max_tokens": 200,
    "stop": ["END"]
}
```

```swift
public struct LlamaRequestBody: BedrockBodyCodable {
    let prompt: String
    let max_gen_len: Int
    let temperature: Double
    let top_p: Double

    public init(prompt: String, maxTokens: Int = 512, temperature: Double = 0.5) {
        self.prompt =
            "<|begin_of_text|><|start_header_id|>user<|end_header_id|>\(prompt)<|eot_id|><|start_header_id|>assistant<|end_header_id|>"
        self.max_gen_len = maxTokens
        self.temperature = temperature
        self.top_p = 0.9
    }
}
```

Do the same for the response and ensure to add the `getTextCompletion` method to extract the completion from the response body and to comply to the `ContainsTextCompletion` protocol.

```json
{
    "generation": "\n\n<response>",
    "prompt_token_count": int,
    "generation_token_count": int,
    "stop_reason" : string
}
```

```swift
struct LlamaResponseBody: ContainsTextCompletion {
    let generation: String
    let prompt_token_count: Int
    let generation_token_count: Int
    let stop_reason: String

    public func getTextCompletion() throws -> TextCompletion {
        TextCompletion(generation)
    }
}
```

### 3. Add the Modality (TextModality or ImageModality)

For a text generation create a struct conforming to TextModality. Use the request body and response body you created in  [the previous step](#2-create-family-specific-request-and-response-struct). 

```swift
struct LlamaText: TextModality {
    func getName() -> String { "Llama Text Generation" }

    func getTextRequestBody(prompt: String, maxTokens: Int, temperature: Double) throws -> BedrockBodyCodable {
        LlamaRequestBody(prompt: prompt, maxTokens: maxTokens, temperature: temperature)
    }

    func getTextResponseBody(from data: Data) throws -> ContainsTextCompletion {
        let decoder = JSONDecoder()
        return try decoder.decode(LlamaResponseBody.self, from: data)
    }
}
```

### 4. Optionally you can create a BedrockModel initializer for your newly implemented models
```swift
extension BedrockModel {
    init?(_ id: String) {
        switch id {
        case "meta.llama3-70b-instruct-v1:0": self = .llama3_70b_instruct
        // ... 
        default:
            return nil
        }
    }
}
```


## How to add a new model?

If you want to add a model that has a request and response structure that is already implemented you can skip a few steps. Simply create a typealias for the Modality that matches the structure and use it to create a BedrockModel instance. 

```swift
typealias ClaudeNewModel = AnthropicText

extension BedrockModel {
    public static let instant: BedrockModel = BedrockModel(
        id: "anthropic.claude-new-model",
        modality: ClaudeNewModel()
    )
}
```

Note that the model will not automatically be included in the BedrockModel initializer that creates an instance from a raw string value. Consider creating a custom initializer that includes your models. 
