import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _isSpeaking = false;

  Future<void> initialize() async {
    await _tts.setSharedInstance(true);
    await _tts.setSpeechRate(0.48);
    await _tts.setPitch(1.05); // slightly warm/friendly pitch
    await _tts.setVolume(1.0);

    _tts.setStartHandler(() => _isSpeaking = true);
    _tts.setCompletionHandler(() => _isSpeaking = false);
    _tts.setCancelHandler(() => _isSpeaking = false);
  }

  /// Detects Devanagari script vs Latin to pick the right voice locale.
  String detectLocale(String text) {
    final hindiPattern = RegExp(r'[\u0900-\u097F]');
    return hindiPattern.hasMatch(text) ? 'hi-IN' : 'en-IN';
  }

  Future<void> speak(String text) async {
    final locale = detectLocale(text);
    await _tts.setLanguage(locale);
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
    _isSpeaking = false;
  }

  bool get isSpeaking => _isSpeaking;
}
