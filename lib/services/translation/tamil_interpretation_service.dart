import '../../models/animal.dart';
import '../../models/animal_intent.dart';

abstract class TamilInterpretationService {
  /// Translates and formats the predicted intent and behavior in Tamil
  String getTamilInterpretation({
    required AnimalSpecies species,
    required IntentCategory category,
    required String soundType,
  });

  /// Returns practical care/response advice in Tamil
  String getTamilAdvice({
    required AnimalSpecies species,
    required IntentCategory category,
  });

  /// Translates human speech intent into Tamil display
  String getTamilHumanIntent(String intentKey);
}
