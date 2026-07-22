import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/constants/api_constants.dart';
import '../models/chat_message.dart';

/// Modes Shivi can operate in — changes the system prompt sent to the model
/// (system prompts themselves live server-side in shivi-proxy).
enum ShiviPersona { companion, quizMaster, playfulBanter }

class HuggingFaceService {
  final Dio _dio;

  HuggingFaceService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout:
                    const Duration(seconds: ApiConstants.timeoutSeconds),
                receiveTimeout:
                    const Duration(seconds: ApiConstants.timeoutSeconds),
                headers: {'Content-Type': 'application/json'},
              ),
            );

  // This is a shared app-identity secret, not a user credential — it still
  // ships in the binary, but it only unlocks your rate-limited proxy, not
  // your HF account/quota directly. Rotate it if you ever suspect leakage.
  String get _appKey => dotenv.env['SHIVI_APP_SECRET'] ?? '';

  String _personaKey(ShiviPersona persona) {
    switch (persona) {
      case ShiviPersona.quizMaster:
        return 'quizMaster';
      case ShiviPersona.playfulBanter:
        return 'playfulBanter';
      case ShiviPersona.companion:
        return 'companion';
    }
  }

  Future<String> getChatResponse({
    required List<ChatMessage> history,
    required String userMessage,
    ShiviPersona persona = ShiviPersona.companion,
  }) async {
    final messages = [
      ...history.map((m) => m.toApiJson()),
      {'role': 'user', 'content': userMessage},
    ];

    try {
      final response = await _dio.post(
        ApiConstants.chatEndpoint,
        options: Options(headers: {'x-shivi-app-key': _appKey}),
        data: jsonEncode({
          'messages': messages,
          'persona': _personaKey(persona),
        }),
      );

      final reply = response.data['reply'];
      if (reply == null || reply.toString().trim().isEmpty) {
        throw HuggingFaceException('Empty response from Shivi');
      }
      return reply.toString().trim();
    } on DioException catch (e) {
      if (e.response?.statusCode == 503) {
        throw HuggingFaceException(
          'Shivi is waking up, please try again in a few seconds',
          isRetryable: true,
        );
      }
      if (e.response?.statusCode == 429) {
        throw HuggingFaceException(
          "You're chatting a bit fast — give me a second",
          isRetryable: true,
        );
      }
      throw HuggingFaceException(
        'Network error: ${e.message ?? "unknown"}',
        isRetryable: true,
      );
    } catch (e) {
      throw HuggingFaceException('Unexpected error: $e');
    }
  }

  /// Wraps getChatResponse with exponential backoff for retryable errors
  /// (503 cold-start, 429 rate limit, network blips). Non-retryable errors
  /// fail immediately.
  Future<String> getChatResponseWithRetry({
    required List<ChatMessage> history,
    required String userMessage,
    ShiviPersona persona = ShiviPersona.companion,
    int maxRetries = 3,
    void Function(int attempt, String message)? onRetry,
  }) async {
    int attempt = 0;
    Duration delay = const Duration(seconds: 2);

    while (true) {
      try {
        return await getChatResponse(
          history: history,
          userMessage: userMessage,
          persona: persona,
        );
      } on HuggingFaceException catch (e) {
        attempt++;
        if (!e.isRetryable || attempt > maxRetries) {
          rethrow;
        }
        onRetry?.call(attempt, e.message);
        await Future.delayed(delay);
        delay *= 2; // 2s -> 4s -> 8s
      }
    }
  }
}

class HuggingFaceException implements Exception {
  final String message;
  final bool isRetryable;
  HuggingFaceException(this.message, {this.isRetryable = false});

  @override
  String toString() => 'HuggingFaceException: $message';
}
