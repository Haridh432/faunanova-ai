import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/providers/service_providers.dart';

class SettingsState {
  final String language; // 'ta' for Tamil (default), 'en' for English
  final AiProcessingMode aiMode;
  final bool soundOutputEnabled;
  final bool hapticsEnabled;
  final bool cameraDetectionEnabled;
  final double micSensitivity; // 0.0 - 1.0

  const SettingsState({
    this.language = 'ta',
    this.aiMode = AiProcessingMode.auto,
    this.soundOutputEnabled = true,
    this.hapticsEnabled = true,
    this.cameraDetectionEnabled = true,
    this.micSensitivity = 0.8,
  });

  SettingsState copyWith({
    String? language,
    AiProcessingMode? aiMode,
    bool? soundOutputEnabled,
    bool? hapticsEnabled,
    bool? cameraDetectionEnabled,
    double? micSensitivity,
  }) {
    return SettingsState(
      language: language ?? this.language,
      aiMode: aiMode ?? this.aiMode,
      soundOutputEnabled: soundOutputEnabled ?? this.soundOutputEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      cameraDetectionEnabled: cameraDetectionEnabled ?? this.cameraDetectionEnabled,
      micSensitivity: micSensitivity ?? this.micSensitivity,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final lang = prefs.getString(AppConstants.settingsLanguageKey) ?? 'ta';
    final aiIndex = prefs.getInt(AppConstants.settingsAiModeKey) ?? 2; // Auto
    final sound = prefs.getBool(AppConstants.settingsSoundOutputKey) ?? true;

    final aiMode = aiIndex >= 0 && aiIndex < AiProcessingMode.values.length
        ? AiProcessingMode.values[aiIndex]
        : AiProcessingMode.auto;

    return SettingsState(
      language: lang,
      aiMode: aiMode,
      soundOutputEnabled: sound,
    );
  }

  Future<void> setLanguage(String lang) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(AppConstants.settingsLanguageKey, lang);
    state = state.copyWith(language: lang);
  }

  Future<void> setAiMode(AiProcessingMode mode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(AppConstants.settingsAiModeKey, mode.index);
    state = state.copyWith(aiMode: mode);
  }

  Future<void> setSoundOutput(bool enabled) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(AppConstants.settingsSoundOutputKey, enabled);
    state = state.copyWith(soundOutputEnabled: enabled);
  }

  void toggleCameraDetection(bool enabled) {
    state = state.copyWith(cameraDetectionEnabled: enabled);
  }

  void setMicSensitivity(double val) {
    state = state.copyWith(micSensitivity: val);
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
