enum PermissionStatusType {
  granted,
  denied,
  permanentlyDenied,
  restricted,
  notDetermined,
}

abstract class PermissionService {
  /// Requests microphone permission for audio recording
  Future<PermissionStatusType> requestMicrophonePermission();

  /// Requests camera permission for animal visual detection
  Future<PermissionStatusType> requestCameraPermission();

  /// Checks current microphone permission status
  Future<PermissionStatusType> checkMicrophonePermission();

  /// Checks current camera permission status
  Future<PermissionStatusType> checkCameraPermission();

  /// Opens app settings if permission is permanently denied
  Future<bool> openAppSettings();
}
