import 'animal.dart';

enum IntentCategory {
  alert,
  distress,
  fear,
  aggression,
  attentionSeeking,
  feedingRelated,
  contactCalling,
  socialInteraction,
  matingRelated,
  contentment,
  curious,
  unknown;

  String get key => name;
}

class AnimalIntent {
  final IntentCategory category;
  final AnimalSpecies species;
  final String intentEn;
  final String intentTa;
  final String behaviorDescriptionEn;
  final String behaviorDescriptionTa;
  final String recommendedResponseEn;
  final String recommendedResponseTa;
  final String signalFrequencyProfile;

  const AnimalIntent({
    required this.category,
    required this.species,
    required this.intentEn,
    required this.intentTa,
    required this.behaviorDescriptionEn,
    required this.behaviorDescriptionTa,
    required this.recommendedResponseEn,
    required this.recommendedResponseTa,
    required this.signalFrequencyProfile,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category.name,
      'species': species.name,
      'intentEn': intentEn,
      'intentTa': intentTa,
      'behaviorDescriptionEn': behaviorDescriptionEn,
      'behaviorDescriptionTa': behaviorDescriptionTa,
      'recommendedResponseEn': recommendedResponseEn,
      'recommendedResponseTa': recommendedResponseTa,
      'signalFrequencyProfile': signalFrequencyProfile,
    };
  }

  factory AnimalIntent.fromJson(Map<String, dynamic> json) {
    return AnimalIntent(
      category: IntentCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => IntentCategory.unknown,
      ),
      species: AnimalSpecies.values.firstWhere(
        (e) => e.name == json['species'],
        orElse: () => AnimalSpecies.dog,
      ),
      intentEn: json['intentEn'] as String,
      intentTa: json['intentTa'] as String,
      behaviorDescriptionEn: json['behaviorDescriptionEn'] as String,
      behaviorDescriptionTa: json['behaviorDescriptionTa'] as String,
      recommendedResponseEn: json['recommendedResponseEn'] as String,
      recommendedResponseTa: json['recommendedResponseTa'] as String,
      signalFrequencyProfile: json['signalFrequencyProfile'] as String,
    );
  }
}
