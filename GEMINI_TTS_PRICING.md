# Gemini TTS Pricing Comparison

## Pricing Structure

### Gemini 2.5 Flash TTS
- **Input tokens**: $0.50 per 1 million text tokens
- **Output tokens**: $10.00 per 1 million audio tokens
- **SKU (Input)**: 242A-EA16-C1EC
- **SKU (Output)**: 9228-79EF-B162

### Gemini 2.5 Pro TTS
- **Input tokens**: $1.00 per 1 million text tokens
- **Output tokens**: $20.00 per 1 million audio tokens
- **SKU (Input)**: 8FF1-7E5B-5BB7
- **SKU (Output)**: DCF3-CB17-8262

---

## Cost Estimate for 1,000 Words

### Assumptions
- **Text tokens**: ~1.33 tokens per word (typical for Gemini models with English text)
- **Audio tokens**: The exact calculation for audio tokens is not publicly documented, but they typically relate to the audio duration or output size. For estimation purposes, we'll use a conservative approach.

### Calculation for 1,000 Words

#### Text Token Calculation
- 1,000 words × 1.33 tokens/word = **~1,330 input tokens**

#### Gemini 2.5 Flash TTS
**Input Cost:**
- 1,330 tokens ÷ 1,000,000 × $0.50 = **$0.000665** (~$0.0007)

**Output Cost (Estimated):**
- Audio tokens are typically proportional to audio duration
- For 1,000 words at ~150 words/minute: ~6.67 minutes of audio
- Assuming audio tokens scale with duration, estimate: **~1,330-2,000 audio tokens**
- Using 1,500 audio tokens as a middle estimate:
  - 1,500 tokens ÷ 1,000,000 × $10.00 = **$0.015**

**Total Estimated Cost: $0.0007 + $0.015 = ~$0.0157** (approximately **$0.016**)

#### Gemini 2.5 Pro TTS
**Input Cost:**
- 1,330 tokens ÷ 1,000,000 × $1.00 = **$0.00133** (~$0.0013)

**Output Cost (Estimated):**
- Using same audio token estimate (1,500 tokens):
  - 1,500 tokens ÷ 1,000,000 × $20.00 = **$0.03**

**Total Estimated Cost: $0.0013 + $0.03 = ~$0.0313** (approximately **$0.031**)

---

## Comparison Summary

| Model | Input Cost | Output Cost (Est.) | **Total Cost** |
|-------|------------|-------------------|----------------|
| **Gemini 2.5 Flash TTS** | $0.0007 | $0.015 | **~$0.016** |
| **Gemini 2.5 Pro TTS** | $0.0013 | $0.03 | **~$0.031** |

### Key Findings
1. **Gemini 2.5 Flash TTS is approximately 2x cheaper** than Pro TTS
2. **Output tokens dominate the cost** (~95% of total cost) due to higher pricing
3. **Input costs are minimal** (~$0.0007-$0.0013) compared to output costs
4. **Cost difference**: Pro TTS costs roughly **$0.015 more** per 1,000 words

---

## Cost Scaling Examples

### 10,000 Words
- **Flash TTS**: ~$0.16
- **Pro TTS**: ~$0.31

### 100,000 Words
- **Flash TTS**: ~$1.60
- **Pro TTS**: ~$3.10

### 1 Million Words
- **Flash TTS**: ~$16.00
- **Pro TTS**: ~$31.00

---

## Important Notes

⚠️ **Audio Token Calculation**: The exact method for calculating audio tokens is not publicly documented by Google. The estimates above assume:
- Audio tokens scale proportionally with audio duration
- Typical speech rate of ~150 words per minute
- The relationship between audio duration and audio tokens is linear

**Recommendation**: 
- For cost-sensitive applications, use **Gemini 2.5 Flash TTS**
- For higher quality requirements, consider **Gemini 2.5 Pro TTS** (though quality differences are not specified in pricing)
- Monitor actual usage to refine cost estimates based on your specific use case

---

## References
- Google AI Pricing: https://ai.google.dev/gemini-api/docs/pricing
- Current implementation uses `gemini-2.5-flash-tts` model (see `gemini_tts_remote_service.dart`)

