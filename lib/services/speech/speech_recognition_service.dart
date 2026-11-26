abstract class SpeechRecognitionService {
  /// Whether speech recognition is active
  bool get isRecognizing;

  /// Stream of recognized text in Tamil or English
  Stream<String> get textStream;

  /// Starts capturing human speech (Tamil default)
  Future<void> startListening({String languageCode = 'ta-IN'});

  /// Stops speech capture and returns final recognized transcript
  Future<String> stopListening();

  /// Maps human spoken sentence into high-level intent (e.g. "இங்கே வா" -> "COME / CALL")
  String detectHumanIntent(String speechText);
}
