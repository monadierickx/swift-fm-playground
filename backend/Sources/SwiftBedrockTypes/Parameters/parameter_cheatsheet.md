

## Text Generation parameters

### Nova 
[user guide](https://docs.aws.amazon.com/nova/latest/userguide/complete-request-schema.html)

| parameter   | minValue | maxValue | defaultValue |
| ----------- | -------- | -------- | ------------ |
| temperature | 0.00001  | 1        | 0.7          |
| maxTokens   | 1        | 5_000    | "dynamic"?   |
| topP        | 0        | 1.0      | 0.9          |
| topK        | 0        | ???      | 50           |


| parameter | maxLength |
| --------- | --------- |
| prompt    | ???       |


| parameter     | maxSequences | defaultVal |
| ------------- | ------------ | ---------- |
| stopSequences | ???          | `[]`       |

### Titan 
[user guide](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-titan-text.html)

| parameter   | minValue | maxValue         | defaultValue |
| ----------- | -------- | ---------------- | ------------ |
| temperature | 0.0      | 1.0              | 0.7          |
| maxTokens   | 0        | depends on model | 512          |
| topP        | 0        | 1                | 0.9          |
| topK        | ???      | ???              | ???          |

| model              | max return tokens |
| ------------------ | ----------------- |
| Titan Text Lite    | 4_096             |
| Titan Text Express | 8_192             |
| Titan Text Premier | 3_072             |


| parameter | maxLength |
| --------- | --------- |
| prompt    | ???       |


| parameter     | maxSequences | defaultVal |
| ------------- | ------------ | ---------- |
| stopSequences | ???          | `[]`       |

### Claude

[user guide](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-anthropic-claude-messages.html)

| parameter   | minValue | maxValue             | defaultValue          |
| ----------- | -------- | -------------------- | --------------------- |
| temperature | 0        | 1                    | 1                     |
| maxTokens   | 1        | depends on the model | ???                   |
| topP        | 0        | 1                    | 0.999                 |
| topK        | 0        | 500                  | "disabled by default" |

[model comparison](https://docs.anthropic.com/en/docs/about-claude/models/all-models#model-comparison)

| models                            | max return tokens |
| --------------------------------- | ----------------- |
| 3 Opus                            | 4_096             |
| 3 Haiku                           | 4_096             |
| 3.5 Haiku                         | 8_192             |
| 3.5 Sonnet                        | 8_192             |
| 3.7 Sonnet                        | 8_192             |
| 3.7 Sonnet with extended thinking | 64_000            |

| parameter | maxLength |
| --------- | --------- |
| prompt    | 200_000   |


| parameter     | maxSequences | defaultVal |
| ------------- | ------------ | ---------- |
| stopSequences | 8191         | `[]`       |

### DeepSeek
 
[user guide](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-deepseek.html)
[deepseek docs](https://api-docs.deepseek.com/quick_start/parameter_settings)

| parameter   | minValue | maxValue | defaultValue |
| ----------- | -------- | -------- | ------------ |
| temperature | 0        | 1        | 1          |
| maxTokens   | 1        | 32_768   | ???          |
| topP        | 0        | 1        | ???          |
| topK        | /        | /        | /            |


| parameter | maxLength |
| --------- | --------- |
| prompt    | ???       |


| parameter     | maxSequences | defaultVal |
| ------------- | ------------ | ---------- |
| stopSequences | 10          | `[]`       |

### Llama
 
[user guide](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-titan-text.html)

- Llama 3 Instruct
- Llama 3.1 Instruct
- Llama 3.2 Instruct
- Llama 3.3 Instruct

| parameter   | minValue | maxValue | defaultValue |
| ----------- | -------- | -------- | ------------ |
| temperature | 0 | 1 | 0.5 |
| maxTokens   | 1 | 2_048 | 512 |
| topP        | 0 | 1 | 0.9 |
| topK        | ??? | ??? | ??? |


| parameter | maxLength |
| --------- | --------- |
| prompt    | ???       |


| parameter     | maxSequences | defaultVal |
| ------------- | ------------ | ---------- |
| stopSequences | ???          | `[]`       |


## Image Generation parameters

### Titan 

| parameter  | minValue | maxValue | defaultValue |
| ---------- | -------- | -------- | ------------ |
| nrOfImages | minValue | maxValue | defaultValue |
| similarity | minValue | maxValue | defaultValue |

| parameter | maxLength |
| --------- | --------- |
| prompt    | ???       |

### Nova 

| parameter  | minValue | maxValue | defaultValue |
| ---------- | -------- | -------- | ------------ |
| nrOfImages | minValue | maxValue | defaultValue |
| similarity | minValue | maxValue | defaultValue |

| parameter | maxLength |
| --------- | --------- |
| prompt    | ???       |
