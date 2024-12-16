import 'package:flutter/material.dart';
import 'package:topsis/config/config.dart';
import '../widgets/cards_widget.dart';
import '../providers/features_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeatureWeightsScreen extends ConsumerWidget {
  static const String name = 'Datos';

  const FeatureWeightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featureWeights = ref.watch(featureWeightProvider);

    // Convert featureWeights list to the required JSON format for JsonCardWidget
    final jsonData = featureWeights.map((featureWeight) {
      return {
        'nombre': featureWeight.feature,
        'data': {
          'peso': featureWeight.weight,
        },
      };
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Criterios y Pesos',
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
              final alternatives = ref.read(featureWeightProvider);
              if (alternatives.length >= 2) {
                appRouter.push('/data');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Debe haber al menos 2 elementos para continuar')),
                );
              }
            },
            ),
        ],
      ),
      body: JsonCardWidget(
        title: 'Mis Características',
        jsonData: jsonData,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Opens the dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const Dialog(
                insetPadding: EdgeInsets.all(16), // Optional: To control dialog's border spacing
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: FeatureWeightForm(),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


class FeatureWeightForm extends ConsumerWidget {
  const FeatureWeightForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController weightController = TextEditingController();

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,  // 30% height
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [         
          const Text(
            'Agregar Característica y Peso',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Form(
            key: formKey,
            child: Column(
              children: [
                // TextField para el nombre (característica)
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  maxLength: 25,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre no puede estar vacío';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // TextField para el peso
                TextFormField(
                  controller: weightController,
                  decoration: const InputDecoration(labelText: 'Peso'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El peso no puede estar vacío';
                    }
                    final weight = double.tryParse(value);
                    if (weight == null || weight < 1) {
                      return 'El peso debe ser mayor o igual a 1';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                // Botón de enviar
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      final name = nameController.text;
                      final weight = double.tryParse(weightController.text);

                      // Si la validación pasa, actualizamos el estado con Riverpod
                      if (weight != null) {
                        ref.read(featureWeightProvider.notifier).addFeatureWeight(name, weight);
                      }

                      // Cerrar el dialog
                      Navigator.of(context).pop();

                      // Mostrar un mensaje de éxito
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Datos agregados correctamente: $name, $weight')),
                      );
                    }
                  },
                  child: const Text('Enviar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

