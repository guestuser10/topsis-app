import 'package:flutter/material.dart';

class JsonCardWidget extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> jsonData;

  const JsonCardWidget({
    super.key,
    required this.title,
    required this.jsonData,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: jsonData.length,
        itemBuilder: (context, index) {
          final item = jsonData[index];
          final String itemName = item['nombre'] ?? 'Sin nombre';
          final Map<String, dynamic> itemData = item['data'] ?? {};

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 4.0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título del grupo
                    Center(
                    child: Text(
                      itemName.toUpperCase(),
                      style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                    ),
                  const SizedBox(height: 8.0),
                  // Características
                  ...itemData.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Expanded(
                            child: Center(
                            child: Text(
                            entry.key.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            ),
                            ),
                            ),
                          Expanded(
                          child: Center(
                            child: Text(
                            entry.value.toString(),
                            style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
