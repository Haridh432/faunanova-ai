import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/routes.dart';
import '../../models/animal.dart';
import '../../widgets/animal_card.dart';
import '../communication/communication_provider.dart';
import 'nearby_animals_provider.dart';

class NearbyAnimalsScreen extends ConsumerStatefulWidget {
  const NearbyAnimalsScreen({super.key});

  @override
  ConsumerState<NearbyAnimalsScreen> createState() => _NearbyAnimalsScreenState();
}

class _NearbyAnimalsScreenState extends ConsumerState<NearbyAnimalsScreen> {
  bool _showCameraScanner = true;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(nearbyAnimalsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredList = state.filterSpecies == null
        ? state.animals
        : state.animals.where((a) => a.species == state.filterSpecies).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nearby Animals',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'அருகிலுள்ள விலங்குகள்',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showCameraScanner ? Icons.videocam : Icons.videocam_off_outlined,
              color: _showCameraScanner ? theme.colorScheme.primary : null,
            ),
            tooltip: 'Toggle Camera Sensor Preview',
            onPressed: () {
              setState(() => _showCameraScanner = !_showCameraScanner);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Rescan',
            onPressed: () => ref.read(nearbyAnimalsProvider.notifier).refresh(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Optical / Camera Detection Viewfinder Preview
            if (_showCameraScanner)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  children: [
                    // Grid / HUD overlay
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _ViewfinderOverlayPainter(
                          color: const Color(0xFF10B981).withValues(alpha: 0.25),
                        ),
                      ),
                    ),
                    // Detection Target Overlay Bounding Boxes
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF10B981),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.camera_alt_outlined,
                              size: 16,
                              color: Color(0xFF10B981),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'AI Optical Scanner Active • ${state.animals.length} In-Frame',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Live Sensor Indicators
                    Positioned(
                      top: 10,
                      left: 12,
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'LIVE SENSOR',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 12,
                      child: Text(
                        'Acoustic + Visual Fusion',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Subtitle Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select an animal to start communicating',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'உரையாடலைத் தொடங்க ஒரு விலங்கைத் தேர்ந்தெடுக்கவும்',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Species Filter Chips
            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  FilterChip(
                    label: const Text('All (அனைத்தும்)'),
                    selected: state.filterSpecies == null,
                    onSelected: (_) =>
                        ref.read(nearbyAnimalsProvider.notifier).filterBySpecies(null),
                  ),
                  const SizedBox(width: 8),
                  ...AnimalSpecies.values.map((species) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        avatar: Text(species.emoji),
                        label: Text(species.displayNameEn),
                        selected: state.filterSpecies == species,
                        onSelected: (selected) {
                          ref.read(nearbyAnimalsProvider.notifier).filterBySpecies(
                                selected ? species : null,
                              );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Detected Animals List
            Expanded(
              child: state.isLoading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Scanning microphone and camera for animals...'),
                        ],
                      ),
                    )
                  : filteredList.isEmpty
                      ? _buildNoAnimalsDetected(context)
                      : RefreshIndicator(
                          onRefresh: () =>
                              ref.read(nearbyAnimalsProvider.notifier).refresh(),
                          child: ListView.builder(
                            itemCount: filteredList.length,
                            padding: const EdgeInsets.only(bottom: 24),
                            itemBuilder: (context, index) {
                              final animal = filteredList[index];
                              return AnimalCard(
                                animal: animal,
                                onSelect: () {
                                  ref
                                      .read(communicationProvider.notifier)
                                      .selectAnimal(animal);
                                  Navigator.of(context).pushNamed(
                                    AppRoutes.communication,
                                  );
                                },
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoAnimalsDetected(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No animal detected',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Move closer to the animal or point the camera toward it.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            const Text(
              'விலங்கின் அருகே செல்லுங்கள் அல்லது கேமராவை விலங்கை நோக்கித் திருப்புங்கள்.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => ref.read(nearbyAnimalsProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again (மீண்டும் முயற்சிக்க)'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewfinderOverlayPainter extends CustomPainter {
  final Color color;

  _ViewfinderOverlayPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const cornerLength = 22.0;

    // Top-Left Corner
    canvas.drawLine(const Offset(14, 14), const Offset(14 + cornerLength, 14), paint);
    canvas.drawLine(const Offset(14, 14), const Offset(14, 14 + cornerLength), paint);

    // Top-Right Corner
    canvas.drawLine(Offset(size.width - 14, 14), Offset(size.width - 14 - cornerLength, 14), paint);
    canvas.drawLine(Offset(size.width - 14, 14), Offset(size.width - 14, 14 + cornerLength), paint);

    // Bottom-Left Corner
    canvas.drawLine(Offset(14, size.height - 14), Offset(14 + cornerLength, size.height - 14), paint);
    canvas.drawLine(Offset(14, size.height - 14), Offset(14, size.height - 14 - cornerLength), paint);

    // Bottom-Right Corner
    canvas.drawLine(Offset(size.width - 14, size.height - 14), Offset(size.width - 14 - cornerLength, size.height - 14), paint);
    canvas.drawLine(Offset(size.width - 14, size.height - 14), Offset(size.width - 14, size.height - 14 - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
