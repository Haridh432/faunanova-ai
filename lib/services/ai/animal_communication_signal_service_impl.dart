import 'dart:async';
import '../../models/animal.dart';
import 'animal_communication_signal_service.dart';

class AnimalCommunicationSignalServiceImpl
    implements AnimalCommunicationSignalService {
  final _isPlayingController = StreamController<bool>.broadcast();
  Timer? _playbackTimer;

  @override
  Stream<bool> get isPlayingStream => _isPlayingController.stream;

  @override
  AnimalSignalResult generateSignalForIntent({
    required AnimalSpecies species,
    required String humanIntent,
  }) {
    final intentUpper = humanIntent.toUpperCase();

    switch (species) {
      case AnimalSpecies.dog:
        if (intentUpper.contains('COME') || intentUpper.contains('CALL')) {
          return const AnimalSignalResult(
            signalType: 'High-Pitch Friendly Whistle (1200Hz Sweep)',
            descriptionEn: 'Rising frequency whistle known to catch canine attention without triggering defense.',
            descriptionTa: 'நாயை அன்புடன் ஈர்க்கும் உயர்தொனி சீழ்க்கை ஒலி (1200Hz)',
            frequencyHz: 1200.0,
            duration: Duration(milliseconds: 1800),
          );
        } else if (intentUpper.contains('CALM') || intentUpper.contains('SOOTHE')) {
          return const AnimalSignalResult(
            signalType: 'Low-Frequency Soothing Drone (240Hz)',
            descriptionEn: 'Continuous harmonic wave simulating relaxed breathing and calm pack presence.',
            descriptionTa: 'பதட்டத்தைத் தணிக்கும் மெல்லிய தணிந்த அலை ஒலி (240Hz)',
            frequencyHz: 240.0,
            duration: Duration(milliseconds: 2500),
          );
        } else if (intentUpper.contains('STOP') || intentUpper.contains('CAUTION')) {
          return const AnimalSignalResult(
            signalType: 'Firm Dual-Pulse Acoustic Signal (450Hz)',
            descriptionEn: 'Short firm audio marker commanding halt without aggression.',
            descriptionTa: 'கட்டுப்படுத்தும் உறுதியான இரட்டை ஒலி சமிக்ஞை (450Hz)',
            frequencyHz: 450.0,
            duration: Duration(milliseconds: 1200),
          );
        } else {
          return const AnimalSignalResult(
            signalType: 'Playful Chirp Harmonic (850Hz)',
            descriptionEn: 'Encouraging acoustic cue signaling food or friendly engagement.',
            descriptionTa: 'மகிழ்ச்சியூட்டும் நட்பு சமிக்ஞை (850Hz)',
            frequencyHz: 850.0,
            duration: Duration(milliseconds: 1500),
          );
        }

      case AnimalSpecies.cat:
        if (intentUpper.contains('COME') || intentUpper.contains('CALL')) {
          return const AnimalSignalResult(
            signalType: 'Soft High-Frequency Trill (3.4kHz)',
            descriptionEn: 'Gentle bird-like trill replicating mother cat greeting call.',
            descriptionTa: 'பூனையை அழைக்கும் மென்மையான கீச்சொலி (3.4kHz)',
            frequencyHz: 3400.0,
            duration: Duration(milliseconds: 1600),
          );
        } else if (intentUpper.contains('CALM')) {
          return const AnimalSignalResult(
            signalType: 'Purr Resonance Vibration (28Hz)',
            descriptionEn: 'Low frequency vibration simulating comforting feline purring.',
            descriptionTa: 'பூனையை அமைதிப்படுத்தும் மென் அதிர்வு (28Hz)',
            frequencyHz: 28.0,
            duration: Duration(milliseconds: 3000),
          );
        } else {
          return const AnimalSignalResult(
            signalType: 'Gentle Pssht Marker (Acoustic White Noise)',
            descriptionEn: 'Soft sibilant whisper getting attention without alarming.',
            descriptionTa: 'பூனையின் கவனத்தை ஈர்க்கும் மென் விசிலொலி',
            frequencyHz: 2000.0,
            duration: Duration(milliseconds: 1400),
          );
        }

      case AnimalSpecies.cow:
        return const AnimalSignalResult(
          signalType: 'Harmonic Low Drone (160Hz)',
          descriptionEn: 'Deep soothing tone matching bovine vocal range for reassurance.',
          descriptionTa: 'மாட்டை அமைதிப்படுத்தும் ஆழ்ந்த மென் ஒலி (160Hz)',
          frequencyHz: 160.0,
          duration: Duration(milliseconds: 2400),
        );

      case AnimalSpecies.bird:
        return const AnimalSignalResult(
          signalType: 'Melodic Social Whistle (3.1kHz)',
          descriptionEn: 'Non-predatory harmonic chirp encouraging contact and curiosity.',
          descriptionTa: 'பறவையின் கவனத்தை ஈர்க்கும் நட்பு விசிலொலி (3.1kHz)',
          frequencyHz: 3100.0,
          duration: Duration(milliseconds: 1800),
        );

      case AnimalSpecies.goat:
        return const AnimalSignalResult(
          signalType: 'Medium Resonance Pulse (420Hz)',
          descriptionEn: 'Friendly rhythmic pulse indicating friendly human arrival.',
          descriptionTa: 'ஆடுகளுக்கான வழக்கமான நட்பு அழைப்பு ஒலி (420Hz)',
          frequencyHz: 420.0,
          duration: Duration(milliseconds: 1700),
        );

      case AnimalSpecies.elephant:
        return const AnimalSignalResult(
          signalType: 'Infrasonic Sub-Bass Wave (20Hz)',
          descriptionEn: 'Acoustic simulation of sub-audible social reassurance rumble.',
          descriptionTa: 'யானைக்கான ஆழ்ந்த அதிர்வு ஒலி (20Hz)',
          frequencyHz: 20.0,
          duration: Duration(milliseconds: 3500),
        );
    }
  }

  @override
  Future<void> playSignal(AnimalSignalResult signal) async {
    _playbackTimer?.cancel();
    _isPlayingController.add(true);

    _playbackTimer = Timer(signal.duration, () {
      _isPlayingController.add(false);
    });
  }

  @override
  Future<void> stopSignal() async {
    _playbackTimer?.cancel();
    _isPlayingController.add(false);
  }

  void dispose() {
    _playbackTimer?.cancel();
    _isPlayingController.close();
  }
}
