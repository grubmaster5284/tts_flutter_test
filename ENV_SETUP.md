# Environment Variables Setup (.env file)

This project uses a `.env` file to store sensitive credentials like API keys and service account information. The `.env` file is gitignored for security.

## Quick Setup

1. **Copy the example file:**
   ```bash
   cp .env.example .env
   ```

2. **Edit `.env` and add your credentials:**
   - Open `.env` in your editor
   - Add your Google Cloud service account JSON
   - Add your OpenAI API key (if using OpenAI TTS)

3. **The app will automatically load the `.env` file on startup**

## Configuration Options

### Google Cloud TTS (Gemini)

You have two options for Google Cloud authentication:

#### Option 1: Full JSON in .env (Recommended)
Add the entire service account JSON to `.env`:
```env
GOOGLE_SERVICE_ACCOUNT_JSON={"type":"service_account","project_id":"your-project-id",...}
```

**To get minified JSON:**
```bash
cat lib/speech_synthesis/data/constants/service-account-key.json | jq -c .
```

#### Option 2: File Path
Point to a service account key file:
```env
GOOGLE_APPLICATION_CREDENTIALS=/path/to/your/service-account-key.json
```

### OpenAI TTS

Add your OpenAI API key:
```env
OPENAI_API_KEY=sk-your-openai-api-key-here
```

## Credential Priority Order

The app checks for credentials in this order:

1. **`.env` file** (loaded via `flutter_dotenv`)
   - `GOOGLE_SERVICE_ACCOUNT_JSON` - Full JSON content
   - `GOOGLE_APPLICATION_CREDENTIALS` - Path to key file
   - `OPENAI_API_KEY` - OpenAI API key

2. **Environment variables** (system-level)
   - `GOOGLE_APPLICATION_CREDENTIALS` - Path to key file
   - `OPENAI_API_KEY` - OpenAI API key

3. **Asset file** (if bundled in app)
   - `lib/speech_synthesis/data/constants/service-account-key.json`

4. **File system paths** (project root)
   - `service-account-key.json`
   - `.gcloud/service-account-key.json`

## Security Notes

⚠️ **Important Security Considerations:**

1. **Never commit `.env` to git** - It's already in `.gitignore`
2. **Use `.env.example` as a template** - This file can be committed (without real credentials)
3. **For production**, consider:
   - Using environment variables instead of `.env` file
   - Using a secure key management service
   - Restricting service account permissions

## File Structure

```
tts_flutter_test/
├── .env                    # Your actual credentials (gitignored)
├── .env.example            # Template file (safe to commit)
└── lib/
    └── speech_synthesis/
        └── data/
            └── constants/
                └── service-account-key.json  # Alternative location (also gitignored)
```

## Troubleshooting

### "Credentials not found" error

1. Check that `.env` file exists in project root
2. Verify the variable names match exactly:
   - `GOOGLE_SERVICE_ACCOUNT_JSON` (not `GOOGLE_SERVICE_ACCOUNT_KEY`)
   - `OPENAI_API_KEY` (not `OPENAI_KEY`)
3. Make sure JSON is on a single line (minified)
4. Restart the app after changing `.env`

### JSON parsing errors

- Ensure the JSON is properly escaped in `.env`
- Use `jq -c .` to minify your JSON before pasting
- Check that all quotes are properly escaped

### Environment variable not loading

- Make sure `flutter_dotenv` is properly initialized in `main.dart`
- Check that `.env` is listed in `pubspec.yaml` assets
- Restart the app completely (hot reload may not pick up .env changes)

## Example .env File

```env
# Google Cloud TTS Service Account
GOOGLE_SERVICE_ACCOUNT_JSON={"type":"service_account","project_id":"my-project","private_key":"-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n","client_email":"my-service@my-project.iam.gserviceaccount.com",...}

# OpenAI API Key
OPENAI_API_KEY=sk-proj-abc123...
```

