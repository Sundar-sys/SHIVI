import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../providers/voice_provider.dart';
import '../../core/constants/app_colors.dart';
import 'widgets/voice_wave_visualizer.dart';
import 'widgets/mic_button.dart';
import 'widgets/chat_bubble.dart';

class VoiceChatScreen extends ConsumerStatefulWidget {
  const VoiceChatScreen({super.key});

  @override
  ConsumerState<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends ConsumerState<VoiceChatScreen> {
  bool _showTextInput = false;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowMicPrimer());
  }

  Future<void> _maybeShowMicPrimer() async {
    final status = await Permission.microphone.status;
    if (status.isGranted || status.isPermanentlyDenied || !mounted) return;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Let's talk"),
        content: const Text(
          "Shivi needs your microphone to hear you. Your voice is only used "
          "to understand what you say — nothing is recorded or shared.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await Permission.microphone.request();
            },
            child: const Text('Allow microphone'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final voiceState = ref.watch(voiceChatProvider);
    final notifier = ref.read(voiceChatProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.softCream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Shivi', style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: Icon(_showTextInput ? Icons.mic : Icons.keyboard),
            onPressed: () => setState(() => _showTextInput = !_showTextInput),
            tooltip: 'Toggle text input',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (locale) => notifier.switchLanguage(locale),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'en_IN', child: Text('English')),
              PopupMenuItem(value: 'hi_IN', child: Text('हिंदी')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: voiceState.messages.isEmpty
                  ? _buildEmptyState(voiceState)
                  : ListView.builder(
                      reverse: true,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: voiceState.messages.length,
                      itemBuilder: (context, index) {
                        final msg = voiceState.messages.reversed.toList()[index];
                        return ChatBubble(message: msg);
                      },
                    ),
            ),
            _buildInputArea(voiceState, notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(VoiceChatState voiceState) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VoiceWaveVisualizer(state: voiceState.shiviState),
          const SizedBox(height: 24),
          Text(
            voiceState.statusMessage ?? _statusText(voiceState.shiviState),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: AppColors.softPurpleDark),
          ),
          if (voiceState.errorMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                voiceState.errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade700, fontSize: 13),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _statusText(ShiviState state) {
    switch (state) {
      case ShiviState.listening:
        return "I'm listening...";
      case ShiviState.thinking:
        return "Shivi is thinking...";
      case ShiviState.speaking:
        return "Shivi is speaking...";
      case ShiviState.idle:
        return "Tap the mic to talk to Shivi";
    }
  }

  Widget _buildInputArea(VoiceChatState voiceState, VoiceChatNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _showTextInput
          ? Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type to Shivi...',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (text) {
                      if (text.trim().isEmpty) return;
                      notifier.sendMessage(text.trim());
                      _textController.clear();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.softPurpleDark),
                  onPressed: () {
                    final text = _textController.text.trim();
                    if (text.isEmpty) return;
                    notifier.sendMessage(text);
                    _textController.clear();
                  },
                ),
              ],
            )
          : Center(
              child: MicButton(
                state: voiceState.shiviState,
                onTap: notifier.toggleListening,
              ),
            ),
    );
  }
}
