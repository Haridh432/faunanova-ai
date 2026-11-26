import 'animal.dart';
import 'animal_sound.dart';

enum InteractionType {
  animalToHuman,
  humanToAnimal,
}

class CommunicationInteraction {
  final String id;
  final InteractionType type;
  final DateTime timestamp;
  final AnimalSpecies species;
  final String? soundType; // e.g. "Bark" or user speech
  final String? humanSpeechText;
  final String? detectedHumanIntent;
  final String? generatedAnimalSignal;
  final String predictedIntent;
  final String tamilInterpretation;
  final double confidence;
  final List<double> audioWaveform;

  const CommunicationInteraction({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.species,
    this.soundType,
    this.humanSpeechText,
    this.detectedHumanIntent,
    this.generatedAnimalSignal,
    required this.predictedIntent,
    required this.tamilInterpretation,
    required this.confidence,
    this.audioWaveform = const [],
  });

  factory CommunicationInteraction.fromAnimalSound(AnimalSound sound) {
    return CommunicationInteraction(
      id: sound.id,
      type: InteractionType.animalToHuman,
      timestamp: sound.timestamp,
      species: sound.animalSpecies,
      soundType: sound.soundType,
      predictedIntent: sound.predictedIntent,
      tamilInterpretation: sound.tamilInterpretation,
      confidence: sound.confidence,
      audioWaveform: sound.waveformPoints,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'species': species.name,
      'soundType': soundType,
      'humanSpeechText': humanSpeechText,
      'detectedHumanIntent': detectedHumanIntent,
      'generatedAnimalSignal': generatedAnimalSignal,
      'predictedIntent': predictedIntent,
      'tamilInterpretation': tamilInterpretation,
      'confidence': confidence,
      'audioWaveform': audioWaveform,
    };
  }

  factory CommunicationInteraction.fromJson(Map<String, dynamic> json) {
    return CommunicationInteraction(
      id: json['id'] as String,
      type: InteractionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => InteractionType.animalToHuman,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      species: AnimalSpecies.values.firstWhere(
        (e) => e.name == json['species'],
        orElse: () => AnimalSpecies.dog,
      ),
      soundType: json['soundType'] as String?,
      humanSpeechText: json['humanSpeechText'] as String?,
      detectedHumanIntent: json['detectedHumanIntent'] as String?,
      generatedAnimalSignal: json['generatedAnimalSignal'] as String?,
      predictedIntent: json['predictedIntent'] as String,
      tamilInterpretation: json['tamilInterpretation'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      audioWaveform: (json['audioWaveform'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
    );
  }
}

class CommunicationSession {
  final String id;
  final Animal animal;
  final DateTime startTime;
  final DateTime? endTime;
  final List<CommunicationInteraction> interactions;

  const CommunicationSession({
    required this.id,
    required this.animal,
    required this.startTime,
    this.endTime,
    required this.interactions,
  });

  CommunicationSession copyWith({
    String? id,
    Animal? animal,
    DateTime? startTime,
    DateTime? endTime,
    List<CommunicationInteraction>? interactions,
  }) {
    return CommunicationSession(
      id: id ?? this.id,
      animal: animal ?? this.animal,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      interactions: interactions ?? this.interactions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'animal': animal.toJson(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'interactions': interactions.map((i) => i.toJson()).toList(),
    };
  }

  factory CommunicationSession.fromJson(Map<String, dynamic> json) {
    return CommunicationSession(
      id: json['id'] as String,
      animal: Animal.fromJson(json['animal'] as Map<String, dynamic>),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      interactions: (json['interactions'] as List<dynamic>?)
              ?.map((i) => CommunicationInteraction.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
