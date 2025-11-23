// [NEW] Pure Dart Gemini TTS service - direct HTTP calls to Google Cloud TTS API
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:result_type/result_type.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_request_dto.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_response_dto.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';
import 'package:tts_flutter_test/core/utils/logger.dart';
import 'package:path/path.dart' as path;
import 'package:jose/jose.dart';

/// Pure Dart service for Google Cloud Text-to-Speech API (Gemini model)
/// 
/// This service makes direct HTTP calls to Google Cloud TTS API without requiring
/// a Python backend. It handles OAuth2 authentication using service account keys,
/// following the same pattern as the Python implementation.
/// 
/// ## Architecture:
/// - **Direct API Calls**: Makes HTTP POST requests to `https://texttospeech.googleapis.com/v1/text:synthesize`
/// - **OAuth2 Authentication**: Uses service account key files for authentication (same as Python)
/// - **Error Handling**: Maps Google Cloud API errors to domain errors
/// 
/// ## Authentication:
/// The service looks for service account key files in these locations (same as Python):
/// 1. `GOOGLE_APPLICATION_CREDENTIALS` environment variable
/// 2. `service-account-key.json` in project root
/// 3. `.gcloud/service-account-key.json` in project root
/// 
/// ## API Endpoint:
/// - URL: `https://texttospeech.googleapis.com/v1/text:synthesize`
/// - Method: POST
/// - Authentication: Bearer token (OAuth2)
/// 
/// This is part of the Data layer and follows data layer conventions:
/// - Returns `Result<SpeechResponseDto, SpeechSynthesisError>`
/// - Handles raw data access only, no business logic
/// - Maps API errors to domain errors
class GeminiTtsRemoteService {
  /// HTTP client for making API requests
  final http.Client _client;
  
  /// Request timeout duration (30 seconds)
  static const Duration _timeout = Duration(seconds: 30);
  
  /// Google Cloud TTS API endpoint
  static const String _apiUrl = 'https://texttospeech.googleapis.com/v1/text:synthesize';
  
  /// OAuth2 scopes required for Text-to-Speech API
  static const List<String> _scopes = ['https://www.googleapis.com/auth/cloud-platform'];
  
  /// OAuth2 token endpoint
  static const String _tokenUrl = 'https://oauth2.googleapis.com/token';
  
  /// Cache for credentials (similar to Python implementation)
  Map<String, dynamic>? _cachedCredentials;
  String? _credentialsError;
  
  /// Constructor that initializes the service with an HTTP client
  /// 
  /// **Dependency Injection**: HTTP client is injected via constructor,
  /// making the service testable (can inject mock client).
  GeminiTtsRemoteService(this._client);
  
  /// Synthesizes speech from text using Google Cloud TTS API
  /// 
  /// **Process:**
  /// 1. Gets OAuth2 access token from service account key
  /// 2. Makes HTTP POST request to Google Cloud TTS API
  /// 3. Parses response JSON to DTO
  /// 4. Handles errors (network, authentication, API errors)
  /// 
  /// **Parameters:**
  /// - `request`: SpeechRequestDto containing text, voice, language, etc.
  /// 
  /// **Returns:**
  /// - `Result.success(SpeechResponseDto)`: On successful synthesis
  /// - `Result.failure(SpeechSynthesisError)`: On error
  Future<Result<SpeechResponseDto, SpeechSynthesisError>> synthesizeSpeech(
    SpeechRequestDto request,
  ) async {
    AppLogger.info('Synthesizing speech with Gemini TTS', tag: 'GeminiTtsService', data: {
      'textLength': request.text.length,
      'voice': request.voice,
      'language': request.language,
      'audioFormat': request.audioFormat,
    });
    
    try {
      // Step 1: Get OAuth2 access token
      final tokenResult = await _getAccessToken();
      if (tokenResult.isFailure) {
        return Failure(tokenResult.failure);
      }
      final accessToken = tokenResult.success;
      
      // Step 2: Build request payload
      final formatMap = {
        'mp3': 'MP3',
        'wav': 'LINEAR16',
        'ogg': 'OGG_OPUS',
        'opus': 'OGG_OPUS',
      };
      
      final payload = <String, dynamic>{
        'input': {
          'text': request.text,
        },
        'voice': {
          'languageCode': request.language ?? 'en-US',
          'name': request.voice ?? 'Kore',
          'modelName': 'gemini-2.5-flash-tts',
        },
        'audioConfig': {
          'audioEncoding': formatMap[request.audioFormat] ?? 'MP3',
        },
      };
      
      // Step 3: Make HTTP POST request
      final response = await _client
          .post(
            Uri.parse(_apiUrl),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(payload),
          )
          .timeout(_timeout);
      
      // Step 4: Handle response
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final audioContent = jsonData['audioContent'] as String?;
        
        if (audioContent == null) {
          return Failure(SpeechSynthesisError.unknown('Missing audioContent in API response'));
        }
        
        // Calculate duration (estimate: 150 words per minute)
        final wordCount = request.text.split(' ').length;
        final durationMs = ((wordCount / 150) * 60 * 1000).round();
        
        final dto = SpeechResponseDto(
          audioData: audioContent,
          audioFormat: request.audioFormat,
          durationMs: durationMs,
          metadata: jsonEncode({
            'service': 'gemini',
            'voice': request.voice ?? 'Kore',
          }),
        );
        
        AppLogger.info('Gemini TTS synthesis successful', tag: 'GeminiTtsService', data: {
          'format': dto.audioFormat,
          'duration': dto.durationMs,
        });
        
        return Success(dto);
      } else {
        // Step 5: Handle HTTP errors
        return Failure(_mapHttpErrorToDomainError(response.statusCode, response.body));
      }
    } on http.ClientException catch (e) {
      AppLogger.error('Network error during Gemini TTS request', tag: 'GeminiTtsService', error: e);
      return Failure(SpeechSynthesisError.networkError());
    } on FormatException catch (e) {
      AppLogger.error('Invalid response format', tag: 'GeminiTtsService', error: e);
      return Failure(SpeechSynthesisError.unknown('Invalid response format: ${e.message}'));
    } catch (e, stackTrace) {
      if (e.toString().contains('TimeoutException') || e.toString().contains('timeout')) {
        AppLogger.error('Request timeout', tag: 'GeminiTtsService', error: e);
        return Failure(const SpeechSynthesisError.timeout());
      }
      
      AppLogger.error('Unexpected error during Gemini TTS request',
          tag: 'GeminiTtsService',
          error: e,
          stackTrace: stackTrace);
      return Failure(SpeechSynthesisError.unknown(e.toString()));
    }
  }
  
  /// Gets OAuth2 credentials using service account key file (similar to Python _get_credentials)
  /// 
  /// **Process:**
  /// 1. Looks for service account key file in common locations (same as Python)
  /// 2. Reads and parses the JSON key file
  /// 3. Caches credentials for reuse
  /// 
  /// **Returns:**
  /// - `Result.success(Map<String, dynamic>)`: Credentials on success
  /// - `Result.failure(SpeechSynthesisError)`: On error
  Future<Result<Map<String, dynamic>, SpeechSynthesisError>> _getCredentials() async {
    // Use cached credentials if available
    if (_cachedCredentials != null) {
      return Success(_cachedCredentials!);
    }
    
    // Return cached error if available
    if (_credentialsError != null) {
      return Failure(SpeechSynthesisError.serviceError(_credentialsError!));
    }
    
    try {
      String? keyContent;
      
      // 1. Check GOOGLE_APPLICATION_CREDENTIALS environment variable (file path)
      final envKeyPath = Platform.environment['GOOGLE_APPLICATION_CREDENTIALS'] ?? 
                         dotenv.env['GOOGLE_APPLICATION_CREDENTIALS'];
      if (envKeyPath != null && File(envKeyPath).existsSync()) {
        final keyFile = File(envKeyPath);
        keyContent = await keyFile.readAsString();
      } else {
        // 2. Check for service account JSON in .env file (GOOGLE_SERVICE_ACCOUNT_JSON)
        final serviceAccountJson = dotenv.env['GOOGLE_SERVICE_ACCOUNT_JSON'];
        if (serviceAccountJson != null && serviceAccountJson.isNotEmpty) {
          keyContent = serviceAccountJson;
        } else {
          // 3. Try to load from assets (if placed in lib folder and added to pubspec.yaml)
          try {
            keyContent = await rootBundle.loadString(
              'lib/speech_synthesis/data/constants/service-account-key.json'
            );
          } catch (e) {
            // Asset not found, try file system paths
            String? keyFilePath;
            
            // 4. Try common file system locations (same as Python)
            final possiblePaths = [
              'service-account-key.json',
              '.gcloud/service-account-key.json',
              'lib/speech_synthesis/data/constants/service-account-key.json',
            ];
            
            // Try to find project root
            try {
              // For Flutter apps, try to find project root relative to current working directory
              final currentDir = Directory.current;
              var searchDir = currentDir;
              
              // Search up to 5 levels for project root
              for (int i = 0; i < 5; i++) {
                for (final relativePath in possiblePaths) {
                  final fullPath = path.join(searchDir.path, relativePath);
                  if (File(fullPath).existsSync()) {
                    keyFilePath = fullPath;
                    break;
                  }
                }
                if (keyFilePath != null) break;
                
                final parent = searchDir.parent;
                if (parent.path == searchDir.path) break; // Reached root
                searchDir = parent;
              }
            } catch (e) {
              // If we can't find project root, continue with error message
            }
            
            if (keyFilePath != null) {
              final keyFile = File(keyFilePath);
              keyContent = await keyFile.readAsString();
            }
          }
        }
      }
      
      if (keyContent == null) {
        final errorMsg = (
          'Google Cloud TTS not configured. '
          'Set up authentication using one of:\n'
          '1. .env file: Add GOOGLE_SERVICE_ACCOUNT_JSON with the full JSON content\n'
          '2. .env file: Add GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json\n'
          '3. Environment variable: export GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json\n'
          '4. Place service-account-key.json in project root\n'
          '5. Place service-account-key.json in lib/speech_synthesis/data/constants/ (as asset)\n'
          'Error: Credentials not found'
        );
        _credentialsError = errorMsg;
        return Failure(SpeechSynthesisError.serviceError(errorMsg));
      }
      
      // Parse service account key (same as Python)
      final keyData = jsonDecode(keyContent) as Map<String, dynamic>;
      
      // Extract required fields (same as Python)
      final clientEmail = keyData['client_email'] as String?;
      final privateKey = keyData['private_key'] as String?;
      final projectId = keyData['project_id'] as String?;
      
      if (clientEmail == null || privateKey == null) {
        final errorMsg = 'Invalid service account key file. Missing required fields (client_email, private_key).';
        _credentialsError = errorMsg;
        return Failure(SpeechSynthesisError.serviceError(errorMsg));
      }
      
      // Cache credentials
      _cachedCredentials = {
        'client_email': clientEmail,
        'private_key': privateKey,
        'project_id': projectId ?? '',
      };
      
      return Success(_cachedCredentials!);
    } catch (e, stackTrace) {
      final errorMsg = 'Failed to load credentials: ${e.toString()}';
      _credentialsError = errorMsg;
      AppLogger.error('Failed to get credentials', tag: 'GeminiTtsService', error: e, stackTrace: stackTrace);
      return Failure(SpeechSynthesisError.serviceError(errorMsg));
    }
  }
  
  /// Gets OAuth2 access token from service account key file
  /// 
  /// **Process:**
  /// 1. Gets credentials (cached or from file)
  /// 2. Generates JWT token for OAuth2
  /// 3. Exchanges JWT for access token (same as Python)
  /// 
  /// **Returns:**
  /// - `Result.success(String)`: Access token on success
  /// - `Result.failure(SpeechSynthesisError)`: On error
  Future<Result<String, SpeechSynthesisError>> _getAccessToken() async {
    try {
      // Get credentials (same as Python _get_credentials)
      final credentialsResult = await _getCredentials();
      if (credentialsResult.isFailure) {
        return Failure(credentialsResult.failure);
      }
      final credentials = credentialsResult.success;
      
      final clientEmail = credentials['client_email'] as String;
      final privateKey = credentials['private_key'] as String;
      
      // Generate JWT and exchange for access token (same as Python)
      final token = await _generateAccessToken(clientEmail, privateKey);
      
      return Success(token);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get access token', tag: 'GeminiTtsService', error: e, stackTrace: stackTrace);
      return Failure(SpeechSynthesisError.serviceError(
        'Failed to authenticate with Google Cloud: ${e.toString()}'
      ));
    }
  }
  
  /// Generates OAuth2 access token from service account credentials
  /// 
  /// This implements the same OAuth2 flow as the Python code:
  /// 1. Create JWT with claims (iss, scope, aud, exp, iat)
  /// 2. Sign JWT with RSA private key
  /// 3. POST to https://oauth2.googleapis.com/token with grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer
  /// 4. Extract access_token from response
  /// 
  /// **Parameters:**
  /// - `clientEmail`: Service account email (iss claim)
  /// - `privateKey`: RSA private key in PEM format
  /// 
  /// **Returns:**
  /// - `String`: OAuth2 access token
  Future<String> _generateAccessToken(String clientEmail, String privateKey) async {
    try {
      // Step 1: Create JWT with claims (same as Python)
      final now = DateTime.now().toUtc();
      final expiry = now.add(const Duration(seconds: 3600)); // 1 hour
      
      final claims = {
        'iss': clientEmail,
        'scope': _scopes.join(' '),
        'aud': _tokenUrl,
        'exp': expiry.millisecondsSinceEpoch ~/ 1000,
        'iat': now.millisecondsSinceEpoch ~/ 1000,
      };
      
      // Step 2: Sign JWT with RSA private key
      // The jose package automatically uses RS256 for RSA keys
      final key = JsonWebKey.fromPem(privateKey);
      final builder = JsonWebSignatureBuilder()
        ..jsonContent = claims;
      
      // Add recipient - algorithm is automatically determined from key type
      builder.addRecipient(key);
      
      final jws = builder.build();
      final signedJwt = jws.toCompactSerialization();
      
      // Step 3: Exchange JWT for access token (same as Python)
      // Use form-urlencoded format
      final tokenResponse = await _client.post(
        Uri.parse(_tokenUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: Uri(queryParameters: {
          'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
          'assertion': signedJwt,
        }).query,
      ).timeout(_timeout);
      
      if (tokenResponse.statusCode != 200) {
        throw Exception('Token exchange failed: ${tokenResponse.statusCode} ${tokenResponse.body}');
      }
      
      // Step 4: Extract access_token from response
      final tokenData = jsonDecode(tokenResponse.body) as Map<String, dynamic>;
      final accessToken = tokenData['access_token'] as String?;
      
      if (accessToken == null) {
        throw Exception('Missing access_token in token response');
      }
      
      return accessToken;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to generate access token', tag: 'GeminiTtsService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  /// Maps HTTP status codes to domain errors
  SpeechSynthesisError _mapHttpErrorToDomainError(int statusCode, String body) {
    try {
      final jsonData = jsonDecode(body) as Map<String, dynamic>?;
      final error = jsonData?['error'] as Map<String, dynamic>?;
      
      if (error != null) {
        final code = error['code'] as int?;
        final status = error['status'] as String?;
        final message = error['message'] as String?;
        final details = error['details'] as List<dynamic>?;
        
        // Check for billing errors
        if (code == 403 && status == 'PERMISSION_DENIED') {
          if (details != null) {
            for (final detail in details) {
              if (detail is Map<String, dynamic>) {
                final reason = detail['reason'] as String?;
                if (reason == 'BILLING_DISABLED') {
                  return SpeechSynthesisError.serviceError(
                    'Billing is not enabled for your Google Cloud project. '
                    'Please enable billing in the Google Cloud Console.'
                  );
                }
              }
            }
          }
          return const SpeechSynthesisError.forbidden();
        }
        
        // Map other error codes
        if (code == 401) {
          return const SpeechSynthesisError.unauthorized();
        } else if (code == 403) {
          return const SpeechSynthesisError.forbidden();
        } else if (code == 429) {
          return const SpeechSynthesisError.tooManyRequests();
        } else if (code == 503) {
          return const SpeechSynthesisError.serviceUnavailable();
        }
        
        // Return service error with message
        if (message != null) {
          return SpeechSynthesisError.serviceError(message);
        }
      }
    } catch (e) {
      // If parsing fails, fall through to default
    }
    
    // Default error mapping
    switch (statusCode) {
      case 400:
        return SpeechSynthesisError.validation('Invalid request: $body');
      case 401:
        return const SpeechSynthesisError.unauthorized();
      case 403:
        return const SpeechSynthesisError.forbidden();
      case 429:
        return const SpeechSynthesisError.tooManyRequests();
      case 503:
        return const SpeechSynthesisError.serviceUnavailable();
      default:
        return SpeechSynthesisError.unknown('HTTP $statusCode: $body');
    }
  }
}
