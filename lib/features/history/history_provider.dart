import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/communication_session.dart';
import '../../models/animal.dart';
import '../../core/providers/service_providers.dart';

class HistoryState {
  final List<CommunicationInteraction> interactions;
  final bool isLoading;
  final AnimalSpecies? filterSpecies;

  const HistoryState({
    this.interactions = const [],
    this.isLoading = true,
    this.filterSpecies,
  });

  HistoryState copyWith({
    List<CommunicationInteraction>? interactions,
    bool? isLoading,
    AnimalSpecies? filterSpecies,
  }) {
    return HistoryState(
      interactions: interactions ?? this.interactions,
      isLoading: isLoading ?? this.isLoading,
      filterSpecies: filterSpecies ?? this.filterSpecies,
    );
  }
}

class HistoryNotifier extends Notifier<HistoryState> {
  @override
  HistoryState build() {
    Future.microtask(() => loadHistory());
    return const HistoryState();
  }

  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true);
    final repo = ref.read(communicationRepositoryProvider);
    final list = await repo.getInteractions();
    state = state.copyWith(interactions: list, isLoading: false);
  }

  Future<void> deleteItem(String id) async {
    final repo = ref.read(communicationRepositoryProvider);
    await repo.deleteInteraction(id);
    await loadHistory();
  }

  Future<void> clearAll() async {
    final repo = ref.read(communicationRepositoryProvider);
    await repo.clearAllInteractions();
    state = state.copyWith(interactions: []);
  }

  void filterBySpecies(AnimalSpecies? species) {
    state = state.copyWith(filterSpecies: species);
  }
}

final historyProvider =
    NotifierProvider<HistoryNotifier, HistoryState>(HistoryNotifier.new);
