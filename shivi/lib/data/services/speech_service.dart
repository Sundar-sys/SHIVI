import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  Future<bool> initialize() async {
    final micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) return false;

    _isInitialized = await _speech.initialize(
      onError: (error) => print('STT Error: ${error.errorMsg}'),
      onStatus: (status) => print('STT Status: $status'),
    );
    return _isInitialized;
  }

  Future<void> startListening({
    required Function(String text, bool isFinal) onResult,
    String localeId = 'en_IN', // switch to 'hi_IN' for Hindi
  }) async {
    if (!_isInitialized) {
      final ok = await initialize();
      if (!ok) return;
    }

    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
      },
      localeId: localeId,
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
      ),
    );
  }

  Future<void> stopListening() async => _speech.stop();

  bool get isListening => _speech.isListening;
  bool get isAvailable => _isInitialized;
}
