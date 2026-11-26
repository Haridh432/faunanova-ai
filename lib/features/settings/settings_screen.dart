import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/providers/service_providers.dart';
import '../history/history_provider.dart';
import 'settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'அமைப்புகள்',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          children: [
            // Section 1: Language
            _buildSectionHeader('Language & Localization (மொழி)'),
            _buildSettingsCard(
              isDark: isDark,
              child: Column(
                children: [
                  _buildOptionTile(
                    title: 'தமிழ் (Tamil - Default)',
                    subtitle: 'முழுமையான தமிழ் விளக்கம் மற்றும் ஆலோசனை',
                    isSelected: state.language == 'ta',
                    onTap: () => ref.read(settingsProvider.notifier).setLanguage('ta'),
                  ),
                  const Divider(height: 1),
                  _buildOptionTile(
                    title: 'English',
                    subtitle: 'English behavior descriptions',
                    isSelected: state.language == 'en',
                    onTap: () => ref.read(settingsProvider.notifier).setLanguage('en'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section 2: AI Processing Mode
            _buildSectionHeader('AI Processing Mode (ஏஐ செயலாக்க முறை)'),
            _buildSettingsCard(
              isDark: isDark,
              child: Column(
                children: [
                  _buildOptionTile(
                    title: 'Auto (தானியங்கி)',
                    subtitle: 'Balances on-device edge AI and high-precision Cloud models',
                    isSelected: state.aiMode == AiProcessingMode.auto,
                    onTap: () => ref.read(settingsProvider.notifier).setAiMode(AiProcessingMode.auto),
                  ),
                  const Divider(height: 1),
                  _buildOptionTile(
                    title: 'Cloud AI (கிளவுட் ஏஐ)',
                    subtitle: 'Uses high-fidelity deep neural network backend',
                    isSelected: state.aiMode == AiProcessingMode.cloudAi,
                    onTap: () => ref.read(settingsProvider.notifier).setAiMode(AiProcessingMode.cloudAi),
                  ),
                  const Divider(height: 1),
                  _buildOptionTile(
                    title: 'On-device AI (உள்ளமை ஏஐ)',
                    subtitle: 'Zero latency, private offline TFLite/ONNX models',
                    isSelected: state.aiMode == AiProcessingMode.onDeviceAi,
                    onTap: () => ref.read(settingsProvider.notifier).setAiMode(AiProcessingMode.onDeviceAi),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section 3: Hardware & Sensor Permissions
            _buildSectionHeader('Hardware Permissions (அனுமதிகள்)'),
            _buildSettingsCard(
              isDark: isDark,
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.mic, color: Color(0xFF10B981)),
                    title: Text('Microphone Access'),
                    subtitle: Text('Required for animal vocalization capture'),
                    trailing: Chip(
                      label: Text('Granted', style: TextStyle(color: Colors.white, fontSize: 11)),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.camera_alt, color: Color(0xFF10B981)),
                    title: Text('Camera Access'),
                    subtitle: Text('Required for visual species detection'),
                    trailing: Chip(
                      label: Text('Granted', style: TextStyle(color: Colors.white, fontSize: 11)),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.settings_applications_outlined),
                    title: const Text('Open App Settings'),
                    subtitle: const Text('Manage system OS permissions'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => ref.read(permissionServiceProvider).openAppSettings(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section 4: Audio & Output
            _buildSectionHeader('Audio & Acoustic Output (ஒலி வெளியீடு)'),
            _buildSettingsCard(
              isDark: isDark,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Play Animal Signals Through Speaker'),
                    subtitle: const Text('Outputs species-calibrated frequency tones'),
                    value: state.soundOutputEnabled,
                    onChanged: (val) {
                      ref.read(settingsProvider.notifier).setSoundOutput(val);
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Camera Sensor Object Detection'),
                    subtitle: const Text('Continuous visual bounding box scanning'),
                    value: state.cameraDetectionEnabled,
                    onChanged: (val) {
                      ref.read(settingsProvider.notifier).toggleCameraDetection(val);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section 5: Data & Privacy
            _buildSectionHeader('Data & Privacy (தரவு மற்றும் தனியுரிமை)'),
            _buildSettingsCard(
              isDark: isDark,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
                    title: const Text('Clear All Interaction History'),
                    subtitle: const Text('Delete all local recordings and session logs'),
                    onTap: () {
                      ref.read(historyProvider.notifier).clearAll();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Interaction history cleared.')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text('Privacy & Security Disclosures'),
                    subtitle: const Text('Audio is processed strictly for intent classification'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showPrivacyDialog(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Disclaimer Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
              ),
              child: Text(
                AppConstants.scientificDisclaimerTa,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.amber.shade200 : Colors.amber.shade900,
                  height: 1.35,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? const Color(0xFF10B981) : Colors.grey,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required Widget child, required bool isDark}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: child,
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Privacy & Data Governance'),
        content: const SingleChildScrollView(
          child: Text(
            '1. AnimalTalk AI only records audio while the communication screen is active.\n\n'
            '2. Audio waveforms are processed for feature extraction (spectral centroid, pitch, harmonics).\n\n'
            '3. Interaction history is stored exclusively on your device by default.\n\n'
            '4. No biometric human voice identification is performed or retained.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
