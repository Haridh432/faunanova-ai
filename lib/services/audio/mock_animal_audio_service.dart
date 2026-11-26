import 'dart:async';
import 'dart:math';
import 'animal_audio_service.dart';

class MockAnimalAudioService implements AnimalAudioService {
  final _random = Random();
  final _levelController = StreamController<double>.broadcast();
  final _waveformController = StreamController<List<double>>.broadcast();
  final _soundEventController = StreamController<String>.broadcast();

  Timer? _waveformTimer;
  Timer? _soundEventTimer;
  bool _isListening = false;
  String _currentSpecies = 'dog';

  @override
  bool get isListening => _isListening;

  @override
  Stream<double> get audioLevelStream => _levelController.stream;

  @override
  Stream<List<double>> get waveformStream => _waveformController.stream;

  @override
  Stream<String> get soundEventStream => _soundEventController.stream;

  @override
  Future<void> startListening({required String species}) async {
    _currentSpecies = species.toLowerCase();
    _isListening = true;

    _waveformTimer?.cancel();
    _soundEventTimer?.cancel();

    // Generate real-time waveform frames at 25 fps (40ms)
    double phase = 0;
    _waveformTimer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      if (!_isListening) return;

      phase += 0.25;
      final baseAmplitude = 0.35 + 0.35 * sin(phase * 0.7);
      final level = (baseAmplitude + (_random.nextDouble() * 0.2)).clamp(0.05, 0.98);
      _levelController.add(level);

      // 32 waveform visualizer bars
      final points = List.generate(32, (i) {
        final wave = sin(phase + (i * 0.35)) * 0.4 + cos(phase * 0.5 + (i * 0.2)) * 0.3;
        final noise = (_random.nextDouble() - 0.5) * 0.25;
        final val = (wave.abs() + noise + (level * 0.5)).clamp(0.1, 1.0);
        return val;
      });

      _waveformController.add(points);
    });

    // Periodically trigger a vocalization event every 4.5 seconds
    _soundEventTimer = Timer.periodic(const Duration(milliseconds: 4500), (_) {
      if (!_isListening) return;
      final sound = _getRandomSoundForSpecies(_currentSpecies);
      _soundEventController.add(sound);
    });
  }

  String _getRandomSoundForSpecies(String species) {
    switch (species) {
      case 'cat':
        final list = ['Meow', 'Purr', 'High Pitch Meow', 'Chirp'];
        return list[_random.nextInt(list.length)];
      case 'cow':
        final list = ['Low Moo', 'Resonant Call', 'Feeding Moo'];
        return list[_random.nextInt(list.length)];
      case 'bird':
        final list = ['Chirp Sequence', 'Alarm Trill', 'Melodic Whistle'];
        return list[_random.nextInt(list.length)];
      case 'goat':
        final list = ['Bleat', 'High Call', 'Social Bleat'];
        return list[_random.nextInt(list.length)];
      case 'elephant':
        final list = ['Infrasonic Rumble', 'Trumpet Call', 'Snort'];
        return list[_random.nextInt(list.length)];
      case 'dog':
      default:
        final list = ['Bark (Alert)', 'Short Whimper', 'Attention Bark', 'Play Growl'];
        return list[_random.nextInt(list.length)];
    }
  }

  /// Manually trigger a simulated sound event for interactive testing
  void triggerManualSound(String soundType) {
    _soundEventController.add(soundType);
  }

  @override
  Future<void> stopListening() async {
    _isListening = false;
    _waveformTimer?.cancel();
    _soundEventTimer?.cancel();
    _waveformTimer = null;
    _soundEventTimer = null;
    _waveformController.add(List.generate(32, (_) => 0.05));
    _levelController.add(0.0);
  }

  @override
  Future<List<double>> extractAcousticFeatures() async {
    // Noise reduction and spectral feature vector (simulated MFCC / spectrogram)
    await Future.delayed(const Duration(milliseconds: 150));
    return List.generate(24, (i) => _random.nextDouble());
  }

  void dispose() {
    stopListening();
    _levelController.close();
    _waveformController.close();
    _soundEventController.close();
  }
}
