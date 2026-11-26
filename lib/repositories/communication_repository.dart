import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/animal.dart';
import '../models/communication_session.dart';
import '../core/constants/app_constants.dart';

abstract class CommunicationRepository {
  Future<List<CommunicationInteraction>> getInteractions();
  Future<void> saveInteraction(CommunicationInteraction interaction);
  Future<void> deleteInteraction(String id);
  Future<void> clearAllInteractions();
}

class LocalCommunicationRepositoryImpl implements CommunicationRepository {
  final SharedPreferences _prefs;

  LocalCommunicationRepositoryImpl(this._prefs);

  @override
  Future<List<CommunicationInteraction>> getInteractions() async {
    final rawJson = _prefs.getString(AppConstants.historyStorageKey);
    if (rawJson == null || rawJson.isEmpty) {
      // Seed with some initial realistic interactions if first launch
      final initialSeed = _getSeedInteractions();
      await _saveList(initialSeed);
      return initialSeed;
    }

    try {
      final List<dynamic> decoded = jsonDecode(rawJson) as List<dynamic>;
      return decoded
          .map((item) => CommunicationInteraction.fromJson(item as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveInteraction(CommunicationInteraction interaction) async {
    final current = await getInteractions();
    current.insert(0, interaction);
    // Keep max 100 entries locally
    if (current.length > 100) {
      current.removeRange(100, current.length);
    }
    await _saveList(current);
  }

  @override
  Future<void> deleteInteraction(String id) async {
    final current = await getInteractions();
    current.removeWhere((item) => item.id == id);
    await _saveList(current);
  }

  @override
  Future<void> clearAllInteractions() async {
    await _prefs.remove(AppConstants.historyStorageKey);
  }

  Future<void> _saveList(List<CommunicationInteraction> list) async {
    final encoded = jsonEncode(list.map((e) => e.toJson()).toList());
    await _prefs.setString(AppConstants.historyStorageKey, encoded);
  }

  List<CommunicationInteraction> _getSeedInteractions() {
    final now = DateTime.now();
    return [
      CommunicationInteraction(
        id: 'seed_1',
        type: InteractionType.animalToHuman,
        timestamp: now.subtract(const Duration(hours: 1, minutes: 18)),
        species: AnimalSpecies.dog,
        soundType: 'Bark (Alert)',
        predictedIntent: 'Alert / Attention',
        tamilInterpretation: 'எச்சரிக்கை - சூழலில் மாற்றத்தைக் கவனித்துள்ளது',
        confidence: 0.89,
      ),
      CommunicationInteraction(
        id: 'seed_2',
        type: InteractionType.humanToAnimal,
        timestamp: now.subtract(const Duration(hours: 1, minutes: 16)),
        species: AnimalSpecies.dog,
        humanSpeechText: 'இங்கே வா',
        detectedHumanIntent: 'COME / CALL',
        generatedAnimalSignal: 'High-Pitch Friendly Whistle (1200Hz Sweep)',
        predictedIntent: 'Call / Approach',
        tamilInterpretation: 'இங்கே வா / அழைப்பு சமிக்ஞை ஒலித்தது',
        confidence: 0.95,
      ),
      CommunicationInteraction(
        id: 'seed_3',
        type: InteractionType.animalToHuman,
        timestamp: now.subtract(const Duration(hours: 3, minutes: 5)),
        species: AnimalSpecies.cat,
        soundType: 'Meow',
        predictedIntent: 'Attention Seeking / Greeting',
        tamilInterpretation: 'என் மீது கவனம் செலுத்துங்கள் / அன்பான வணக்கம்',
        confidence: 0.82,
      ),
    ];
  }
}
