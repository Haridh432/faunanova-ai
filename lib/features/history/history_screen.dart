import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/animal.dart';
import '../../models/communication_session.dart';
import '../../widgets/confidence_indicator.dart';
import 'history_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filtered = state.filterSpecies == null
        ? state.interactions
        : state.interactions.where((i) => i.species == state.filterSpecies).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Communication History',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'உரையாடல் வரலாறு',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          if (state.interactions.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Clear History',
              onPressed: () => _showClearDialog(context, ref),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Bar
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                children: [
                  FilterChip(
                    label: const Text('All (அனைத்தும்)'),
                    selected: state.filterSpecies == null,
                    onSelected: (_) =>
                        ref.read(historyProvider.notifier).filterBySpecies(null),
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
                          ref.read(historyProvider.notifier).filterBySpecies(
                                selected ? species : null,
                              );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Interactions List
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.builder(
                          itemCount: filtered.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemBuilder: (context, index) {
                            final item = filtered[index];
                            return _buildHistoryItem(context, item, ref, isDark);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    CommunicationInteraction item,
    WidgetRef ref,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    final timeStr = DateFormat('MMM d, hh:mm a').format(item.timestamp);
    final isAnimalToHuman = item.type == InteractionType.animalToHuman;

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) {
        ref.read(historyProvider.notifier).deleteItem(item.id);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Animal, Type, Time
            Row(
              children: [
                Text(item.species.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Text(
                  item.species.displayNameEn,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isAnimalToHuman
                        ? const Color(0xFF10B981).withValues(alpha: 0.15)
                        : Colors.blue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isAnimalToHuman ? 'Animal Sound' : 'Spoken Speech',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isAnimalToHuman ? const Color(0xFF10B981) : Colors.blue,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  timeStr,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Sound or Speech Input
            if (item.soundType != null) ...[
              Text(
                'Sound: ${item.soundType}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
              ),
            ] else if (item.humanSpeechText != null) ...[
              Text(
                'Human Speech: "${item.humanSpeechText}"',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

            const SizedBox(height: 4),

            // Prediction / Intent
            Row(
              children: [
                const Text(
                  'Intent: ',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  item.predictedIntent,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Tamil Interpretation
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF064E3B).withValues(alpha: 0.3)
                    : const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '"${item.tamilInterpretation}"',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF064E3B),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Confidence Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'AI Confidence:',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                ConfidenceIndicator(
                  confidence: item.confidence,
                  compact: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.history_toggle_off, size: 64, color: Colors.grey),
            const SizedBox(height: 14),
            const Text(
              'No Interaction History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Interactions and communication interpretations with animals will be recorded here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            const Text(
              'விலங்குகளுடனான உரையாடல்கள் இங்கே சேமிக்கப்படும்.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear History?'),
        content: const Text(
          'This will remove all saved animal interactions from local storage.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              ref.read(historyProvider.notifier).clearAll();
              Navigator.of(ctx).pop();
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
