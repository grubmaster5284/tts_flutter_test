# TTS Flutter App Architecture Plan

## Architecture Overview

This plan implements a clean architecture with clear separation of concerns:

- **Presentation Layer**: Flutter UI (Dart)
- **Domain Layer**: Business logic and interfaces (Dart)
- **Data Layer**: TTS service implementations and API clients (Python backend + Dart adapters)

## Project Structure

```
tts_flutter_test/
├── backend/
│   ├── python/
│   │   ├── main.py          # FastAPI server
│   │   ├── config.py        # Configuration and environment variables
│   │   ├── models/
│   │   │   ├── request.py   # Request models
│   │   │   └── response.py  # Response models
│   │   ├── services/
│   │   │   ├── base.py      # Base TTS service interface
│   │   │   ├── gemini.py    # Gemini TTS implementation
│   │   │   ├── openai.py    # OpenAI TTS implementation
│   │   │   └── polly.py     # Amazon Polly implementation
│   │   ├── utils/
│   │   │   └── errors.py    # Error handling utilities
│   │   └── requirements.txt
│   └── README.md
├── lib/
│   ├── audio_playback/
│   │   ├── application/
│   │   │   ├── providers/
│   │   │   │   └── audio_playback_providers.dart
│   │   │   └── state/
│   │   │       ├── audio_playback_notifier.dart
│   │   │       └── audio_playback_state.dart
│   │   └── presentation/
│   │       └── widgets/
│   │           └── audio_player_widget.dart
│   ├── core/
│   │   ├── constants/
│   │   │   └── k_sizes.dart
│   │   ├── di/
│   │   │   └── core_providers.dart
│   │   ├── errors/
│   │   │   └── app_error.dart
│   │   └── utils/
│   │       └── logger.dart
│   ├── main.dart
│   ├── settings/
│   │   ├── application/
│   │   │   ├── providers/
│   │   │   │   └── settings_providers.dart
│   │   │   └── state/
│   │   │       ├── settings_notifier.dart
│   │   │       └── settings_state.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── settings_page.dart
│   │       └── widgets/
│   │           └── settings_widget.dart
│   └── speech_synthesis/
│       ├── application/
│       │   ├── providers/
│       │   │   └── speech_synthesis_providers.dart
│       │   └── state/
│       │       ├── speech_synthesis_notifier.dart
│       │       └── speech_synthesis_state.dart
│       ├── data/
│       │   ├── constants/
│       │   │   └── speech_synthesis_api_keys.dart
│       │   ├── dtos/
│       │   │   ├── speech_request_dto.dart
│       │   │   └── speech_response_dto.dart
│       │   ├── repositories/
│       │   │   └── speech_synthesis_repository_impl.dart
│       │   └── sources/
│       │       ├── local/
│       │       │   └── speech_synthesis_local_service.dart
│       │       └── remote/
│       │           └── speech_synthesis_remote_service.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── speech_request_model.dart
│       │   │   ├── speech_response_model.dart
│       │   │   └── tts_service_model.dart
│       │   ├── errors/
│       │   │   └── speech_synthesis_error.dart
│       │   ├── repositories/
│       │   │   └── i_speech_synthesis_repository.dart
│       │   ├── use_cases/
│       │   │   └── convert_text_to_speech_use_case.dart
│       │   └── value_objects/
│       │       ├── audio_format_vo.dart
│       │       ├── language_vo.dart
│       │       ├── text_vo.dart
│       │       └── voice_vo.dart
│       └── presentation/
│           ├── controllers/
│           │   └── speech_synthesis_ui_provider.dart
│           ├── pages/
│           │   └── speech_synthesis_page.dart
│           └── widgets/
│               ├── language_selector_widget.dart
│               ├── loading_indicator_widget.dart
│               ├── service_selector_widget.dart
│               ├── text_input_field_widget.dart
│               └── voice_selector_widget.dart
└── pubspec.yaml
```

## Implementation Strategy

### 1. Backend Architecture (Python)

**Configuration** (`backend/python/config.py`):
- Environment variable management
- API keys and service configuration
- Settings validation

**Models** (`backend/python/models/`):
- `request.py`: Pydantic models for request validation (TTSRequest)
- `response.py`: Pydantic models for response formatting (TTSResponse, ErrorResponse)

**Base Service Interface** (`backend/python/services/base.py`):
- Abstract base class defining `synthesize_speech(text, voice, language)` method
- All TTS services inherit from this base class
- Returns standardized response format

**Service Implementations**:
- Each service (Gemini, OpenAI, Polly) in separate files
- Each implements the base interface
- Handles service-specific authentication and API calls
- Error handling and retry logic

**Error Handling** (`backend/python/utils/errors.py`):
- Custom exception classes
- Error response formatting
- Error logging utilities

**FastAPI Server** (`backend/python/main.py`):
- REST API endpoint: `POST /api/v1/tts/synthesize`
- Request validation using Pydantic models
- Service factory to instantiate correct service based on request
- Error handling middleware
- Returns audio file (base64 encoded) with metadata

### 2. Flutter Architecture (Dart)

**Speech Synthesis Feature**:

- **Domain Layer**:
  - `TTSServiceModel` enum/model: gemini, openai, polly
  - `SpeechRequestModel` entity: uses value objects (TextVO, VoiceVO?, LanguageVO?)
  - `SpeechResponseModel` entity: uses AudioFormatVO value object
  - **Value Objects**:
    - `TextVO`: Validates text input (1-5000 characters)
    - `VoiceVO`: Validates voice identifiers
    - `LanguageVO`: Validates language codes (ISO 639-1 format)
    - `AudioFormatVO`: Validates audio formats (mp3, wav, ogg, aac, flac)
  - **Error Handling**:
    - `SpeechSynthesisError`: Sealed class with Freezed for type-safe error handling
    - Implements Exception for compatibility with Result pattern
    - Includes validation, network, auth, and service errors
    - Extension class with helper methods (isNetworkError, isAuthError, isRetryable, userMessage)
  - `ISpeechSynthesisRepository` interface: abstract repository with Result<SpeechResponseModel, SpeechSynthesisError> return type
  - `ConvertTextToSpeechUseCase`: encapsulates business logic with Result pattern

- **Data Layer**:
  - `SpeechSynthesisRepositoryImpl`: implements repository interface
  - `SpeechSynthesisRemoteService`: HTTP client service to call Python backend
  - `SpeechSynthesisLocalService`: Local storage service for caching
  - Uses `http` or `dio` package for API calls
  - DTOs (`SpeechRequestDto`, `SpeechResponseDto`) with `toDomain()` conversion
  - Error handling and response parsing
  - API constants in `speech_synthesis_api_keys.dart`

- **Application Layer**:
  - `SpeechSynthesisState`: Immutable state class with Freezed
  - `SpeechSynthesisNotifier`: StateNotifier or AsyncNotifier for state management
  - `SpeechSynthesisProviders`: Riverpod providers for DI and state access
  - Handles loading, success, and error states

- **Presentation Layer**:
  - Service selection UI (dropdown/segmented control)
  - Text input field
  - Voice/language selection
  - Uses Riverpod for state management via `ref.watch()` and `ref.read()`
  - Optional UI-only state in `controllers/` folder

**Audio Playback Feature**:

- **Application Layer**:
  - `AudioPlaybackState`: Immutable state class with Freezed
  - `AudioPlaybackNotifier`: StateNotifier for playback state management
  - `AudioPlaybackProviders`: Riverpod providers for DI and state access
  - Uses `audioplayers` or `just_audio` package directly for playback

- **Presentation Layer**:
  - Audio player widget with play/pause/stop controls
  - Progress indicator and time display

**Settings Feature**:

- **Application Layer**:
  - `SettingsState`: Immutable state class with Freezed
  - `SettingsNotifier`: StateNotifier for settings state management
  - `SettingsProviders`: Riverpod providers for DI and state access
  - Uses `shared_preferences` package directly for persistence

- **Presentation Layer**:
  - Settings page with various configuration options
  - Settings widgets for individual setting controls

**Dependency Injection**:

- Riverpod providers in `core_providers.dart` and feature-specific provider files
- Register repositories, use cases, and services via providers
- Easy to swap implementations for testing by overriding providers

### 3. SOLID Principles Application

- **Single Responsibility**: Each service class handles one TTS provider
- **Open/Closed**: Add new services by extending base class, no modification needed
- **Liskov Substitution**: All services are interchangeable via base interface
- **Interface Segregation**: Minimal interface with only required methods
- **Dependency Inversion**: Flutter depends on repository interface, not concrete implementations

### 4. Modularity Features

- **Service Factory Pattern**: Backend uses factory to create service instances
- **Strategy Pattern**: Flutter can switch services at runtime
- **Configuration**: Service credentials stored in environment variables or config files
- **Error Handling**: Standardized error responses across all services

## Key Files to Create/Modify

### Backend (Python)
1. `backend/python/main.py` - FastAPI server with TTS endpoint
2. `backend/python/config.py` - Configuration and environment variables
3. `backend/python/models/request.py` - Request models (Pydantic)
4. `backend/python/models/response.py` - Response models (Pydantic)
5. `backend/python/services/base.py` - Base TTS service interface
6. `backend/python/services/gemini.py` - Gemini implementation
7. `backend/python/services/openai.py` - OpenAI implementation
8. `backend/python/services/polly.py` - Amazon Polly implementation
9. `backend/python/utils/errors.py` - Error handling utilities
10. `backend/python/requirements.txt` - Python dependencies

### Speech Synthesis Feature (Flutter)
11. `lib/speech_synthesis/domain/entities/tts_service_model.dart` - Service enum/model
12. `lib/speech_synthesis/domain/entities/speech_request_model.dart` - Request entity (uses value objects)
13. `lib/speech_synthesis/domain/entities/speech_response_model.dart` - Response entity (uses value objects)
14. `lib/speech_synthesis/domain/value_objects/text_vo.dart` - Text value object with validation
15. `lib/speech_synthesis/domain/value_objects/voice_vo.dart` - Voice value object with validation
16. `lib/speech_synthesis/domain/value_objects/language_vo.dart` - Language value object with validation
17. `lib/speech_synthesis/domain/value_objects/audio_format_vo.dart` - Audio format value object
18. `lib/speech_synthesis/domain/errors/speech_synthesis_error.dart` - Sealed error class with Freezed
19. `lib/speech_synthesis/domain/repositories/i_speech_synthesis_repository.dart` - Repository interface
20. `lib/speech_synthesis/domain/use_cases/convert_text_to_speech_use_case.dart` - Use case with Result pattern
21. `lib/speech_synthesis/data/repositories/speech_synthesis_repository_impl.dart` - Repository implementation
22. `lib/speech_synthesis/data/sources/remote/speech_synthesis_remote_service.dart` - HTTP client service
23. `lib/speech_synthesis/data/sources/local/speech_synthesis_local_service.dart` - Local storage service
24. `lib/speech_synthesis/data/dtos/speech_request_dto.dart` - Request DTO
25. `lib/speech_synthesis/data/dtos/speech_response_dto.dart` - Response DTO
26. `lib/speech_synthesis/data/constants/speech_synthesis_api_keys.dart` - API endpoint constants
27. `lib/speech_synthesis/application/state/speech_synthesis_state.dart` - State class with Freezed
28. `lib/speech_synthesis/application/state/speech_synthesis_notifier.dart` - StateNotifier or AsyncNotifier
29. `lib/speech_synthesis/application/providers/speech_synthesis_providers.dart` - Riverpod providers & DI
30. `lib/speech_synthesis/presentation/pages/speech_synthesis_page.dart` - Main UI page
31. `lib/speech_synthesis/presentation/widgets/service_selector_widget.dart` - Service selection widget
32. `lib/speech_synthesis/presentation/widgets/text_input_field_widget.dart` - Text input widget
33. `lib/speech_synthesis/presentation/widgets/voice_selector_widget.dart` - Voice selection widget
34. `lib/speech_synthesis/presentation/widgets/language_selector_widget.dart` - Language selection widget
35. `lib/speech_synthesis/presentation/widgets/loading_indicator_widget.dart` - Loading indicator widget
36. `lib/speech_synthesis/presentation/controllers/speech_synthesis_ui_provider.dart` - UI-only state provider (optional)

### Audio Playback Feature (Flutter)
37. `lib/audio_playback/application/state/audio_playback_state.dart` - State class with Freezed
38. `lib/audio_playback/application/state/audio_playback_notifier.dart` - StateNotifier
39. `lib/audio_playback/application/providers/audio_playback_providers.dart` - Riverpod providers & DI
40. `lib/audio_playback/presentation/widgets/audio_player_widget.dart` - Audio player widget

### Settings Feature (Flutter)
41. `lib/settings/application/state/settings_state.dart` - State class with Freezed
42. `lib/settings/application/state/settings_notifier.dart` - StateNotifier
43. `lib/settings/application/providers/settings_providers.dart` - Riverpod providers & DI
44. `lib/settings/presentation/pages/settings_page.dart` - Settings page
45. `lib/settings/presentation/widgets/settings_widget.dart` - Settings widget

### Core (Flutter)
46. `lib/core/di/core_providers.dart` - Core dependency injection setup
47. `lib/core/constants/k_sizes.dart` - Layout constants
48. `lib/core/utils/logger.dart` - Logging utility
49. `lib/core/errors/app_error.dart` - Core error types
50. `pubspec.yaml` - Add dependencies as needed

## Dependencies

**Python Backend**:

- fastapi
- uvicorn
- google-generativeai (Gemini)
- openai
- boto3 (Amazon Polly)
- pydantic

**Flutter**:

- **Domain Layer**:
  - `freezed_annotation`: ^2.4.1 - For sealed classes and unions
  - `result_type`: ^1.0.0 - For Result pattern (success/failure)
  - `freezed`: ^2.4.7 (dev) - Code generation for Freezed
  - `build_runner`: ^2.4.8 (dev) - Code generation tool
- **Data Layer**:
  - http or dio - HTTP client for API calls
- **Application Layer**:
  - flutter_riverpod - State management and dependency injection
- **Presentation Layer**:
  - audioplayers or just_audio - Audio playback
  - shared_preferences - Settings persistence

## Next Steps

1. Set up Python backend structure with FastAPI
2. Create configuration file for environment variables and API keys
3. Define Pydantic models for request/response validation
4. Implement base TTS service interface
5. Implement each TTS service provider (Gemini, OpenAI, Polly)
6. Add error handling utilities and middleware
7. Set up core layer (constants with `k_sizes.dart`, DI with `core_providers.dart`, logger, app errors)
8. **Speech Synthesis Feature**:
   - Create domain layer (entities with `_model.dart` suffix, repository interface with `i_` prefix, use cases in `use_cases/` folder)
   - Implement data layer (DTOs in `dtos/`, services in `sources/remote/` and `sources/local/`, repository implementation)
   - Create application layer (state with Freezed, notifier, Riverpod providers)
   - Build presentation layer (pages, widgets with `_widget.dart` suffix, optional UI controllers)
   - Add configuration management for API keys in `speech_synthesis_api_keys.dart`
9. **Audio Playback Feature**:
   - Create application layer (state with Freezed, notifier, Riverpod providers)
   - Build audio player widget using audioplayers/just_audio package
10. **Settings Feature**:
   - Create application layer (state with Freezed, notifier, Riverpod providers)
   - Use shared_preferences directly for persistence
   - Build settings page and widgets
11. Set up dependency injection with Riverpod providers for all features
12. Add error handling and loading states across all features
13. Write unit tests for each feature and layer