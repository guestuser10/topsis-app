import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlternativaValores {
  final String alternativa;
  final List<double> valores;

  AlternativaValores({required this.alternativa, required this.valores});
}

class AlternativaValoresNotifier extends Notifier<List<AlternativaValores>> {
  @override
  List<AlternativaValores> build() {
    return []; // Estado inicial vacío
  }

  // Método para agregar una alternativa con valores
  void addAlternativaValores(String alternativa, List<double> valores) {
    state = [
      ...state,
      AlternativaValores(alternativa: alternativa, valores: valores),
    ];
  }

  // Método para eliminar una alternativa por su nombre
  void removeAlternativa(String alternativa) {
    state = state.where((av) => av.alternativa != alternativa).toList();
  }

  // Método para limpiar todas las alternativas
  void clearAll() {
    state = [];
  }

  // Obtener lista de alternativas
  List<String> get alternativas => state.map((av) => av.alternativa).toList();

  // Obtener valores de una alternativa específica
  List<double>? getValores(String alternativa) {
    return state.firstWhere(
      (av) => av.alternativa == alternativa,
      orElse: () => AlternativaValores(alternativa: '', valores: []),
    ).valores;
  }
}

final alternativaValoresProvider =
    NotifierProvider<AlternativaValoresNotifier, List<AlternativaValores>>(
        () => AlternativaValoresNotifier());
