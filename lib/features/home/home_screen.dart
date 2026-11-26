import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/routes.dart';
import '../../core/constants/app_constants.dart';
import '../../core/permissions/permission_service.dart';
import '../../core/providers/service_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isInitializing = false;

  Future<void> _handleStartCommunication() async {
    setState(() => _isInitializing = true);

    final permissionService = ref.read(permissionServiceProvider);
    final micStatus = await permissionService.requestMicrophonePermission();
    final cameraStatus = await permissionService.requestCameraPermission();

    if (!mounted) return;
    setState(() => _isInitializing = false);

    if (micStatus == PermissionStatusType.denied &&
        cameraStatus == PermissionStatusType.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Microphone and camera permissions are needed to detect animals and listen to sounds.',
          ),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () => permissionService.openAppSettings(),
          ),
        ),
      );
      return;
    }

    // Initialize audio input & camera, start animal detection
    final cameraService = ref.read(cameraServiceProvider);
    await cameraService.initializeCamera();
    await cameraService.startStream();

    if (mounted) {
      Navigator.of(context).pushNamed(AppRoutes.nearbyAnimals);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('🐾', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 10),
            const Text(
              'faunanova-ai',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Hero Banner Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            const Color(0xFF1E293B),
                            const Color(0xFF0F3E35),
                          ]
                        : [
                            const Color(0xFFECFDF5),
                            const Color(0xFFD1FAE5),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black26 : Colors.green.withValues(alpha: 0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF10B981),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'AI Acoustic & Vision Engine',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Real-Time Animal\nCommunication',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                        color: isDark ? Colors.white : const Color(0xFF064E3B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppConstants.appDescription,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey.shade300 : const Color(0xFF047857),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'விலங்குகளின் ஒலிகளைப் பகுப்பாய்வு செய்து அவற்றின் தேவைகளை தமிழில் புரிந்து கொள்ளுங்கள்.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Supported Animals Row
              Text(
                'Supported Species (ஆதரிக்கப்படும் விலங்குகள்)',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildSpeciesChip('🐕 Dog', 'நாய்', context),
                    _buildSpeciesChip('🐈 Cat', 'பூனை', context),
                    _buildSpeciesChip('🐄 Cow', 'மாடு', context),
                    _buildSpeciesChip('🐦 Bird', 'பறவை', context),
                    _buildSpeciesChip('🐐 Goat', 'ஆடு', context),
                    _buildSpeciesChip('🐘 Elephant', 'யானை', context),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // PRIMARY CTA BUTTON: START COMMUNICATION
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _isInitializing ? null : _handleStartCommunication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shadowColor: const Color(0xFF059669).withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: _isInitializing
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 14),
                            Text(
                              'INITIALIZING CAMERA & MIC...',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.sensors_rounded, size: 26),
                            SizedBox(width: 12),
                            Text(
                              'START COMMUNICATION',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 28),

              // Secondary Options Section
              Text(
                'Explore & Options',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildSecondaryCard(
                      context,
                      icon: Icons.history_rounded,
                      title: 'History',
                      titleTa: 'வரலாறு',
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.history),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSecondaryCard(
                      context,
                      icon: Icons.tune_rounded,
                      title: 'Settings',
                      titleTa: 'அமைப்புகள்',
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.settings),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSecondaryCard(
                      context,
                      icon: Icons.info_outline_rounded,
                      title: 'About',
                      titleTa: 'பற்றி',
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.about),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Scientific Disclaimer Footer Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.amber.withValues(alpha: 0.08)
                      : Colors.amber.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.science_outlined,
                      size: 20,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        AppConstants.scientificDisclaimer,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpeciesChip(String nameEn, String nameTa, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            nameEn,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Text(
            nameTa,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String titleTa,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 26, color: theme.colorScheme.primary),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Text(
              titleTa,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
