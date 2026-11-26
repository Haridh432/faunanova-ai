import 'animal.dart';

class AnimalSound {
  final String id;
  final AnimalSpecies animalSpecies;
  final String soundType; // e.g. "Bark", "Whimper", "Meow", "Purr", "Moo", "Chirp"
  final DateTime timestamp;
  final Duration duration;
  final double confidence;
  final String predictedIntent;
  final String tamilInterpretation;
  final String? audioPath;
  final List<double> waveformPoints;

  const AnimalSound({
    required this.id,
    required this.animalSpecies,
    required this.soundType,
    required this.timestamp,
    required this.duration,
    required this.confidence,
    required this.predictedIntent,
    required this.tamilInterpretation,
    this.audioPath,
    this.waveformPoints = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'animalSpecies': animalSpecies.name,
      'soundType': soundType,
      'timestamp': timestamp.toIso8601String(),
      'durationMs': duration.inMilliseconds,
      'confidence': confidence,
      'predictedIntent': predictedIntent,
      'tamilInterpretation': tamilInterpretation,
      'audioPath': audioPath,
      'waveformPoints': waveformPoints,
    };
  }

  factory AnimalSound.fromJson(Map<String, dynamic> json) {
    return AnimalSound(
      id: json['id'] as String,
      animalSpecies: AnimalSpecies.values.firstWhere(
        (e) => e.name == json['animalSpecies'],
        orElse: () => AnimalSpecies.dog,
      ),
      soundType: json['soundType'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      duration: Duration(milliseconds: json['durationMs'] as int? ?? 1200),
      confidence: (json['confidence'] as num).toDouble(),
      predictedIntent: json['predictedIntent'] as String,
      tamilInterpretation: json['tamilInterpretation'] as String,
      audioPath: json['audioPath'] as String?,
      waveformPoints: (json['waveformPoints'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
    );
  }
}
