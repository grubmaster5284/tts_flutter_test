#!/usr/bin/env python3
"""Standalone OpenAI TTS script - called from Flutter via platform channels."""
import sys
import json
import base64
import os
from pathlib import Path
from typing import Literal, cast

# Add parent directory to path to import config
# Try multiple paths to find config
config_paths = [
    Path(__file__).parent.parent / "backend" / "python",
    Path(__file__).parent.parent.parent / "backend" / "python",
    Path(__file__).parent / ".." / "backend" / "python",
]

for config_path in config_paths:
    if (config_path / "config.py").exists():
        sys.path.insert(0, str(config_path))
        break

try:
    from config import OPENAI_API_KEY
except ImportError:
    # Fallback: try to get from environment
    import os
    OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

from openai import OpenAI

# Type aliases for OpenAI API
OpenAIVoice = Literal["alloy", "echo", "fable", "onyx", "nova", "shimmer"]
OpenAIAudioFormat = Literal["mp3", "opus", "aac", "flac", "wav", "pcm"]


def synthesize(text: str, voice: str = "alloy", language: str = None,
               audio_format: str = "mp3", speed: float = 1.0, instructions: str = None) -> dict:
    """Synthesize speech using OpenAI TTS."""
    if not OPENAI_API_KEY:
        return {
            "error": "OpenAI TTS not configured. Set OPENAI_API_KEY in .env",
            "success": False
        }
    
    client = OpenAI(api_key=OPENAI_API_KEY)
    
    # Validate and cast voice
    valid_voices: list[OpenAIVoice] = ["alloy", "echo", "fable", "onyx", "nova", "shimmer"]
    if voice not in valid_voices:
        return {
            "error": f"Invalid voice. Must be one of: {', '.join(valid_voices)}",
            "success": False
        }
    voice_literal = cast(OpenAIVoice, voice)
    
    # Validate and cast audio format
    valid_formats: list[OpenAIAudioFormat] = ["mp3", "opus", "aac", "flac", "wav", "pcm"]
    if audio_format not in valid_formats:
        return {
            "error": f"Invalid audio format. Must be one of: {', '.join(valid_formats)}",
            "success": False
        }
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
            "success": True
        }
    except Exception as e:
        return {
            "error": f"OpenAI API error: {str(e)}",
            "success": False
        }


if __name__ == "__main__":
    # Read JSON input from stdin
    try:
        input_data = json.loads(sys.stdin.read())
        
        result = synthesize(
            text=input_data.get("text", ""),
            voice=input_data.get("voice", "alloy"),
            language=input_data.get("language"),
            audio_format=input_data.get("audio_format", "mp3"),
            speed=input_data.get("speed", 1.0),
            instructions=input_data.get("instructions")
        )
        
        # Output JSON result to stdout
        print(json.dumps(result))
    except Exception as e:
        print(json.dumps({
            "error": str(e),
            "success": False
        }))

