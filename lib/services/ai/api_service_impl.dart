import 'dart:async';
import '../../models/animal.dart';
import 'api_service.dart';

class ApiServiceImpl implements ApiService {
  final String baseUrl;

  ApiServiceImpl({this.baseUrl = 'https://api.animaltalk.ai/v1'});

  @override
  Future<bool> checkHealth() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> analyzeSoundRemote({
    required AnimalSpecies species,
    required List<double> audioFeatures,
    required DateTime timestamp,
  }) async {
    // REST API client ready structure
    // When real backend is available:
    // final response = await http.post(Uri.parse('$baseUrl/sound/classify'), ...);
    await Future.delayed(const Duration(milliseconds: 400));

    return ApiResponse.success({
      'species': species.name,
      'sound_type': 'Bark',
      'possible_behavior': 'Alert / Attention',
      'tamil': 'எச்சரிக்கை',
      'confidence': 0.89,
      'timestamp': timestamp.toIso8601String(),
    });
  }

  @override
  Future<ApiResponse<List<Map<String, dynamic>>>> detectAnimalsRemote({
    required dynamic imagePayload,
  }) async {
    await Future.delayed(const Duration(milliseconds: 450));
    return ApiResponse.success([
      {
        'species': 'dog',
        'confidence': 0.94,
        'box': [100, 120, 300, 400],
      }
    ]);
  }
}
