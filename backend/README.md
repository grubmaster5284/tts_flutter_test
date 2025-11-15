# TTS Backend API

> **⚠️ NOTE**: This backend server is **optional** and not required for the Flutter app. The Flutter app now uses Python scripts directly via platform channels. See [GUIDE.md](../GUIDE.md) for the current setup.

This backend can still be used for standalone API usage or testing purposes.

Simple Python backend for Text-to-Speech synthesis. Supports Google Gemini TTS and OpenAI TTS.

## Setup

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Configure authentication:

**For OpenAI TTS:**
```bash
export OPENAI_API_KEY=your_key_here
```

**For Gemini TTS (Google Cloud Text-to-Speech):**
Google Cloud TTS requires OAuth2 authentication, not API keys. Set up authentication using one of these methods:

**Option 1: Service Account (Recommended for production)**
1. Create a service account in [Google Cloud Console](https://console.cloud.google.com/iam-admin/serviceaccounts)
2. Grant the "Cloud Text-to-Speech API User" role
3. Download the JSON key file
4. Set the environment variable:
```bash
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/your/service-account-key.json
```

**Option 2: Application Default Credentials (For local development)**
```bash
gcloud auth application-default login
```

**Important:** Make sure the Text-to-Speech API is enabled in your Google Cloud project:
- Go to [Google Cloud Console APIs](https://console.cloud.google.com/apis/library/texttospeech.googleapis.com)
- Enable the "Cloud Text-to-Speech API"

**For detailed setup instructions, see [GUIDE.md](../GUIDE.md#google-cloud-setup)**

3. Run the server:
```bash
python main.py
# or
uvicorn main:app --reload
```

Server runs on `http://localhost:8000`

## API

### POST /api/v1/tts/synthesize

Synthesize speech from text.

**Request:**
```json
{
  "text": "Hello, world!",
  "service": "gemini",
  "voice": "Kore",
  "language": "en-US",
  "audio_format": "mp3",
  "prompt": "Say this in a friendly way"  // Gemini only
}
```

**Response:**
```json
{
  "audio_data": "base64_encoded_audio",
  "audio_format": "mp3",
  "duration_ms": 2000,
  "metadata": "{\"service\": \"gemini\", \"voice\": \"Kore\"}"
}
```

## Services

- **Gemini**: Uses Google Cloud Text-to-Speech API with OAuth2 authentication. Requires `GOOGLE_APPLICATION_CREDENTIALS` (service account) or `gcloud auth application-default login`. Supports style prompts via `prompt` field and uses the `gemini-2.5-flash-tts` model.
- **OpenAI**: Set `OPENAI_API_KEY` environment variable. Supports speed control via `speed` field (0.25-4.0).
