import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/speech_service.dart';
import '../data/services/tts_service.dart';
import '../data/services/hugging_face_service.dart';
import '../data/models/chat_message.dart';
import 'package:uuid/uuid.dart';

enum ShiviState { idle, listening, thinking, speaking }

class VoiceChatState {
  final ShiviState shiviState;
  final List<ChatMessage> messages;
  final String liveTranscript;
  final String currentLocale;
  final String? statusMessage; // e.g. "Shivi is waking up..."
  final String? errorMessage;

  VoiceChatState({
    this.shiviState = ShiviState.idle,
    this.messages = const [],
    this.liveTranscript = '',
    this.currentLocale = 'en_IN',
    this.statusMessage,
    this.errorMessage,
  });

  VoiceChatState copyWith({
    ShiviState? shiviState,
    List<ChatMessage>? messages,
    String? liveTranscript,
    String? currentLocale,
    String? statusMessage,
    bool clearStatusMessage = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return VoiceChatState(
      shiviState: shiviState ?? this.shiviState,
      messages: messages ?? this.messages,
      liveTranscript: liveTranscript ?? this.liveTranscript,
      currentLocale: currentLocale ?? this.currentLocale,
      statusMessage:
          clearStatusMessage ? null : (statusMessage ?? this.statusMessage),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class VoiceChatNotifier extends StateNotifier<VoiceChatState> {
  final SpeechService _speechService;
  final TtsService _ttsService;
  final HuggingFaceService _hfService;
  final _uuid = const Uuid();

  VoiceChatNotifier(this._speechService, this._ttsService, this._hfService)
      : super(VoiceChatState()) {
    _ttsService.initialize();
  }

  Future<void> toggleListening() async {
    if (state.shiviState == ShiviState.listening) {
      await _speechService.stopListening();
      await _submitTranscript();
      return;
    }

    state =
        state.copyWith(shiviState: ShiviState.listening, liveTranscript: '');
    await _speechService.startListening(
      localeId: state.currentLocale,
      onResult: (text, isFinal) {
        state = state.copyWith(liveTranscript: text);
        if (isFinal) _submitTranscript();
      },
    );
  }

  Future<void> _submitTranscript() async {
    final text = state.liveTranscript.trim();
    if (text.isEmpty) {
      state = state.copyWith(shiviState: ShiviState.idle);
      return;
    }
    await sendMessage(text);
  }

  Future<void> sendMessage(String text) async {
    final userMsg = ChatMessage(
      id: _uuid.v4(),
      role: MessageRole.user,
      content: text,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      shiviState: ShiviState.thinking,
      liveTranscript: '',
      clearStatusMessage: true,
      clearErrorMessage: true,
    );

    try {
      final reply = await _hfService.getChatResponseWithRetry(
        history: state.messages,
        userMessage: text,
        onRetry: (attempt, message) {
          state = state.copyWith(statusMessage: message);
        },
      );

      final botMsg = ChatMessage(
        id: _uuid.v4(),
        role: MessageRole.assistant,
        content: reply,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, botMsg],
        shiviState: ShiviState.speaking,
        clearStatusMessage: true,
      );

      await _ttsService.speak(reply);
      state = state.copyWith(shiviState: ShiviState.idle);
    } on HuggingFaceException catch (e) {
      state = state.copyWith(
        shiviState: ShiviState.idle,
        clearStatusMessage: true,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        shiviState: ShiviState.idle,
        clearStatusMessage: true,
        errorMessage: "Something went wrong. Let's try again?",
      );
    }
  }

  void switchLanguage(String localeId) {
    state = state.copyWith(currentLocale: localeId);
  }
}

final voiceChatProvider =
    StateNotifierProvider<VoiceChatNotifier, VoiceChatState>((ref) {
  return VoiceChatNotifier(
    SpeechService(),
    TtsService(),
    HuggingFaceService(),
  );
});
