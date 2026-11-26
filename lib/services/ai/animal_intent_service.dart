import '../../models/animal.dart';
import '../../models/animal_intent.dart';

abstract class AnimalIntentService {
  /// Predicts the possible intent and emotional state based on species and sound type
  Future<AnimalIntent> predictIntent({
    required AnimalSpecies species,
    required String soundType,
    Map<String, dynamic>? acousticContext,
  });

  /// Returns common intents for a given species
  List<AnimalIntent> getSpeciesIntents(AnimalSpecies species);
}
