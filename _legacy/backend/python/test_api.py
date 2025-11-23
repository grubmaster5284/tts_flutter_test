"""Simple test script for the TTS API."""
import asyncio
import json
import httpx


async def test_synthesize(service: str = "gemini"):
    """Test synthesize endpoint."""
    payload = {
        "text": "Hello, this is a test!",
        "service": service,
        "voice": "Kore" if service == "gemini" else "alloy",
        "audio_format": "mp3",
    }
    
    if service == "gemini":
        payload["prompt"] = "Say this in a friendly tone."
    
    async with httpx.AsyncClient(timeout=60.0) as client:
        response = await client.post(
            "http://localhost:8000/api/v1/tts/synthesize",
            json=payload
        )
        print(f"\n{service.upper()} TTS: {response.status_code}")
        
        if response.status_code == 200:
            data = response.json()
            print(f"✓ Audio format: {data['audio_format']}")
            print(f"✓ Duration: {data['duration_ms']}ms")
            print(f"✓ Audio data: {len(data['audio_data'])} chars")
        else:
            print(f"✗ Error: {response.text}")


async def main():
    """Run tests."""
    print("Testing TTS Backend\n" + "=" * 40)
    
    # Test health
    async with httpx.AsyncClient() as client:
        resp = await client.get("http://localhost:8000/health")
        print(f"Health: {resp.status_code} - {resp.json()}")
    
    # Test services
    await test_synthesize("gemini")
    await test_synthesize("openai")
    
    print("\n" + "=" * 40)


if __name__ == "__main__":
    asyncio.run(main())
