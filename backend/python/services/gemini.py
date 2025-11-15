"""Google Gemini TTS service using Google Cloud Text-to-Speech API."""
import json
from typing import Optional, Tuple, Any
import httpx
from fastapi import HTTPException
from google.auth import default
from google.auth.transport.requests import Request

# Cache for credentials
_credentials: Optional[Any] = None
_credentials_error: Optional[str] = None

def _get_credentials() -> Tuple[Optional[Any], Optional[str]]:
    """Get OAuth2 credentials using Application Default Credentials."""
    global _credentials, _credentials_error
    if _credentials is None and _credentials_error is None:
        try:
            credentials, project = default()
            # Refresh if needed
            if not credentials.valid:  # type: ignore
                credentials.refresh(Request())  # type: ignore
            _credentials = credentials
        except Exception as e:
            _credentials_error = str(e)
    return _credentials, _credentials_error


async def synthesize(text: str, voice: str = "Kore", language: str = "en-US", 
                     audio_format: str = "mp3", prompt: Optional[str] = None) -> dict:
    """Synthesize speech using Google Cloud Text-to-Speech API with Gemini model."""
    credentials, error = _get_credentials()
    
    if credentials is None:
        error_msg = (
            "Google Cloud TTS not configured. "
            "Set up authentication using one of:\n"
            "1. Service account: export GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json\n"
            "2. Application Default Credentials: gcloud auth application-default login\n"
            f"Error: {error or 'Unknown authentication error'}"
        )
        raise HTTPException(503, error_msg)
    
    # Get access token
    if not credentials.valid:
        credentials.refresh(Request())
    access_token: str = credentials.token  # type: ignore
    
    url = "https://texttospeech.googleapis.com/v1/text:synthesize"
    
    # Format mapping
    format_map = {
        "mp3": "MP3",
        "wav": "LINEAR16",
        "ogg": "OGG_OPUS",
        "opus": "OGG_OPUS",
    }
    
    payload = {
        "input": {"text": text},
        "voice": {
            "languageCode": language,
            "name": voice,
            "modelName": "gemini-2.5-flash-tts",
        },
        "audioConfig": {
            "audioEncoding": format_map.get(audio_format, "MP3"),
        },
    }
    
    if prompt:
        payload["input"]["prompt"] = prompt
    
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json",
    }
    
    try:
        async with httpx.AsyncClient(timeout=30.0) as client:
            resp = await client.post(url, json=payload, headers=headers)
            
            if resp.status_code != 200:
                raise HTTPException(resp.status_code, f"Gemini API error: {resp.text}")
            
            data = resp.json()
            word_count = len(text.split())
            duration_ms = int((word_count / 150) * 60 * 1000)
            
            return {
                "audio_data": data["audioContent"],
                "audio_format": audio_format,
                "duration_ms": duration_ms,
                "metadata": json.dumps({"service": "gemini", "voice": voice}),
            }
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(500, f"Google Cloud TTS error: {str(e)}")

