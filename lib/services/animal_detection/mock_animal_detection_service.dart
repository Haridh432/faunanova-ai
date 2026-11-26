import 'dart:async';
import 'dart:math';
import '../../models/animal.dart';
import 'animal_detection_service.dart';

class MockAnimalDetectionService implements AnimalDetectionService {
  final _random = Random();
  final _controller = StreamController<List<Animal>>.broadcast();
  Timer? _timer;

  // Realistic mock initial detected animals
  List<Animal> _detectedAnimals = [
    Animal(
      id: 'detected_dog_1',
      species: AnimalSpecies.dog,
      name: 'Indian Pariah Dog',
      emoji: '🐕',
      detectionConfidence: 0.94,
      proximity: 'Nearby (~1.8m)',
      detectionMethod: DetectionMethod.combined,
      soundStatus: AnimalSoundStatus.soundDetected,
      detectedAt: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
    Animal(
      id: 'detected_cat_1',
      species: AnimalSpecies.cat,
      name: 'Domestic Shorthair Cat',
      emoji: '🐈',
      detectionConfidence: 0.88,
      proximity: 'Nearby (~3.2m)',
      detectionMethod: DetectionMethod.camera,
      soundStatus: AnimalSoundStatus.listening,
      detectedAt: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
    Animal(
      id: 'detected_cow_1',
      species: AnimalSpecies.cow,
      name: 'Kangayam Cattle',
      emoji: '🐄',
      detectionConfidence: 0.91,
      proximity: 'Nearby (~5.0m)',
      detectionMethod: DetectionMethod.sound,
      soundStatus: AnimalSoundStatus.soundDetected,
      detectedAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Animal(
      id: 'detected_bird_1',
      species: AnimalSpecies.bird,
      name: 'Common Myna',
      emoji: '🐦',
      detectionConfidence: 0.84,
      proximity: 'Nearby (~4.1m on branch)',
      detectionMethod: DetectionMethod.combined,
      soundStatus: AnimalSoundStatus.soundDetected,
      detectedAt: DateTime.now().subtract(const Duration(minutes: 7)),
    ),
    Animal(
      id: 'detected_goat_1',
      species: AnimalSpecies.goat,
      name: 'Black Bengal Goat',
      emoji: '🐐',
      detectionConfidence: 0.79,
      proximity: 'Vicinity (~7.5m)',
      detectionMethod: DetectionMethod.sound,
      soundStatus: AnimalSoundStatus.listening,
      detectedAt: DateTime.now().subtract(const Duration(minutes: 12)),
    ),
  ];

  @override
  Stream<List<Animal>> get detectionStream => _controller.stream;

  @override
  Future<List<Animal>> detectAnimals() async {
    // Simulate lightweight model inference delay
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_detectedAnimals);
  }

  @override
  Future<AnimalSpecies?> identifySpecies(dynamic inputData) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return AnimalSpecies.dog;
  }

  @override
  double getDetectionConfidence(Animal animal) {
    return animal.detectionConfidence;
  }

  @override
  String getApproximateLocation(Animal animal) {
    return animal.proximity;
  }

  @override
  Future<void> startContinuousDetection() async {
    _timer?.cancel();
    _controller.add(_detectedAnimals);

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      // Slightly fluctuate confidences to simulate live tracking
      _detectedAnimals = _detectedAnimals.map((animal) {
        final jitter = (_random.nextDouble() - 0.5) * 0.04;
        final newConf = (animal.detectionConfidence + jitter).clamp(0.70, 0.99);
        return animal.copyWith(detectionConfidence: double.parse(newConf.toStringAsFixed(2)));
      }).toList();

      _controller.add(List.unmodifiable(_detectedAnimals));
    });
  }

  @override
  Future<void> stopContinuousDetection() async {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    stopContinuousDetection();
    _controller.close();
  }
}
