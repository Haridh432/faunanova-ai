import 'dart:async';
import 'camera_service.dart';

class MockCameraService implements CameraService {
  bool _isInitialized = false;
  bool _isStreaming = false;

  @override
  bool get isInitialized => _isInitialized;

  @override
  bool get isStreaming => _isStreaming;

  @override
  Future<bool> initializeCamera() async {
    // Simulate optical sensor warm-up
    await Future.delayed(const Duration(milliseconds: 350));
    _isInitialized = true;
    return true;
  }

  @override
  Future<void> startStream() async {
    if (!_isInitialized) {
      await initializeCamera();
    }
    _isStreaming = true;
  }

  @override
  Future<void> stopStream() async {
    _isStreaming = false;
  }

  @override
  Future<void> dispose() async {
    _isStreaming = false;
    _isInitialized = false;
  }
}
