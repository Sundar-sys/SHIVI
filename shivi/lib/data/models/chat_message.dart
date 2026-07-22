import 'package:equatable/equatable.dart';

enum MessageRole { user, assistant, system }

class ChatMessage extends Equatable {
  final String id;
  final MessageRole role;
  final String content;
  final DateTime timestamp;
  final String languageCode; // 'hi-IN' | 'en-IN'

  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.languageCode = 'en-IN',
  });

  Map<String, String> toApiJson() => {
        'role': role == MessageRole.user
            ? 'user'
            : role == MessageRole.assistant
                ? 'assistant'
                : 'system',
        'content': content,
      };

  @override
  List<Object?> get props => [id, role, content, timestamp, languageCode];
}
