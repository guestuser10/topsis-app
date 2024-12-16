import 'package:flutter_riverpod/flutter_riverpod.dart';

// Modelo de datos para manejar características y pesos
class FeatureWeight {
  final String feature;
  final double weight;
  final double benefit = 0;
  FeatureWeight({required this.feature, required this.weight});
}

// Notifier para manejar el estado
class FeatureWeightNotifier extends Notifier<List<FeatureWeight>> {
  @override
  List<FeatureWeight> build() {
    return [];
  }

  // Método para agregar datos
  void addFeatureWeight(String feature, double weight) {
    state = [
      ...state,
      FeatureWeight(feature: feature, weight: weight),
    ];
  }

  // Método para eliminar un elemento por característica
  void removeFeature(String feature) {
    state = state.where((fw) => fw.feature != feature).toList();
  }

  // Método para limpiar las listas
  void clearAll() {
    state = [];
  }

  // Obtener lista de características
  List<String> get features => state.map((fw) => fw.feature).toList();

  // Obtener lista de pesos
  List<double> get weights => state.map((fw) => fw.weight).toList();
}

// Provider para acceder al Notifier
final featureWeightProvider =
    NotifierProvider<FeatureWeightNotifier, List<FeatureWeight>>(
        () => FeatureWeightNotifier());
