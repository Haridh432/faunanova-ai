import 'dart:math';
import 'package:uuid/uuid.dart';
import '../../models/animal.dart';
import '../../models/animal_sound.dart';
import 'sound_classification_service.dart';
import 'animal_intent_service.dart';
import '../translation/tamil_interpretation_service.dart';

class SoundClassificationServiceImpl implements SoundClassificationService {
  final AnimalIntentService intentService;
  final TamilInterpretationService tamilService;
  final _uuid = const Uuid();
  final _random = Random();

  SoundClassificationServiceImpl({
    required this.intentService,
    required this.tamilService,
  });

  @override
  List<String> getSoundTypesForSpecies(AnimalSpecies species) {
    switch (species) {
      case AnimalSpecies.dog:
        return ['Bark (Alert)', 'Continuous Bark', 'Whimper', 'Play Growl', 'Howl'];
      case AnimalSpecies.cat:
        return ['Soft Meow', 'Urgent Meow', 'Purr', 'Hiss', 'Chirp'];
      case AnimalSpecies.cow:
        return ['Low Moo', 'High Frequency Call', 'Feeding Moo', 'Grunt'];
      case AnimalSpecies.bird:
        return ['Melodic Chirp', 'Alarm Trill', 'Territorial Call', 'Morning Song'];
      case AnimalSpecies.goat:
        return ['High Bleat', 'Low Grunt', 'Separation Bleat', 'Alarm Snort'];
      case AnimalSpecies.elephant:
        return ['Infrasonic Rumble', 'Trumpet', 'Gentle Roar', 'Low Murmur'];
    }
  }

  @override
  Future<AnimalSound> classifySound({
    required AnimalSpecies species,
    required List<double> audioFeatures,
  }) async {
    // Simulate classification inference latency
    await Future.delayed(const Duration(milliseconds: 300));

    final soundTypes = getSoundTypesForSpecies(species);
    final chosenSound = soundTypes[_random.nextInt(soundTypes.length)];

    final intent = await intentService.predictIntent(
      species: species,
      soundType: chosenSound,
    );

    final tamilText = tamilService.getTamilInterpretation(
      species: species,
      category: intent.category,
      soundType: chosenSound,
    );

    // Realistic confidence score between 82% and 96%
    final confidence = 0.82 + (_random.nextDouble() * 0.14);

    // Generate snapshot waveform
    final waveform = List.generate(32, (i) {
      return (0.3 + 0.6 * sin(i * 0.4).abs()).clamp(0.1, 1.0);
    });

    return AnimalSound(
      id: _uuid.v4(),
      animalSpecies: species,
      soundType: chosenSound,
      timestamp: DateTime.now(),
      duration: Duration(milliseconds: 1000 + _random.nextInt(1500)),
      confidence: double.parse(confidence.toStringAsFixed(2)),
      predictedIntent: intent.intentEn,
      tamilInterpretation: tamilText,
      waveformPoints: waveform,
    );
  }
}
