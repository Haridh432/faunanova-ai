import '../../models/animal.dart';
import '../../models/animal_sound.dart';

abstract class SoundClassificationService {
  /// Classifies audio acoustic features into species-specific vocalization
  /// e.g. Dog -> "Bark", "Whimper", "Growl", "Howl", "Pant"
  /// e.g. Cat -> "Meow", "Purr", "Hiss", "Chirp", "Yowl"
  Future<AnimalSound> classifySound({
    required AnimalSpecies species,
    required List<double> audioFeatures,
  });

  /// Supported sound categories for a given species
  List<String> getSoundTypesForSpecies(AnimalSpecies species);
}
