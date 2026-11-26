import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/animal_detection/animal_detection_service.dart';
import '../../services/animal_detection/mock_animal_detection_service.dart';
import '../../services/audio/animal_audio_service.dart';
import '../../services/audio/mock_animal_audio_service.dart';
import '../../services/ai/sound_classification_service.dart';
import '../../services/ai/sound_classification_service_impl.dart';
import '../../services/ai/animal_intent_service.dart';
import '../../services/ai/animal_intent_service_impl.dart';
import '../../services/translation/tamil_interpretation_service.dart';
import '../../services/translation/tamil_interpretation_service_impl.dart';
import '../../services/speech/speech_recognition_service.dart';
import '../../services/speech/mock_speech_recognition_service.dart';
import '../../services/ai/animal_communication_signal_service.dart';
import '../../services/ai/animal_communication_signal_service_impl.dart';
import '../../services/camera/camera_service.dart';
import '../../services/camera/mock_camera_service.dart';
import '../../services/ai/api_service.dart';
import '../../services/ai/api_service_impl.dart';
import '../../core/permissions/permission_service.dart';
import '../../core/permissions/permission_service_impl.dart';
import '../../repositories/animal_repository.dart';
import '../../repositories/communication_repository.dart';

// SharedPreferences provider (initialized at main.dart)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize SharedPreferences in main()');
});

// Permission service
final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionServiceImpl();
});

// Camera service
final cameraServiceProvider = Provider<CameraService>((ref) {
  return MockCameraService();
});

// Detection service
final animalDetectionServiceProvider = Provider<AnimalDetectionService>((ref) {
  final service = MockAnimalDetectionService();
  ref.onDispose(() => service.dispose());
  return service;
});

// Audio service
final animalAudioServiceProvider = Provider<AnimalAudioService>((ref) {
  final service = MockAnimalAudioService();
  ref.onDispose(() => service.dispose());
  return service;
});

// Intent service
final animalIntentServiceProvider = Provider<AnimalIntentService>((ref) {
  return AnimalIntentServiceImpl();
});

// Tamil interpretation service
final tamilInterpretationServiceProvider = Provider<TamilInterpretationService>((ref) {
  return TamilInterpretationServiceImpl();
});

// Sound classification service
final soundClassificationServiceProvider = Provider<SoundClassificationService>((ref) {
  return SoundClassificationServiceImpl(
    intentService: ref.watch(animalIntentServiceProvider),
    tamilService: ref.watch(tamilInterpretationServiceProvider),
  );
});

// Speech recognition service
final speechRecognitionServiceProvider = Provider<SpeechRecognitionService>((ref) {
  final service = MockSpeechRecognitionService();
  ref.onDispose(() => service.dispose());
  return service;
});

// Animal signal service
final animalCommunicationSignalServiceProvider = Provider<AnimalCommunicationSignalService>((ref) {
  final service = AnimalCommunicationSignalServiceImpl();
  ref.onDispose(() => service.dispose());
  return service;
});

// API service
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiServiceImpl();
});

// Repositories
final animalRepositoryProvider = Provider<AnimalRepository>((ref) {
  return AnimalRepositoryImpl(ref.watch(animalDetectionServiceProvider));
});

final communicationRepositoryProvider = Provider<CommunicationRepository>((ref) {
  return LocalCommunicationRepositoryImpl(ref.watch(sharedPreferencesProvider));
});
