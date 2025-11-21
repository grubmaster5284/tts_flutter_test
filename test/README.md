# Testing Guide

This directory contains comprehensive tests for the TTS Flutter application following Clean Architecture principles.

## Test Structure

The test directory mirrors the `lib/` directory structure:

```
test/
├── helpers/
│   └── test_helpers.dart          # Shared test utilities
├── speech_synthesis/
│   └── domain/
│       ├── value_objects/         # Value object tests
│       ├── entities/              # Entity tests
│       ├── errors/                # Error tests
│       └── use_cases/            # Use case tests
└── widget_test.dart               # Basic widget test
```

## Running Tests

### Run all tests
```bash
flutter test
```

### Run specific test file
```bash
flutter test test/speech_synthesis/domain/value_objects/language_vo_test.dart
```

### Run tests with coverage
```bash
flutter test --coverage
```

### Generate test coverage report
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Test Categories

### 1. Value Object Tests
Tests for domain value objects that ensure:
- Validation logic works correctly
- Invalid inputs are rejected
- Equality and hashCode are correct
- Immutability is maintained

**Files:**
- `language_vo_test.dart`
- `voice_vo_test.dart`
- `text_vo_test.dart`
- `audio_format_vo_test.dart`

### 2. Entity Tests
Tests for domain entities that ensure:
- Construction with required/optional fields
- `copyWith` methods work correctly
- Equality comparisons
- Immutability

**Files:**
- `speech_request_model_test.dart`
- `speech_response_model_test.dart`
- `tts_service_model_test.dart`

### 3. Error Tests
Tests for error handling that ensure:
- All error types can be created
- Extension methods work correctly
- User-friendly messages are generated

**Files:**
- `speech_synthesis_error_test.dart`

### 4. Use Case Tests
Tests for use cases that ensure:
- Success scenarios work correctly
- Failure scenarios are handled
- Repository interactions are correct

**Files:**
- `convert_text_to_speech_use_case_test.dart`

## Test Helpers

The `test/helpers/test_helpers.dart` file provides:
- `createTestContainer()` - Creates ProviderContainer for testing Riverpod providers
- `createTestWidget()` - Creates ProviderScope widget for widget tests
- `waitForAsync()` - Helper for async operations
- `TestDataFactory` - Factory for creating test data

## Best Practices

1. **Test Independence**: Each test should be independent and not rely on other tests
2. **Clear Naming**: Test names should clearly describe what is being tested
3. **Arrange-Act-Assert**: Follow the AAA pattern for test structure
4. **Mock External Dependencies**: Use Mockito to mock repositories and services
5. **Test Edge Cases**: Include tests for boundary conditions and error cases
6. **Group Related Tests**: Use `group()` to organize related tests

## Adding New Tests

When adding new features:

1. Create test files mirroring the source file structure
2. Name test files with `_test.dart` suffix
3. Use descriptive test names
4. Include both success and failure scenarios
5. Test edge cases and boundary conditions
6. Mock external dependencies

## Example Test Structure

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeatureName', () {
    group('methodName', () {
      test('should do something when condition', () {
        // Arrange
        final feature = FeatureName();
        
        // Act
        final result = feature.methodName();
        
        // Assert
        expect(result, expectedValue);
      });
    });
  });
}
```

## Continuous Integration

Tests should be run as part of CI/CD pipeline:
- All tests must pass before merging
- Coverage should be maintained above 80%
- No flaky tests should be committed

