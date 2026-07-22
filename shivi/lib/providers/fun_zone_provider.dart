import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/hugging_face_service.dart';
import '../data/models/chat_message.dart';
import 'package:uuid/uuid.dart';

enum GameType { truthOrTongueTwister, bilingualTrivia, rapidFireMood }

class FunZoneState {
  final List<ChatMessage> sessionMessages;
  final bool isLoading;
  final GameType? activeGame;

  FunZoneState({
    this.sessionMessages = const [],
    this.isLoading = false,
    this.activeGame,
  });

  FunZoneState copyWith({
    List<ChatMessage>? sessionMessages,
    bool? isLoading,
    GameType? activeGame,
  }) {
    return FunZoneState(
      sessionMessages: sessionMessages ?? this.sessionMessages,
      isLoading: isLoading ?? this.isLoading,
      activeGame: activeGame ?? this.activeGame,
    );
  }
}

class FunZoneNotifier extends StateNotifier<FunZoneState> {
  final HuggingFaceService _hfService;
  final _uuid = const Uuid();

  FunZoneNotifier(this._hfService) : super(FunZoneState());

  String _kickoffPromptFor(GameType game) {
    switch (game) {
      case GameType.truthOrTongueTwister:
        return "Let's play Truth or Tongue Twister! Give me either a fun personal-style truth question or a bilingual tongue twister to attempt.";
      case GameType.bilingualTrivia:
        return "Start a round of Bilingual Trivia — ask me one fun general knowledge question, mixing Hindi and English.";
      case GameType.rapidFireMood:
        return "Let's do Rapid-Fire Mood Boosters — give me a quick, fun prompt to lighten my mood right now.";
    }
  }

  Future<void> startGame(GameType game) async {
    state = FunZoneState(activeGame: game, isLoading: true);
    await _send(_kickoffPromptFor(game), persona: ShiviPersona.quizMaster);
  }

  Future<void> respond(String userText) async {
    state = state.copyWith(isLoading: true);
    await _send(userText, persona: ShiviPersona.quizMaster);
  }

  Future<void> _send(String text, {required ShiviPersona persona}) async {
    final userMsg = ChatMessage(
      id: _uuid.v4(),
      role: MessageRole.user,
      content: text,
      timestamp: DateTime.now(),
    );
    state =
        state.copyWith(sessionMessages: [...state.sessionMessages, userMsg]);

    try {
      final reply = await _hfService.getChatResponse(
        history: state.sessionMessages,
        userMessage: text,
        persona: persona,
      );
      final botMsg = ChatMessage(
        id: _uuid.v4(),
        role: MessageRole.assistant,
        content: reply,
        timestamp: DateTime.now(),
      );
      state = state.copyWith(
        sessionMessages: [...state.sessionMessages, botMsg],
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  void endGame() => state = FunZoneState();
}

final funZoneProvider =
    StateNotifierProvider<FunZoneNotifier, FunZoneState>((ref) {
  return FunZoneNotifier(HuggingFaceService());
});
