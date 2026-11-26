import '../../models/animal.dart';

class ApiResponse<T> {
  final bool isSuccess;
  final T? data;
  final String? errorMessage;
  final int statusCode;

  const ApiResponse({
    required this.isSuccess,
    this.data,
    this.errorMessage,
    this.statusCode = 200,
  });

  factory ApiResponse.success(T data) =>
      ApiResponse(isSuccess: true, data: data);

  factory ApiResponse.failure(String error, {int code = 500}) =>
      ApiResponse(isSuccess: false, errorMessage: error, statusCode: code);
}

abstract class ApiService {
  /// Checks if backend AI endpoint is reachable
  Future<bool> checkHealth();

  /// Sends animal sound features to remote AI for classification
  Future<ApiResponse<Map<String, dynamic>>> analyzeSoundRemote({
    required AnimalSpecies species,
    required List<double> audioFeatures,
    required DateTime timestamp,
  });

  /// Sends visual frame to remote YOLO/Vision AI for species detection
  Future<ApiResponse<List<Map<String, dynamic>>>> detectAnimalsRemote({
    required dynamic imagePayload,
  });
}
