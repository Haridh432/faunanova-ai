import '../models/animal.dart';
import '../services/animal_detection/animal_detection_service.dart';

abstract class AnimalRepository {
  Future<List<Animal>> getNearbyAnimals();
  Stream<List<Animal>> watchNearbyAnimals();
  Future<Animal?> getAnimalById(String id);
  Future<void> refreshDetection();
}

class AnimalRepositoryImpl implements AnimalRepository {
  final AnimalDetectionService _detectionService;

  AnimalRepositoryImpl(this._detectionService);

  @override
  Future<List<Animal>> getNearbyAnimals() {
    return _detectionService.detectAnimals();
  }

  @override
  Stream<List<Animal>> watchNearbyAnimals() {
    return _detectionService.detectionStream;
  }

  @override
  Future<Animal?> getAnimalById(String id) async {
    final list = await _detectionService.detectAnimals();
    try {
      return list.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> refreshDetection() async {
    await _detectionService.startContinuousDetection();
  }
}
