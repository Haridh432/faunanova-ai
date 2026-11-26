import 'dart:async';
import 'speech_recognition_service.dart';

class MockSpeechRecognitionService implements SpeechRecognitionService {
  final _textController = StreamController<String>.broadcast();
  bool _isRecognizing = false;
  Timer? _speechSimulationTimer;
  String _currentSpokenText = '';

  // Preset Tamil phrases for quick testing & realistic simulation
  final List<String> sampleTamilPhrases = [
    'இங்கே வா',
    'சாப்பிடு',
    'அமைதியாக இரு',
    'நில், வேண்டாம்',
    'நல்ல பிள்ளை, பயப்படாதே',
    'உணவு வேண்டுமா?',
  ];

  @override
  bool get isRecognizing => _isRecognizing;

  @override
  Stream<String> get textStream => _textController.stream;

  @override
  Future<void> startListening({String languageCode = 'ta-IN'}) async {
    _isRecognizing = true;
    _speechSimulationTimer?.cancel();

    // Simulate word-by-word streaming recognition
    _currentSpokenText = '';

    final words = ['இங்கே', 'இங்கே வா'];
    int index = 0;

    _speechSimulationTimer = Timer.periodic(const Duration(milliseconds: 650), (timer) {
      if (!_isRecognizing) {
        timer.cancel();
        return;
      }

      if (index < words.length) {
        _currentSpokenText = words[index];
        _textController.add(_currentSpokenText);
        index++;
      } else {
        timer.cancel();
      }
    });
  }

  /// Sets custom spoken text directly (used when user types or chooses a preset)
  void setSpokenPhrase(String phrase) {
    _currentSpokenText = phrase;
    _textController.add(_currentSpokenText);
  }

  @override
  Future<String> stopListening() async {
    _isRecognizing = false;
    _speechSimulationTimer?.cancel();
    _speechSimulationTimer = null;
    return _currentSpokenText.isNotEmpty ? _currentSpokenText : 'இங்கே வா';
  }

  @override
  String detectHumanIntent(String speechText) {
    final lower = speechText.trim();

    if (lower.contains('வா') || lower.contains('இங்கே') || lower.contains('come')) {
      return 'COME / CALL';
    } else if (lower.contains('சாப்பிடு') || lower.contains('உணவு') || lower.contains('eat') || lower.contains('food')) {
      return 'FEEDING / FOOD';
    } else if (lower.contains('அமைதி') || lower.contains('பயப்படாதே') || lower.contains('calm') || lower.contains('quiet')) {
      return 'CALM / SOOTHE';
    } else if (lower.contains('நில்') || lower.contains('வேண்டாம்') || lower.contains('stop') || lower.contains('no')) {
      return 'STOP / CAUTION';
    } else if (lower.contains('நல்ல') || lower.contains('அன்பு') || lower.contains('good') || lower.contains('love')) {
      return 'AFFECTION / PRAISE';
    }

    return 'COME / CALL';
  }

  void dispose() {
    _speechSimulationTimer?.cancel();
    _textController.close();
  }
}
