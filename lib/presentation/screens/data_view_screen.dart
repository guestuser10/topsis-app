import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:go_router/go_router.dart';
import 'package:topsis/config/theme/app_theme.dart';
import '../../config/router/app_router.dart';
import './../providers/data_provider.dart';
import './../providers/features_provider.dart';
import '../widgets/cards_widget.dart';// Importa tu Provider

class DataViewScreen extends StatelessWidget {
  static const String name = 'Datas';

  const DataViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Datos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme().getcolor,
        actions: [
            IconButton(
            icon: const Icon(Icons.arrow_forward, size: 30.0), 
            color: Colors.black,
            onPressed: () {
              appRouter.push('/results');
            },
            ),
        ],
      ),
      body: _DataView(),
    );
  }
}

class _DataView extends ConsumerWidget {
  final String title = 'Mi Lista de Datos';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featureWeights = ref.watch(featureWeightProvider);
    final alternativas = ref.watch(alternativaValoresProvider);

    // Construir el JSON dinámico
    final List<Map<String, dynamic>> jsonData = alternativas.map((alternativa) {
      final Map<String, dynamic> data = {};

      // Combina cada característica con su peso correspondiente
      for (int i = 0; i < featureWeights.length; i++) {
        if (i < alternativa.valores.length) {
          data[featureWeights[i].feature] = alternativa.valores[i];
        }
      }

      return {
        "nombre": alternativa.alternativa,
        "data": data,
      };
    }).toList();

    return Center(
      child: Scaffold(
        body: JsonCardWidget(
          title: title,
          jsonData: jsonData, // Pasar el JSON al widget
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const AddAlternativeForm(),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class AddAlternativeForm extends ConsumerStatefulWidget {
  const AddAlternativeForm({super.key});

  @override
  ConsumerState<AddAlternativeForm> createState() => _AddAlternativeFormState();
}

class _AddAlternativeFormState extends ConsumerState<AddAlternativeForm> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final Map<String, TextEditingController> controllers = {};

  @override
  void dispose() {
    // Liberar los controladores al destruir el widget
    nameController.dispose();
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featureWeights = ref.watch(featureWeightProvider);

    // Crear un TextEditingController por cada característica
    for (var feature in featureWeights) {
      controllers[feature.feature] = TextEditingController();
    }

    return Dialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Agregar Alternativa',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        // Campo para el nombre de la alternativa
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre de la Alternativa',
                            hintText: 'Ejemplo: Alternativa 1',
                          ),
                          maxLength: 50,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El nombre no puede estar vacío';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Campos de texto dinámicos para los valores
                        ...featureWeights.map((feature) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  feature.feature,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextFormField(
                                  controller: controllers[feature.feature],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: feature.feature,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'El valor no puede estar vacío';
                                    }
                                    final parsed = double.tryParse(value);
                                    if (parsed == null || parsed < 0) {
                                      return 'Debe ser un número válido mayor o igual a 0';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Botón para añadir alternativa
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    // Obtener el nombre de la alternativa
                    final alternativaNombre = nameController.text;

                    // Construir la lista de valores desde los controladores
                    final valores = controllers.values
                        .map((controller) => double.parse(controller.text))
                        .toList();

                    // Agregar la nueva alternativa al provider
                    ref
                        .read(alternativaValoresProvider.notifier)
                        .addAlternativaValores(alternativaNombre, valores);

                    // Cerrar el diálogo
                    Navigator.of(context).pop();

                    // Mostrar mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Alternativa "$alternativaNombre" añadida correctamente'),
                      ),
                    );
                  }
                },
                child: const Text('Añadir'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
