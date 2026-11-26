class AppConstants {
  static const String appName = 'faunanova-ai';
  static const String appTagline = 'Listen. Understand. Communicate.';
  static const String appDescription =
      'Understand animal sounds and explore possible behaviors in Tamil using AI.';

  static const String scientificDisclaimer =
      'AnimalTalk AI does not claim to literally translate animal language. '
      'Our acoustic and computer vision AI models provide probabilistic predictions '
      'of animal intent, behavior, and emotional arousal state.';

  static const String scientificDisclaimerTa =
      'அனிமல்டாக் ஏஐ விலங்குகளின் குரல்களை நேரடி மொழியாக்கம் செய்வதாகக் கூறவில்லை. '
      'ஒலியியல் மற்றும் பார்வை மாதிரிகள் மூலம் விலங்கின் நடத்தை மற்றும் நோக்கத்தை மட்டுமே யூகிக்கிறது.';

  // Storage keys
  static const String historyStorageKey = 'animaltalk_interaction_history_v1';
  static const String settingsLanguageKey = 'animaltalk_language_pref';
  static const String settingsAiModeKey = 'animaltalk_ai_mode_pref';
  static const String settingsSoundOutputKey = 'animaltalk_sound_output_pref';
  static const String settingsSensitivityKey = 'animaltalk_sensitivity_pref';

  // API Config
  static const String defaultApiEndpoint = 'https://api.animaltalk.ai/v1';
}

enum AiProcessingMode {
  cloudAi,
  onDeviceAi,
  auto;

  String get displayNameEn {
    switch (this) {
      case AiProcessingMode.cloudAi:
        return 'Cloud AI';
      case AiProcessingMode.onDeviceAi:
        return 'On-device AI';
      case AiProcessingMode.auto:
        return 'Auto';
    }
  }

  String get displayNameTa {
    switch (this) {
      case AiProcessingMode.cloudAi:
        return 'கிளவுட் ஏஐ (Cloud AI)';
      case AiProcessingMode.onDeviceAi:
        return 'உள்ளமை ஏஐ (On-Device)';
      case AiProcessingMode.auto:
        return 'தானியங்கி (Auto)';
    }
  }
}
