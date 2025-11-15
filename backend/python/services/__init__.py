"""TTS service implementations."""
from .gemini import synthesize as synthesize_gemini
from .openai import synthesize as synthesize_openai

__all__ = ["synthesize_gemini", "synthesize_openai"]

