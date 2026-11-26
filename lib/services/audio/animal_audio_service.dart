abstract class AnimalAudioService {
  /// Whether microphone is actively recording/monitoring
  bool get isListening;

  /// Stream of normalized audio volume/amplitude (0.0 - 1.0)
  Stream<double> get audioLevelStream;

  /// Stream of real-time audio waveform values for visualizer
  Stream<List<double>> get waveformStream;

  /// Stream of detected sound events (sound type detected from buffer)
  Stream<String> get soundEventStream;

  /// Starts listening to environment microphone input
  Future<void> startListening({required String species});

  /// Stops listening
  Future<void> stopListening();

  /// Performs noise reduction and audio segmentation on buffer
  Future<List<double>> extractAcousticFeatures();
}
