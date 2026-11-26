import '../../models/animal.dart';

abstract class AnimalDetectionService {
  /// Detects animals currently in camera frame or acoustic proximity
  Future<List<Animal>> detectAnimals();

  /// Identifies the species from an image frame or raw audio feature set
  Future<AnimalSpecies?> identifySpecies(dynamic inputData);

  /// Returns confidence level for a detected animal (0.0 to 1.0)
  double getDetectionConfidence(Animal animal);

  /// Computes approximate distance/proximity string
  String getApproximateLocation(Animal animal);

  /// Stream of real-time detection changes
  Stream<List<Animal>> get detectionStream;

  /// Starts continuous scan
  Future<void> startContinuousDetection();

  /// Stops continuous scan
  Future<void> stopContinuousDetection();
}
