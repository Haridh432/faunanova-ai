import '../../models/animal.dart';

class AnimalSignalResult {
  final String signalType; // e.g. "Whistle (18kHz)", "Calm Low-Pitch Hum", "Friendly Chirp"
  final String descriptionEn;
  final String descriptionTa;
  final double frequencyHz;
  final Duration duration;
  final bool isPlaying;

  const AnimalSignalResult({
    required this.signalType,
    required this.descriptionEn,
    required this.descriptionTa,
    required this.frequencyHz,
    required this.duration,
    this.isPlaying = false,
  });
}

abstract class AnimalCommunicationSignalService {
  /// Maps detected human intent to species-specific acoustic communication signal
  AnimalSignalResult generateSignalForIntent({
    required AnimalSpecies species,
    required String humanIntent,
  });

  /// Plays synthesized acoustic sound or frequency pulse through device speaker
  Future<void> playSignal(AnimalSignalResult signal);

  /// Stops any currently playing signal
  Future<void> stopSignal();

  /// Stream indicating whether signal is currently playing
  Stream<bool> get isPlayingStream;
}
