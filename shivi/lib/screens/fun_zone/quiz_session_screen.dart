import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/fun_zone_provider.dart';
import '../../data/models/chat_message.dart';
import '../../data/services/tts_service.dart';
import '../voice_chat/widgets/chat_bubble.dart';
import '../voice_chat/widgets/mic_button.dart';
import '../../providers/voice_provider.dart';
import '../../core/constants/app_colors.dart';

class QuizSessionScreen extends ConsumerStatefulWidget {
  const QuizSessionScreen({super.key});

  @override
  ConsumerState<QuizSessionScreen> createState() => _QuizSessionScreenState();
}

class _QuizSessionScreenState extends ConsumerState<QuizSessionScreen> {
  final _ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(funZoneProvider);
    final notifier = ref.read(funZoneProvider.notifier);

    // Speak Shivi's latest line automatically
    ref.listen(funZoneProvider, (prev, next) {
      if (next.sessionMessages.isNotEmpty &&
          next.sessionMessages.last.role == MessageRole.assistant &&
          prev?.sessionMessages.length != next.sessionMessages.length) {
        _ttsService.speak(next.sessionMessages.last.content);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.softCream,
      appBar: AppBar(
        title: const Text('Quiz with Shivi'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              notifier.endGame();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: state.sessionMessages.length,
              itemBuilder: (context, index) {
                final msg = state.sessionMessages.reversed.toList()[index];
                return ChatBubble(message: msg);
              },
            ),
          ),
          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: MicButton(
                state: state.isLoading ? ShiviState.thinking : ShiviState.idle,
                onTap: () async {
                  // Wire to SpeechService the same way as VoiceChatScreen —
                  // capture transcript, then call notifier.respond(transcript)
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
