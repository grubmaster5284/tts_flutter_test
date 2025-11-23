# TTS Flutter App Architecture Plan

## Architecture Overview

This plan implements a clean architecture with clear separation of concerns:

- **Presentation Layer**: Flutter UI (Dart)
- **Domain Layer**: Business logic and interfaces (Dart)
- **Data Layer**: TTS service implementations and API clients (Pure Dart - no Python dependency)

## Refactoring Strategy: Python to Dart Migration

**Current State (Legacy - Isolated)**: Python scripts and backend are moved to `_legacy/` directory for rollback capability.

**New State**: Pure Dart/Flutter implementation with modular TTS services that make direct HTTP calls to TTS APIs.

**Code Preservation Approach**:
- **Python Backend**: Moved to `_legacy/backend/` and `_legacy/scripts/` (not deleted, isolated from project)
- **Flutter Code**: Old code is commented out with `// [LEGACY]` markers, new code added alongside
- **Platform Channels**: macOS AppDelegate Python execution code is commented out, not deleted
- This allows easy rollback if needed

## Project Structure

```
tts_flutter_test/
├── _legacy/                    # [ISOLATED] Legacy Python backend (not used, kept for rollback)
│   ├── backend/
│   │   └── python/            # Old Python FastAPI server
│   └── scripts/                # Old Python TTS scripts
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
│       │       │   ├── speech_synthesis_local_service.dart
│       │       │   └── speech_synthesis_script_service.dart  # [LEGACY] Commented out
│       │       └── remote/
│       │           ├── speech_synthesis_remote_service.dart  # [LEGACY] Commented out (old HTTP backend)
│       │           ├── gemini_tts_remote_service.dart        # [NEW] Gemini TTS API client
│       │           ├── openai_tts_remote_service.dart        # [NEW] OpenAI TTS API client
│       │           ├── polly_tts_remote_service.dart         # [NEW] AWS Polly TTS (future)
│       │           └── tts_service_factory.dart             # [NEW] Service factory
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

### 1. Legacy Python Backend (Isolated - Not Used)

**Status**: Moved to `_legacy/backend/` and `_legacy/scripts/` directories. Code is preserved but not used by the application. This allows for rollback if needed.

**What Was Moved**:
- `backend/python/` → `_legacy/backend/python/`
- `scripts/` → `_legacy/scripts/`
- Python execution code in `macos/Runner/AppDelegate.swift` is commented out with `// [LEGACY]` markers

**Why Preserved**: 
- Reference implementation for API integration patterns
- Rollback capability if Dart implementation has issues
- Documentation of previous architecture

### 2. New Pure Dart TTS Services Architecture

**Service Structure** (Following Data Layer Conventions):
- All TTS services are in `lib/speech_synthesis/data/sources/remote/`
- Services follow naming convention: `{service}_tts_remote_service.dart`
- Each service is a concrete implementation (no abstract interface needed per conventions)
- Services return `Result<SpeechResponseDto, SpeechSynthesisError>`

**Service Implementations**:
- **GeminiTtsRemoteService** (`gemini_tts_remote_service.dart`):
  - Direct HTTP calls to Google Cloud Text-to-Speech API
  - OAuth2 authentication (service account key or Application Default Credentials)
  - Handles Google Cloud API-specific error responses
  - Maps API errors to domain `SpeechSynthesisError`
  - Returns `Result<SpeechResponseDto, SpeechSynthesisError>`
- **OpenAITtsRemoteService** (`openai_tts_remote_service.dart`):
  - Direct HTTP calls to OpenAI TTS API
  - API key authentication
  - Handles OpenAI API-specific error responses
  - Maps API errors to domain `SpeechSynthesisError`
  - Returns `Result<SpeechResponseDto, SpeechSynthesisError>`
- **PollyTtsRemoteService** (`polly_tts_remote_service.dart`):
  - Future implementation for AWS Polly
  - AWS SDK authentication
  - Maps API errors to domain `SpeechSynthesisError`

**Service Factory** (`tts_service_factory.dart`):
- Creates appropriate service instance based on service type
- Returns the correct `*TtsRemoteService` instance
- Centralized service instantiation
- Easy to add new services
- Located in `sources/remote/` folder

### 3. Flutter Architecture (Dart)

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
  - `SpeechSynthesisRepositoryImpl`: implements `ISpeechSynthesisRepository` interface
    - **NEW**: Uses Dart TTS remote services directly (no platform channels or Python)
    - **LEGACY**: Old `SpeechSynthesisScriptService` code is commented out
    - **LEGACY**: Old `SpeechSynthesisRemoteService` code is commented out
    - Converts DTO → Domain models
    - Maps data errors → domain errors
    - Returns `Result<SpeechResponseModel, SpeechSynthesisError>`
  - `SpeechSynthesisLocalService`: Local storage service for caching (unchanged)
    - Located in `sources/local/`
    - Handles SharedPreferences caching
  - **NEW**: `GeminiTtsRemoteService`, `OpenAITtsRemoteService`, `PollyTtsRemoteService`: Pure Dart HTTP clients
    - Located in `sources/remote/`
    - Follow naming convention: `{service}_tts_remote_service.dart`
    - Return `Result<SpeechResponseDto, SpeechSynthesisError>`
    - Handle raw data access only, no business logic
  - **NEW**: `TtsServiceFactory`: Creates appropriate service instance
    - Located in `sources/remote/`
    - Factory method returns correct `*TtsRemoteService` instance
  - Uses `http` or `dio` package for API calls
  - DTOs (`SpeechRequestDto`, `SpeechResponseDto`) with `toDomain()` conversion (unchanged)
    - Located in `dtos/` folder
    - Must be immutable with `@freezed`
    - Provide `fromJson`, `toJson`, and `toDomain()` methods
  - Error handling and response parsing
  - API constants in `speech_synthesis_api_keys.dart` (located in `constants/` folder)

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

### 4. Code Preservation Strategy

**Python Backend Isolation**:
- Move `backend/python/` → `_legacy/backend/python/`
- Move `scripts/` → `_legacy/scripts/`
- Add `_legacy/README.md` explaining the legacy code structure
- Update `.gitignore` if needed (but keep legacy code in repo for rollback)

**Flutter Code Commenting**:
- Comment out old code with `// [LEGACY]` marker at start of section
- Add `// [NEW]` marker for new code
- Keep old code structure intact (don't delete imports, classes, methods)
- Example:
  ```dart
  // [LEGACY] Old script service - commented out for rollback
  // class SpeechSynthesisScriptService {
  //   ... old code ...
  // }
  
  // [NEW] Pure Dart TTS service
  class GeminiTtsService implements ITtsService {
    ... new code ...
  }
  ```

**Platform Code (macOS AppDelegate)**:
- Comment out Python execution methods with `// [LEGACY]` markers
- Keep the code structure for reference
- Add comments explaining the migration

### 5. SOLID Principles Application

- **Single Responsibility**: Each service class handles one TTS provider
- **Open/Closed**: Add new services by extending base class, no modification needed
- **Liskov Substitution**: All services are interchangeable via base interface
- **Interface Segregation**: Minimal interface with only required methods
- **Dependency Inversion**: Flutter depends on repository interface, not concrete implementations

### 6. Modularity Features

- **Service Factory Pattern**: Backend uses factory to create service instances
- **Strategy Pattern**: Flutter can switch services at runtime
- **Configuration**: Service credentials stored in environment variables or config files
- **Error Handling**: Standardized error responses across all services

## Key Files to Create/Modify

### Legacy Code Isolation (Preserve, Don't Delete)
1. **Move** `backend/python/` → `_legacy/backend/python/` (entire directory)
2. **Move** `scripts/` → `_legacy/scripts/` (entire directory)
3. **Comment out** Python execution code in `macos/Runner/AppDelegate.swift`:
   - `executeTTSScript()` method - comment with `// [LEGACY]`
   - `findPythonExecutable()` method - comment with `// [LEGACY]`
   - Keep code structure for reference

### New Dart TTS Services (Pure Flutter Implementation)
1. `lib/speech_synthesis/data/sources/remote/gemini_tts_remote_service.dart` - Gemini TTS API client
2. `lib/speech_synthesis/data/sources/remote/openai_tts_remote_service.dart` - OpenAI TTS API client
3. `lib/speech_synthesis/data/sources/remote/polly_tts_remote_service.dart` - AWS Polly TTS (future)
4. `lib/speech_synthesis/data/sources/remote/tts_service_factory.dart` - Service factory

### Flutter Code Updates (Comment Old, Add New)
6. `lib/speech_synthesis/data/sources/local/speech_synthesis_script_service.dart`:
   - **Comment out** entire class with `// [LEGACY]` markers
   - Keep file structure for rollback reference
7. `lib/speech_synthesis/data/sources/remote/speech_synthesis_remote_service.dart`:
   - **Comment out** entire class with `// [LEGACY]` markers (if not needed)
   - Keep file structure for rollback reference
8. `lib/speech_synthesis/data/repositories/speech_synthesis_repository_impl.dart`:
   - **Comment out** old script service usage
   - **Add** new Dart TTS service usage via factory
   - Keep old code commented for rollback

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

**Legacy Python Backend** (Isolated in `_legacy/`, not used):
- fastapi
- uvicorn
- google-generativeai (Gemini)
- openai
- boto3 (Amazon Polly)
- pydantic

**Flutter** (New Implementation):

- **Domain Layer**:
  - `freezed_annotation`: ^2.4.1 - For sealed classes and unions
  - `result_type`: ^1.0.0 - For Result pattern (success/failure)
  - `freezed`: ^2.4.7 (dev) - Code generation for Freezed
  - `build_runner`: ^2.4.8 (dev) - Code generation tool
- **Data Layer**:
  - `http` or `dio` - HTTP client for API calls (for direct TTS API integration)
  - `googleapis` or `googleapis_auth` (optional) - For Google Cloud OAuth2 authentication
  - `crypto` - For OAuth2 token generation if needed
- **Application Layer**:
  - flutter_riverpod - State management and dependency injection
- **Presentation Layer**:
  - audioplayers or just_audio - Audio playback
  - shared_preferences - Settings persistence

## Conventions Compliance

This plan follows the project's clean architecture conventions:

### **Data Layer Conventions**
- ✅ Services in `sources/remote/` for HTTP/API calls
- ✅ Services in `sources/local/` for cache/SharedPreferences
- ✅ Service naming: `{service}_tts_remote_service.dart` or `{service}_local_service.dart`
- ✅ DTOs in `dtos/` folder with `_dto.dart` suffix
- ✅ DTOs must be immutable with `@freezed`
- ✅ DTOs must provide `fromJson`, `toJson`, and `toDomain()` methods
- ✅ Repository implementations in `repositories/` with `_repository_impl.dart` suffix
- ✅ API constants in `constants/` folder with `_api_keys.dart` suffix
- ✅ Services return `Result<T, E>` for all fallible operations
- ✅ Services handle raw data access only, no business logic
- ✅ Repository converts DTO → Domain and maps data errors → domain errors

### **Domain Layer Conventions**
- ✅ Entities in `entities/` folder with `_model.dart` suffix
- ✅ Value objects in `value_objects/` folder with `_vo.dart` suffix (optional)
- ✅ Repository interfaces in `repositories/` with `i_` prefix and `_repository.dart` suffix
- ✅ Errors in `errors/` folder with `_error.dart` suffix
- ✅ Use cases in `use_cases/` folder with `_use_case.dart` suffix (optional)
- ✅ Models must be immutable with `@freezed`
- ✅ Repository interfaces return `Result<T, E>`

### **Application Layer Conventions**
- ✅ State classes in `state/` folder with `_state.dart` suffix
- ✅ Notifiers in `state/` folder with `_notifier.dart` suffix
- ✅ Providers in `providers/` folder with `_providers.dart` suffix
- ✅ State must be immutable with `@freezed`
- ✅ State uses `DataState<T>` for loading/success/failure states
- ✅ Notifiers extend `StateNotifier<FeatureState>` or `AsyncNotifier<FeatureState>`

### **Presentation Layer Conventions**
- ✅ Pages in `pages/` folder with `_page.dart` suffix
- ✅ Widgets in `widgets/` folder with `_widget.dart` suffix
- ✅ UI-only providers in `controllers/` folder with `_ui_provider.dart` suffix (optional)
- ✅ Pages use `ConsumerWidget` or `ConsumerStatefulWidget`
- ✅ Use `ref.watch()` for state consumption
- ✅ Use `ref.read()` for triggering actions
- ✅ Use `KSizes` for all spacing and layout constants

## Refactoring Steps (Python to Dart Migration)

### Phase 1: Isolate Legacy Code (Preserve for Rollback)
1. **Move Python Backend**:
   - Create `_legacy/` directory
   - Move `backend/python/` → `_legacy/backend/python/`
   - Move `scripts/` → `_legacy/scripts/`
   - Add `_legacy/README.md` explaining legacy structure

2. **Comment Out Platform Code**:
   - In `macos/Runner/AppDelegate.swift`:
     - Comment out `executeTTTScript()` method with `// [LEGACY]` markers
     - Comment out `findPythonExecutable()` method with `// [LEGACY]` markers
     - Keep code structure intact for reference

3. **Comment Out Flutter Legacy Services**:
   - In `lib/speech_synthesis/data/sources/local/speech_synthesis_script_service.dart`:
     - Comment out entire class with `// [LEGACY]` markers
     - Keep file and class structure for rollback
   - In `lib/speech_synthesis/data/sources/remote/speech_synthesis_remote_service.dart`:
     - Comment out if not needed, or keep if web platform still uses it

### Phase 2: Create New Dart TTS Services
4. **Implement Gemini Remote Service**:
   - `lib/speech_synthesis/data/sources/remote/gemini_tts_remote_service.dart`
   - HTTP client for Google Cloud TTS API
   - OAuth2 authentication handling
   - Error mapping to domain `SpeechSynthesisError`
   - Returns `Result<SpeechResponseDto, SpeechSynthesisError>`
   - Follows data layer conventions: raw data access only, no business logic

5. **Implement OpenAI Remote Service**:
   - `lib/speech_synthesis/data/sources/remote/openai_tts_remote_service.dart`
   - HTTP client for OpenAI TTS API
   - API key authentication
   - Error mapping to domain `SpeechSynthesisError`
   - Returns `Result<SpeechResponseDto, SpeechSynthesisError>`
   - Follows data layer conventions: raw data access only, no business logic

6. **Create Service Factory**:
   - `lib/speech_synthesis/data/sources/remote/tts_service_factory.dart`
   - Factory method to create service instances based on service type
   - Returns appropriate `*TtsRemoteService` instance

### Phase 3: Update Repository
8. **Update Repository Implementation**:
   - In `lib/speech_synthesis/data/repositories/speech_synthesis_repository_impl.dart`:
     - Comment out old script service usage with `// [LEGACY]` markers
     - Add new Dart TTS service usage via factory
     - Keep old code commented for rollback reference
   - Remove platform-specific logic (no more `kIsWeb` check for script vs remote)
   - All platforms use same Dart services

### Phase 4: Update Configuration
9. **Update API Key Management**:
   - Move API keys to Dart constants or environment variables
   - Handle Google Cloud service account key file reading in Dart
   - Update `speech_synthesis_api_keys.dart` if needed

### Phase 5: Update Dependencies
10. **Update pubspec.yaml**:
    - Add `http` or `dio` package if not already present
    - Add `googleapis` or `googleapis_auth` for Google Cloud auth (if needed)
    - Remove any Python-related dependencies (if any)

### Phase 6: Testing & Validation
11. **Test Each Service**:
    - Test Gemini service with real API calls
    - Test OpenAI service with real API calls
    - Verify error handling works correctly
    - Verify audio playback still works with new services

12. **Rollback Plan**:
    - If issues arise, uncomment legacy code
    - Move `_legacy/backend/python/` back to `backend/python/`
    - Move `_legacy/scripts/` back to `scripts/`
    - Uncomment platform channel code in AppDelegate

## Architecture Flow (After Refactoring)

```
User selects service (Gemini/OpenAI)
    ↓
Presentation Layer (speech_synthesis_page.dart)
    ↓
Application Layer (SpeechSynthesisNotifier)
    ↓
Domain Layer (ISpeechSynthesisRepository interface)
    ↓
Data Layer (SpeechSynthesisRepositoryImpl)
    ↓
TTS Service Factory (creates appropriate service)
    ↓
GeminiTtsRemoteService / OpenAITtsRemoteService (Pure Dart HTTP client)
    ↓
Direct HTTP call to TTS provider API
    ↓
Returns Result<SpeechResponseDto, SpeechSynthesisError>
    ↓
Repository converts DTO → Domain (SpeechResponseModel)
    ↓
Repository saves audio to file
    ↓
Returns Result<SpeechResponseModel, SpeechSynthesisError>
    ↓
Application Layer updates state
    ↓
Presentation Layer displays result
    ↓
Audio Player (existing, no changes)
```

## Benefits of Pure Dart Implementation

- ✅ **No Python Dependency**: Pure Flutter/Dart codebase
- ✅ **Cross-Platform**: Works on all Flutter platforms (iOS, Android, Web, Desktop)
- ✅ **Easier Maintenance**: Single codebase, no process spawning
- ✅ **Better Performance**: Direct HTTP calls, no subprocess overhead
- ✅ **Easier Testing**: Pure Dart unit tests, no platform channel mocking needed
- ✅ **Simpler Deployment**: No Python installation required
- ✅ **Rollback Capability**: Legacy code preserved for easy rollback if needed
- ✅ **Follows Clean Architecture**: Proper layer separation with conventions
- ✅ **Consistent Naming**: Follows project naming conventions (`_remote_service.dart`, `_dto.dart`, etc.)
- ✅ **Type Safety**: Uses `Result<T, E>` pattern for error handling
- ✅ **Testable**: Services can be easily mocked for repository tests