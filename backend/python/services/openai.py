"""OpenAI TTS service."""
import base64
import json
from typing import Optional, Literal, cast
from fastapi import HTTPException
from openai import OpenAI
from config import OPENAI_API_KEY

# Type aliases for OpenAI API
OpenAIVoice = Literal["alloy", "echo", "fable", "onyx", "nova", "shimmer"]
OpenAIAudioFormat = Literal["mp3", "opus", "aac", "flac", "wav", "pcm"]


async def synthesize(text: str, voice: str = "alloy", language: Optional[str] = None,
                     audio_format: str = "mp3", speed: float = 1.0, instructions: Optional[str] = None) -> dict:
    """Synthesize speech using OpenAI TTS with streaming response."""
    if not OPENAI_API_KEY:
        raise HTTPException(503, "OpenAI TTS not configured. Set OPENAI_API_KEY in .env")
    
    client = OpenAI(api_key=OPENAI_API_KEY)
    
    # Validate and cast voice
    valid_voices: list[OpenAIVoice] = ["alloy", "echo", "fable", "onyx", "nova", "shimmer"]
    if voice not in valid_voices:
        raise HTTPException(400, f"Invalid voice. Must be one of: {', '.join(valid_voices)}")
    voice_literal = cast(OpenAIVoice, voice)
    
    # Validate and cast audio format
    valid_formats: list[OpenAIAudioFormat] = ["mp3", "opus", "aac", "flac", "wav", "pcm"]
    if audio_format not in valid_formats:
        raise HTTPException(400, f"Invalid audio format. Must be one of: {', '.join(valid_formats)}")
    format_literal = cast(OpenAIAudioFormat, audio_format)
    
    try:
        # Build request parameters
        request_params = {
            "model": "gpt-4o-mini-tts",
            "voice": voice_literal,
            "input": text,
            "response_format": format_literal,
            "speed": speed,
        }
        
        # Add instructions if provided
        if instructions:
            request_params["instructions"] = instructions
        
        # Use streaming response
        with client.audio.speech.with_streaming_response.create(**request_params) as response:
            # Collect all chunks into bytes
            audio_bytes = b""
            for chunk in response.iter_bytes():
                audio_bytes += chunk
        
        audio_base64 = base64.b64encode(audio_bytes).decode("utf-8")
        
        word_count = len(text.split())
        duration_ms = int((word_count / 150) * 60 * 1000)
        
        return {
            "audio_data": audio_base64,
            "audio_format": audio_format,
            "duration_ms": duration_ms,
            "metadata": json.dumps({"service": "openai", "voice": voice, "instructions": instructions}),
        }
    except Exception as e:
        raise HTTPException(500, f"OpenAI API error: {str(e)}")

