abstract class CameraService {
  /// Whether camera feed is initialized
  bool get isInitialized;

  /// Whether camera is actively scanning
  bool get isStreaming;

  /// Initializes camera hardware or simulated visual feed
  Future<bool> initializeCamera();

  /// Starts camera stream for object/animal detection
  Future<void> startStream();

  /// Stops camera stream
  Future<void> stopStream();

  /// Disposes camera resources
  Future<void> dispose();
}
