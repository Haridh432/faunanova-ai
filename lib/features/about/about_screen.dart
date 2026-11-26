import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About faunanova-ai',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Brand Card
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Text('🐾', style: TextStyle(fontSize: 42)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'faunanova-ai',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Version 1.0.0 (Production Release)',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Listen. Understand. Communicate.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Vision
              _buildSectionTitle('Project Vision (நோக்கம்)'),
              const SizedBox(height: 8),
              _buildContentCard(
                isDark: isDark,
                child: const Text(
                  'AnimalTalk AI is engineered to help humans understand animal vocalizations and foster harmonious communication with domestic animals, companion pets, and wildlife. '
                  'By combining bio-acoustic spectral analysis and computer vision detection, the app bridges the understanding gap and provides meaningful interpretations in Tamil.',
                  style: TextStyle(height: 1.45),
                ),
              ),

              const SizedBox(height: 20),

              // Scientific Disclaimer
              _buildSectionTitle('Scientific Disclaimer (அறிவியல் விளக்கம்)'),
              const SizedBox(height: 8),
              _buildContentCard(
                isDark: isDark,
                borderColor: Colors.amber.withValues(alpha: 0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Probabilistic Behavioral Prediction',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.amber.shade200 : Colors.amber.shade900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppConstants.scientificDisclaimer,
                      style: const TextStyle(fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppConstants.scientificDisclaimerTa,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Architecture Info
              _buildSectionTitle('Modular Architecture (கட்டமைப்பு)'),
              const SizedBox(height: 8),
              _buildContentCard(
                isDark: isDark,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• Animal Detection Service (YOLO / MobileNet Vision ready)'),
                    SizedBox(height: 6),
                    Text('• Bio-Acoustic Audio Signal Analysis & Noise Reduction'),
                    SizedBox(height: 6),
                    Text('• Species-Specific Intent & Emotion Prediction Model'),
                    SizedBox(height: 6),
                    Text('• Tamil Interpretation & Care Guidance Engine'),
                    SizedBox(height: 6),
                    Text('• Human Speech-to-Intent Recognition (Tamil ta-IN)'),
                    SizedBox(height: 6),
                    Text('• Species-Calibrated Acoustic Communication Signal Synthesizer'),
                    SizedBox(height: 6),
                    Text('• Local History Storage & Cloud REST API Ready'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Supported Animals
              _buildSectionTitle('Supported Species'),
              const SizedBox(height: 8),
              _buildContentCard(
                isDark: isDark,
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('🐕 Dog (நாய்)'),
                        Text('🐈 Cat (பூனை)'),
                        Text('🐄 Cow (மாடு)'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('🐦 Bird (பறவை)'),
                        Text('🐐 Goat (ஆடு)'),
                        Text('🐘 Elephant (யானை)'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildContentCard({
    required Widget child,
    required bool isDark,
    Color? borderColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor ?? (isDark ? Colors.white12 : Colors.grey.shade200),
        ),
      ),
      child: child,
    );
  }
}
