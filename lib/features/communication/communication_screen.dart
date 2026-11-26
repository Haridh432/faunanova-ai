import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../models/animal.dart';
import '../../widgets/confidence_indicator.dart';
import '../../widgets/waveform.dart';
import '../../widgets/communication_button.dart';
import '../../widgets/live_status_badge.dart';
import 'communication_provider.dart';

class CommunicationScreen extends ConsumerStatefulWidget {
  const CommunicationScreen({super.key});

  @override
  ConsumerState<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends ConsumerState<CommunicationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(communicationProvider);
    final theme = Theme.of(context);

    final animal = state.selectedAnimal ??
        Animal(
          id: 'dog_default',
          species: AnimalSpecies.dog,
          name: 'Dog',
          emoji: '🐕',
          detectionConfidence: 0.94,
          proximity: 'Nearby (~1.5m)',
          soundStatus: AnimalSoundStatus.soundDetected,
          detectedAt: DateTime.now(),
        );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(animal.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Communicating with ${animal.species.displayNameEn}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${animal.species.displayNameTa} • ${animal.proximity}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              state.isListening ? Icons.mic : Icons.mic_off,
              color: state.isListening ? const Color(0xFF10B981) : Colors.grey,
            ),
            tooltip: state.isListening ? 'Microphone Active' : 'Microphone Paused',
            onPressed: () {
              if (state.isListening) {
                ref.read(communicationProvider.notifier).stopListening();
              } else {
                ref.read(communicationProvider.notifier).startListeningToAnimal();
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: theme.colorScheme.primary,
          tabs: const [
            Tab(
              icon: Icon(Icons.hearing_rounded, size: 20),
              text: 'Animal → Human\n(விலங்கு → மனிதன்)',
            ),
            Tab(
              icon: Icon(Icons.record_voice_over_rounded, size: 20),
              text: 'Human → Animal\n(மனிதன் → விலங்கு)',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: Animal -> Human Flow
          _buildAnimalToHumanTab(context, animal, state),

          // TAB 2: Human -> Animal Flow
          _buildHumanToAnimalTab(context, animal, state),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 1: ANIMAL -> HUMAN MODE
  // ==========================================
  Widget _buildAnimalToHumanTab(
    BuildContext context,
    Animal animal,
    CommunicationState state,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Live Status Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LiveStatusBadge(
                isListening: state.isListening,
                modeText: 'Mic Active',
              ),
              ConfidenceIndicator(
                confidence: animal.detectionConfidence,
                compact: true,
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Center Animated Sound & Waveform Visualizer Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.grey.shade200,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top animal status
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      animal.emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      animal.species.displayNameEn,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF10B981),
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Listening',
                            style: TextStyle(
                              color: Color(0xFF10B981),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Real-time Waveform Display
                WaveformWidget(
                  waveformPoints: state.waveformPoints,
                  isListening: state.isListening,
                  isAnalyzing: state.isAnalyzing,
                  height: 100,
                ),

                const SizedBox(height: 14),

                Text(
                  state.soundStatusText ?? 'Listening to ${animal.name}...',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: state.isAnalyzing
                        ? Colors.amber.shade700
                        : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                  ),
                ),

                if (state.isAnalyzing) ...[
                  const SizedBox(height: 8),
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Quick Vocalization Test Chips
          Row(
            children: [
              Text(
                'Simulate Audio Trigger:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade500,
                ),
              ),
              const Spacer(),
              const Text(
                'சோதனை ஒலிகள்',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _getQuickSoundOptions(animal.species).map((sound) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    avatar: const Icon(Icons.volume_up, size: 14),
                    label: Text(sound),
                    onPressed: () {
                      ref
                          .read(communicationProvider.notifier)
                          .triggerVocalization(sound);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 18),

          // Analysis Result Card (Tamil Interpretation & Intent)
          if (state.latestSound != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.35),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sound type tag
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Sound: ${state.latestSound!.soundType}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      Text(
                        'AI Interpretation',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'Possible behavior / Intent:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    state.predictedIntent ?? 'Alert / Attention',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Tamil Interpretation Highlight Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF064E3B).withValues(alpha: 0.4)
                          : const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF10B981).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tamil interpretation (தமிழ் விளக்கம்):',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF047857),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '"${state.tamilInterpretation ?? 'எச்சரிக்கை'}"',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF064E3B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Confidence Indicator
                  ConfidenceIndicator(
                    confidence: state.confidence ?? 0.87,
                  ),

                  // Advice in Tamil
                  if (state.adviceTamil != null) ...[
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.tips_and_updates_outlined,
                          size: 18,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.adviceTamil!,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ] else ...[
            // Empty state placeholder
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.graphic_eq_rounded,
                    size: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Listening to animal audio...',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'When ${animal.name} vocalizes, the AI will predict possible behavior and display the Tamil interpretation.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Scientific Disclaimer Note
          Text(
            AppConstants.scientificDisclaimer,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.5,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 2: HUMAN -> ANIMAL MODE
  // ==========================================
  Widget _buildHumanToAnimalTab(
    BuildContext context,
    Animal animal,
    CommunicationState state,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.grey.shade200,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.record_voice_over_rounded),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Speak to ${animal.name}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'Speak Tamil commands to transmit species-specific acoustic signals.',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Central Large Microphone Action Button
          CommunicationButton(
            isRecording: state.isRecordingHumanSpeech,
            isPlaying: state.isPlayingSignal,
            onTap: () {
              if (state.isRecordingHumanSpeech) {
                ref
                    .read(communicationProvider.notifier)
                    .stopHumanSpeechAndGenerateSignal();
              } else {
                ref.read(communicationProvider.notifier).startHumanSpeech();
              }
            },
          ),

          const SizedBox(height: 24),

          // Preset Tamil Phrase Buttons for instant testing
          Row(
            children: [
              Text(
                'Quick Spoken Phrases (தமிழில் கூற):',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildPresetSpeechChip('இங்கே வா', 'Come / Call'),
              _buildPresetSpeechChip('சாப்பிடு', 'Feeding / Eat'),
              _buildPresetSpeechChip('அமைதியாக இரு', 'Calm / Soothe'),
              _buildPresetSpeechChip('நில், வேண்டாம்', 'Stop / Caution'),
              _buildPresetSpeechChip('நல்ல பிள்ளை', 'Affection / Praise'),
            ],
          ),

          const SizedBox(height: 24),

          // Live Speech Recognition & Signal Generation Card
          if (state.humanSpeechText.isNotEmpty || state.generatedSignal != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.04),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Spoken Tamil transcript
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'User Speech (தமிழில் பேச்சு):',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      if (state.isRecordingHumanSpeech)
                        const Row(
                          children: [
                            SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Listening...',
                              style: TextStyle(fontSize: 11, color: Colors.redAccent),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '"${state.humanSpeechText}"',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  if (state.detectedHumanIntent != null) ...[
                    const SizedBox(height: 14),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    const Text(
                      'Intent Detected:',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      state.detectedHumanIntent!,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],

                  if (state.generatedSignal != null) ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    state.isPlayingSignal
                                        ? Icons.volume_up_rounded
                                        : Icons.sensors_rounded,
                                    size: 18,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    state.isPlayingSignal
                                        ? '🔊 Playing Signal'
                                        : 'Acoustic Signal Generated',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.replay_rounded, size: 20),
                                tooltip: 'Replay Signal',
                                onPressed: () {
                                  ref
                                      .read(communicationProvider.notifier)
                                      .replaySignal();
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            state.generatedSignal!.signalType,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            state.generatedSignal!.descriptionTa,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Species Signal Advisory
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 18, color: Colors.grey),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Signals are calibrated specifically for ${animal.species.displayNameEn} audio reception spectrum and safe sound levels.',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPresetSpeechChip(String phraseTa, String intentHint) {
    return ActionChip(
      avatar: const Icon(Icons.mic, size: 14),
      label: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(phraseTa, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          Text(intentHint, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
      onPressed: () {
        ref.read(communicationProvider.notifier).stopHumanSpeechAndGenerateSignal(
              manualText: phraseTa,
            );
      },
    );
  }

  List<String> _getQuickSoundOptions(AnimalSpecies species) {
    switch (species) {
      case AnimalSpecies.dog:
        return ['Bark (Alert)', 'Whimper', 'Play Growl', 'Howl'];
      case AnimalSpecies.cat:
        return ['Meow', 'Purr', 'Hiss', 'Chirp'];
      case AnimalSpecies.cow:
        return ['Low Moo', 'Resonant Call', 'Feeding Moo'];
      case AnimalSpecies.bird:
        return ['Alarm Trill', 'Territorial Chirp', 'Morning Song'];
      case AnimalSpecies.goat:
        return ['High Bleat', 'Low Grunt', 'Social Bleat'];
      case AnimalSpecies.elephant:
        return ['Trumpet Call', 'Infrasound Rumble', 'Gentle Roar'];
    }
  }
}
