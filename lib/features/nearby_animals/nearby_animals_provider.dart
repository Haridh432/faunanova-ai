import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/animal.dart';
import '../../core/providers/service_providers.dart';

class NearbyAnimalsState {
  final List<Animal> animals;
  final bool isLoading;
  final bool isScanning;
  final String? errorMessage;
  final AnimalSpecies? filterSpecies;

  const NearbyAnimalsState({
    this.animals = const [],
    this.isLoading = true,
    this.isScanning = false,
    this.errorMessage,
    this.filterSpecies,
  });

  NearbyAnimalsState copyWith({
    List<Animal>? animals,
    bool? isLoading,
    bool? isScanning,
    String? errorMessage,
    AnimalSpecies? filterSpecies,
  }) {
    return NearbyAnimalsState(
      animals: animals ?? this.animals,
      isLoading: isLoading ?? this.isLoading,
      isScanning: isScanning ?? this.isScanning,
      errorMessage: errorMessage,
      filterSpecies: filterSpecies ?? this.filterSpecies,
    );
  }
}

class NearbyAnimalsNotifier extends Notifier<NearbyAnimalsState> {
  StreamSubscription<List<Animal>>? _subscription;

  @override
  NearbyAnimalsState build() {
    ref.onDispose(() {
      _subscription?.cancel();
    });
    Future.microtask(() => initScan());
    return const NearbyAnimalsState();
  }

  Future<void> initScan() async {
    state = state.copyWith(isLoading: true, isScanning: true, errorMessage: null);

    try {
      final detectionService = ref.read(animalDetectionServiceProvider);
      await detectionService.startContinuousDetection();

      final initial = await detectionService.detectAnimals();
      state = state.copyWith(animals: initial, isLoading: false, isScanning: true);

      _subscription?.cancel();
      _subscription = detectionService.detectionStream.listen((updatedList) {
        state = state.copyWith(animals: updatedList);
      });
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isScanning: false,
        errorMessage: 'Unable to scan for animals. Please check camera and mic.',
      );
    }
  }

  void filterBySpecies(AnimalSpecies? species) {
    state = state.copyWith(filterSpecies: species);
  }

  Future<void> refresh() async {
    await initScan();
  }
}

final nearbyAnimalsProvider =
    NotifierProvider<NearbyAnimalsNotifier, NearbyAnimalsState>(
  NearbyAnimalsNotifier.new,
);
