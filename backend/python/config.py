"""Configuration management using environment variables."""
import os
from pathlib import Path
from dotenv import load_dotenv

# Get the directory where this config file is located
CONFIG_DIR = Path(__file__).parent

# Load .env file from the same directory as this config file
env_path = CONFIG_DIR / ".env"
load_dotenv(dotenv_path=env_path)

# API Keys
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY")

# Google Cloud service account credentials
# If GOOGLE_APPLICATION_CREDENTIALS is not set, try to use service-account-key.json in the same directory
if not os.getenv("GOOGLE_APPLICATION_CREDENTIALS"):
    service_account_path = CONFIG_DIR / "service-account-key.json"
    if service_account_path.exists():
        os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = str(service_account_path)

# Server configuration
HOST = os.getenv("HOST", "0.0.0.0")
PORT = int(os.getenv("PORT", "8000"))
DEBUG = os.getenv("DEBUG", "false").lower() == "true"

