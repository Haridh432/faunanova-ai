import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../models/animal.dart';
import '../../models/animal_sound.dart';
import '../../models/communication_session.dart';
import '../../services/ai/animal_communication_signal_service.dart';
import '../../core/providers/service_providers.dart';

class CommunicationState {
  final Animal? selectedAnimal;
  final bool isListening;
  final bool isAnalyzing;
  final List<double> waveformPoints;
  final double currentAudioLevel;
  final AnimalSound? latestSound;
  final String? soundStatusText;
  final String? tamilInterpretation;
  final String? predictedIntent;
  final double? confidence;
  final String? adviceTamil;

  // Human to animal state
  final bool isRecordingHumanSpeech;
  final String humanSpeechText;
  final String? detectedHumanIntent;
  final AnimalSignalResult? generatedSignal;
  final bool isPlayingSignal;
  final bool isGeneratingSignal;

  // History of current active session
  final List<CommunicationInteraction> sessionInteractions;

  const CommunicationState({
    this.selectedAnimal,
    this.isListening = false,
    this.isAnalyzing = false,
    this.waveformPoints = const [],
    this.currentAudioLevel = 0.0,
    this.latestSound,
    this.soundStatusText,
    this.tamilInterpretation,
    this.predictedIntent,
    this.confidence,
    this.adviceTamil,
    this.isRecordingHumanSpeech = false,
    this.humanSpeechText = '',
    this.detectedHumanIntent,
    this.generatedSignal,
    this.isPlayingSignal = false,
    this.isGeneratingSignal = false,
    this.sessionInteractions = const [],
  });

  CommunicationState copyWith({
    Animal? selectedAnimal,
    bool? isListening,
    bool? isAnalyzing,
    List<double>? waveformPoints,
    double? currentAudioLevel,
    AnimalSound? latestSound,
    String? soundStatusText,
    String? tamilInterpretation,
    String? predictedIntent,
    double? confidence,
    String? adviceTamil,
    bool? isRecordingHumanSpeech,
    String? humanSpeechText,
    String? detectedHumanIntent,
    AnimalSignalResult? generatedSignal,
    bool? isPlayingSignal,
    bool? isGeneratingSignal,
    List<CommunicationInteraction>? sessionInteractions,
  }) {
    return CommunicationState(
      selectedAnimal: selectedAnimal ?? this.selectedAnimal,
      isListening: isListening ?? this.isListening,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      waveformPoints: waveformPoints ?? this.waveformPoints,
      currentAudioLevel: currentAudioLevel ?? this.currentAudioLevel,
      latestSound: latestSound ?? this.latestSound,
      soundStatusText: soundStatusText ?? this.soundStatusText,
      tamilInterpretation: tamilInterpretation ?? this.tamilInterpretation,
      predictedIntent: predictedIntent ?? this.predictedIntent,
      confidence: confidence ?? this.confidence,
      adviceTamil: adviceTamil ?? this.adviceTamil,
      isRecordingHumanSpeech: isRecordingHumanSpeech ?? this.isRecordingHumanSpeech,
      humanSpeechText: humanSpeechText ?? this.humanSpeechText,
      detectedHumanIntent: detectedHumanIntent ?? this.detectedHumanIntent,
      generatedSignal: generatedSignal ?? this.generatedSignal,
      isPlayingSignal: isPlayingSignal ?? this.isPlayingSignal,
      isGeneratingSignal: isGeneratingSignal ?? this.isGeneratingSignal,
      sessionInteractions: sessionInteractions ?? this.sessionInteractions,
    );
  }
}

class CommunicationNotifier extends Notifier<CommunicationState> {
  final _uuid = const Uuid();

  StreamSubscription<List<double>>? _waveformSub;
  StreamSubscription<double>? _levelSub;
  StreamSubscription<String>? _soundSub;
  StreamSubscription<String>? _speechSub;
  StreamSubscription<bool>? _signalPlaySub;

  @override
  CommunicationState build() {
    ref.onDispose(() {
      _cleanup();
    });
    return const CommunicationState();
  }

  void _cleanup() {
    _waveformSub?.cancel();
    _levelSub?.cancel();
    _soundSub?.cancel();
    _speechSub?.cancel();
    _signalPlaySub?.cancel();
  }

  void selectAnimal(Animal animal) {
    state = state.copyWith(
      selectedAnimal: animal,
      soundStatusText: 'Listening to ${animal.name}...',
    );
    startListeningToAnimal();
  }

  Future<void> startListeningToAnimal() async {
    final animal = state.selectedAnimal;
    if (animal == null) return;

    final audioService = ref.read(animalAudioServiceProvider);
    await audioService.startListening(species: animal.species.name);

    _waveformSub?.cancel();
    _waveformSub = audioService.waveformStream.listen((points) {
      state = state.copyWith(waveformPoints: points);
    });

    _levelSub?.cancel();
    _levelSub = audioService.audioLevelStream.listen((lvl) {
      state = state.copyWith(currentAudioLevel: lvl);
    });

    _soundSub?.cancel();
    _soundSub = audioService.soundEventStream.listen((soundName) {
      _processDetectedSound(soundName);
    });

    final signalService = ref.read(animalCommunicationSignalServiceProvider);
    _signalPlaySub?.cancel();
    _signalPlaySub = signalService.isPlayingStream.listen((playing) {
      state = state.copyWith(isPlayingSignal: playing);
    });

    state = state.copyWith(
      isListening: true,
      soundStatusText: 'Listening to ${animal.species.displayNameEn}...',
    );
  }

  Future<void> _processDetectedSound(String soundName) async {
    final animal = state.selectedAnimal;
    if (animal == null) return;

    state = state.copyWith(
      isAnalyzing: true,
      soundStatusText: 'Sound detected: $soundName. Analyzing...',
    );

    try {
      final audioService = ref.read(animalAudioServiceProvider);
      final features = await audioService.extractAcousticFeatures();

      final classificationService = ref.read(soundClassificationServiceProvider);
      final animalSound = await classificationService.classifySound(
        species: animal.species,
        audioFeatures: features,
      );

      final intentService = ref.read(animalIntentServiceProvider);
      final intent = await intentService.predictIntent(
        species: animal.species,
        soundType: animalSound.soundType,
      );

      final tamilService = ref.read(tamilInterpretationServiceProvider);
      final advice = tamilService.getTamilAdvice(
        species: animal.species,
        category: intent.category,
      );

      final interaction = CommunicationInteraction.fromAnimalSound(animalSound);

      // Save to repository
      await ref.read(communicationRepositoryProvider).saveInteraction(interaction);

      state = state.copyWith(
        isAnalyzing: false,
        latestSound: animalSound,
        soundStatusText: 'Sound analyzed: ${animalSound.soundType}',
        tamilInterpretation: animalSound.tamilInterpretation,
        predictedIntent: animalSound.predictedIntent,
        confidence: animalSound.confidence,
        adviceTamil: advice,
        sessionInteractions: [interaction, ...state.sessionInteractions],
      );
    } catch (e) {
      state = state.copyWith(
        isAnalyzing: false,
        soundStatusText: 'Unable to analyze sound clearly',
      );
    }
  }

  /// Interactive manual sound trigger for demonstration / user selection
  Future<void> triggerVocalization(String soundType) async {
    await _processDetectedSound(soundType);
  }

  // --- Human -> Animal flow ---

  Future<void> startHumanSpeech() async {
    final speechService = ref.read(speechRecognitionServiceProvider);
    state = state.copyWith(
      isRecordingHumanSpeech: true,
      humanSpeechText: 'Listening...',
      detectedHumanIntent: null,
      generatedSignal: null,
    );

    _speechSub?.cancel();
    _speechSub = speechService.textStream.listen((text) {
      state = state.copyWith(humanSpeechText: text);
    });

    await speechService.startListening(languageCode: 'ta-IN');
  }

  Future<void> stopHumanSpeechAndGenerateSignal({String? manualText}) async {
    final speechService = ref.read(speechRecognitionServiceProvider);
    final text = manualText ?? await speechService.stopListening();

    state = state.copyWith(
      isRecordingHumanSpeech: false,
      humanSpeechText: text,
      isGeneratingSignal: true,
    );

    final intent = speechService.detectHumanIntent(text);
    final animal = state.selectedAnimal;
    if (animal == null) return;

    final signalService = ref.read(animalCommunicationSignalServiceProvider);
    final signal = signalService.generateSignalForIntent(
      species: animal.species,
      humanIntent: intent,
    );

    final tamilService = ref.read(tamilInterpretationServiceProvider);
    final intentTa = tamilService.getTamilHumanIntent(intent);

    state = state.copyWith(
      isGeneratingSignal: false,
      detectedHumanIntent: intent,
      generatedSignal: signal,
    );

    // Automatically play synthesized signal
    await signalService.playSignal(signal);

    // Save interaction
    final interaction = CommunicationInteraction(
      id: _uuid.v4(),
      type: InteractionType.humanToAnimal,
      timestamp: DateTime.now(),
      species: animal.species,
      humanSpeechText: text,
      detectedHumanIntent: intent,
      generatedAnimalSignal: signal.signalType,
      predictedIntent: intent,
      tamilInterpretation: '$intentTa: ${signal.descriptionTa}',
      confidence: 0.94,
    );

    await ref.read(communicationRepositoryProvider).saveInteraction(interaction);
    state = state.copyWith(
      sessionInteractions: [interaction, ...state.sessionInteractions],
    );
  }

  Future<void> replaySignal() async {
    final signal = state.generatedSignal;
    if (signal != null) {
      final signalService = ref.read(animalCommunicationSignalServiceProvider);
      await signalService.playSignal(signal);
    }
  }

  Future<void> stopListening() async {
    final audioService = ref.read(animalAudioServiceProvider);
    await audioService.stopListening();
    _cleanup();
    state = state.copyWith(isListening: false, soundStatusText: 'Paused');
  }
}

final communicationProvider =
    NotifierProvider<CommunicationNotifier, CommunicationState>(
  CommunicationNotifier.new,
);
