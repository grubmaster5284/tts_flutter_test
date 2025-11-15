#!/usr/bin/env python3
"""Standalone Gemini TTS script - called from Flutter via platform channels."""
import sys
import json
import httpx

# Try to import google.auth for OAuth2 authentication
try:
    from google.auth import default
    from google.auth.transport.requests import Request
    GOOGLE_AUTH_AVAILABLE = True
except ImportError:
    GOOGLE_AUTH_AVAILABLE = False


def _get_access_token():
    """Get OAuth2 access token using Application Default Credentials."""
    if not GOOGLE_AUTH_AVAILABLE:
        return None, "google-auth library not installed. Install with: pip install google-auth google-auth-httplib2 requests"
    
    try:
        credentials, project = default()
        # Refresh if needed
        if not credentials.valid:  # type: ignore
            credentials.refresh(Request())  # type: ignore
        return credentials.token, None  # type: ignore
    except Exception as e:
        error_msg = str(e)
        # Provide more helpful error message
        if "was not found" in error_msg or "default credentials were not found" in error_msg:
            return None, (
                "Google Cloud credentials not found. "
                "To set up authentication, run in your terminal:\n"
                "  gcloud auth application-default login\n"
                "Or set GOOGLE_APPLICATION_CREDENTIALS environment variable to point to a service account key file."
            )
        return None, error_msg


def synthesize(text: str, voice: str = "Kore", language: str = "en-US", 
               audio_format: str = "mp3", prompt: str = None) -> dict:
    """Synthesize speech using Google Cloud Text-to-Speech API with Gemini model."""
    # Get OAuth2 access token
    access_token, error = _get_access_token()
    
    if access_token is None:
        # Provide helpful error message based on context
        if "was not found" in (error or "") or "default credentials were not found" in (error or ""):
            error_msg = (
                "Google Cloud credentials not found.\n\n"
                "For Flutter app (sandboxed):\n"
                "  Place a service account key file in one of these locations:\n"
                "  - backend/python/service-account-key.json (recommended)\n"
                "  - service-account-key.json (project root)\n"
                "  - .gcloud/service-account-key.json (project root)\n\n"
                "For backend server only:\n"
                "  Run: gcloud auth application-default login\n\n"
                f"Original error: {error or 'Unknown authentication error'}"
            )
        else:
            error_msg = (
                "Google Cloud TTS not configured. "
                "Set up authentication using one of:\n"
                "1. Service account: Place key file in backend/python/service-account-key.json\n"
                "2. Application Default Credentials: gcloud auth application-default login\n"
                f"Error: {error or 'Unknown authentication error'}"
            )
        return {
            "error": error_msg,
            "success": False
        }
    
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
        with httpx.Client(timeout=30.0) as client:
            resp = client.post(url, json=payload, headers=headers)
            
            if resp.status_code != 200:
                return {
                    "error": f"Gemini API error: {resp.text}",
                    "success": False
                }
            
            data = resp.json()
            word_count = len(text.split())
            duration_ms = int((word_count / 150) * 60 * 1000)
            
            return {
                "audio_data": data["audioContent"],
                "audio_format": audio_format,
                "duration_ms": duration_ms,
                "metadata": json.dumps({"service": "gemini", "voice": voice}),
                "success": True
            }
    except Exception as e:
        return {
            "error": str(e),
            "success": False
        }


if __name__ == "__main__":
    # Read JSON input from stdin
    try:
        input_data = json.loads(sys.stdin.read())
        
        result = synthesize(
            text=input_data.get("text", ""),
            voice=input_data.get("voice", "Kore"),
            language=input_data.get("language", "en-US"),
            audio_format=input_data.get("audio_format", "mp3"),
            prompt=input_data.get("prompt")
        )
        
        # Output JSON result to stdout
        print(json.dumps(result))
    except Exception as e:
        print(json.dumps({
            "error": str(e),
            "success": False
        }))

