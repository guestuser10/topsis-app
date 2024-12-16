import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:topsis/config/config.dart';
import './../providers/data_provider.dart';
import './../providers/features_provider.dart';
import 'package:flutter_podium/flutter_podium.dart';

class ResultsScreen extends ConsumerStatefulWidget {
  static const String name = 'Resultados';

  const ResultsScreen({super.key});

  @override
  ResultsScreenState createState() => ResultsScreenState();
}

class ResultsScreenState extends ConsumerState<ResultsScreen> {
  final Dio dio = Dio(); // Instancia de Dio
  Map<String, dynamic>? topsisResult; // Variable para almacenar el resultado
  bool isLoading = true; // Estado de carga inicializado en true
  List<String> top3Ranking = []; // Lista para almacenar los primeros 3 elementos del ranking

  @override
  void initState() {
    super.initState();
    // Ejecutar la consulta 500 ms después de entrar a la página
    Future.delayed(const Duration(milliseconds: 500), () async {
      final alternatives = ref.read(alternativaValoresProvider);
      final features = ref.read(featureWeightProvider);

      // Generar JSON dinámicamente
      final Map<String, dynamic> generatedJson = {
        "attributes": features.map((f) => f.feature).toList(),
        "candidates": alternatives.map((a) => a.alternativa).toList(),
        "weights": features.map((f) => f.weight).toList(),
        "benefit_attributes": features.map((f) => f.benefit).toList(),
        "raw_data": alternatives.map((a) => a.valores).toList(),
      };

      await _makePostRequest(generatedJson);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Topsis',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme().getcolor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ranking de Resultados',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (top3Ranking.isNotEmpty)
              Podium(
                firstPosition: Text(top3Ranking[0]),
                secondPosition: Text(top3Ranking.length > 1 ? top3Ranking[1] : "N/A"),
                thirdPosition: Text(top3Ranking.length > 2 ? top3Ranking[2] : "N/A"),
              ),
          ],
        ),
      ),
    );
  }

  // Método para realizar la consulta POST
  Future<void> _makePostRequest(Map<String, dynamic> json) async {
    setState(() {
      isLoading = true;
    });
    try {
      // Realizar la solicitud
      final response = await dio.post(
        'http://localhost:8000/topsis',
        data: jsonEncode(json),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      debugPrint(response.data['result'].toString());

      // Actualizar el resultado con la respuesta del servidor
      setState(() {
        topsisResult = response.data;
        top3Ranking = _extractRanking(topsisResult!);
      });

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resultados obtenidos correctamente')),
      );
    } catch (error) {
      // Manejar errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Método para extraer el ranking de la respuesta
  List<String> _extractRanking(Map<String, dynamic> json) {
    final result = json['result'] as String;
    final rankingText = "Las preferencias en orden descendente son: ";
    final startIndex = result.indexOf(rankingText);
    if (startIndex != -1) {
      final rankingString = result.substring(startIndex + rankingText.length).trim();
      final rankingList = rankingString.split(',').map((e) => e.trim()).toList();
      return rankingList.take(3).toList(); // Tomar los primeros 3 elementos
    }
    return [];
  }

  // Método para formatear JSON
  String _formatJson(Map<String, dynamic> json) {
    return const JsonEncoder.withIndent('  ').convert(json);
  }
}