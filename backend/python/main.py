"""Simple TTS backend - calls Gemini or OpenAI TTS APIs."""
import sys
import os

# Add current directory to Python path to allow imports
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import Optional

from config import HOST, PORT, DEBUG
from services import synthesize_gemini, synthesize_openai

app = FastAPI(title="TTS Backend", version="1.0.0")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])


# Request/Response models
class TTSRequest(BaseModel):
    text: str = Field(..., min_length=1, max_length=5000)
    service: str = Field(..., pattern="^(gemini|openai)$")
    voice: Optional[str] = None
    language: Optional[str] = None
    audio_format: str = Field(default="mp3", pattern="^(mp3|wav|ogg|opus|aac|flac)$")
    prompt: Optional[str] = None  # For Gemini (style prompt)
    instructions: Optional[str] = None  # For OpenAI (tone/style instructions)
    speed: Optional[float] = Field(None, ge=0.25, le=4.0)  # For OpenAI


class TTSResponse(BaseModel):
    audio_data: str
    audio_format: str
    duration_ms: int
    metadata: Optional[str] = None


@app.get("/health")
async def health():
    return {"status": "ok"}


@app.post("/api/v1/tts/synthesize", response_model=TTSResponse)
async def synthesize(request: TTSRequest):
    """Synthesize speech using Gemini or OpenAI."""
    
    if request.service == "gemini":
        return await synthesize_gemini(
            text=request.text,
            voice=request.voice or "Kore",
            language=request.language or "en-US",
            audio_format=request.audio_format,
            prompt=request.prompt,
        )
    
    elif request.service == "openai":
        return await synthesize_openai(
            text=request.text,
            voice=request.voice or "alloy",
            language=request.language,
            audio_format=request.audio_format,
            speed=request.speed or 1.0,
            instructions=request.instructions,
        )
    
    else:
        raise HTTPException(400, f"Unknown service: {request.service}")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host=HOST, port=PORT, reload=DEBUG)
