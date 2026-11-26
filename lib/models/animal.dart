enum AnimalSpecies {
  dog,
  cat,
  cow,
  bird,
  goat,
  elephant;

  String get displayNameEn {
    switch (this) {
      case AnimalSpecies.dog:
        return 'Dog';
      case AnimalSpecies.cat:
        return 'Cat';
      case AnimalSpecies.cow:
        return 'Cow';
      case AnimalSpecies.bird:
        return 'Bird';
      case AnimalSpecies.goat:
        return 'Goat';
      case AnimalSpecies.elephant:
        return 'Elephant';
    }
  }

  String get displayNameTa {
    switch (this) {
      case AnimalSpecies.dog:
        return 'நாய்';
      case AnimalSpecies.cat:
        return 'பூனை';
      case AnimalSpecies.cow:
        return 'பசு மாடு';
      case AnimalSpecies.bird:
        return 'பறவை';
      case AnimalSpecies.goat:
        return 'ஆடு';
      case AnimalSpecies.elephant:
        return 'யானை';
    }
  }

  String get emoji {
    switch (this) {
      case AnimalSpecies.dog:
        return '🐕';
      case AnimalSpecies.cat:
        return '🐈';
      case AnimalSpecies.cow:
        return '🐄';
      case AnimalSpecies.bird:
        return '🐦';
      case AnimalSpecies.goat:
        return '🐐';
      case AnimalSpecies.elephant:
        return '🐘';
    }
  }
}

enum DetectionMethod {
  camera,
  sound,
  combined,
}

enum AnimalSoundStatus {
  soundDetected,
  listening,
  silent,
}

class Animal {
  final String id;
  final AnimalSpecies species;
  final String name;
  final String emoji;
  final double detectionConfidence;
  final String proximity; // e.g. "Nearby (~1.5m)", "Close range", "In visual field"
  final DetectionMethod detectionMethod;
  final AnimalSoundStatus soundStatus;
  final DateTime detectedAt;

  const Animal({
    required this.id,
    required this.species,
    required this.name,
    required this.emoji,
    required this.detectionConfidence,
    required this.proximity,
    this.detectionMethod = DetectionMethod.combined,
    this.soundStatus = AnimalSoundStatus.soundDetected,
    required this.detectedAt,
  });

  Animal copyWith({
    String? id,
    AnimalSpecies? species,
    String? name,
    String? emoji,
    double? detectionConfidence,
    String? proximity,
    DetectionMethod? detectionMethod,
    AnimalSoundStatus? soundStatus,
    DateTime? detectedAt,
  }) {
    return Animal(
      id: id ?? this.id,
      species: species ?? this.species,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      detectionConfidence: detectionConfidence ?? this.detectionConfidence,
      proximity: proximity ?? this.proximity,
      detectionMethod: detectionMethod ?? this.detectionMethod,
      soundStatus: soundStatus ?? this.soundStatus,
      detectedAt: detectedAt ?? this.detectedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'species': species.name,
      'name': name,
      'emoji': emoji,
      'detectionConfidence': detectionConfidence,
      'proximity': proximity,
      'detectionMethod': detectionMethod.name,
      'soundStatus': soundStatus.name,
      'detectedAt': detectedAt.toIso8601String(),
    };
  }

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['id'] as String,
      species: AnimalSpecies.values.firstWhere(
        (e) => e.name == json['species'],
        orElse: () => AnimalSpecies.dog,
      ),
      name: json['name'] as String,
      emoji: json['emoji'] as String,
      detectionConfidence: (json['detectionConfidence'] as num).toDouble(),
      proximity: json['proximity'] as String,
      detectionMethod: DetectionMethod.values.firstWhere(
        (e) => e.name == json['detectionMethod'],
        orElse: () => DetectionMethod.combined,
      ),
      soundStatus: AnimalSoundStatus.values.firstWhere(
        (e) => e.name == json['soundStatus'],
        orElse: () => AnimalSoundStatus.soundDetected,
      ),
      detectedAt: DateTime.parse(json['detectedAt'] as String),
    );
  }
}
