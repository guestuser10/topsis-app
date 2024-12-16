import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
import 'package:topsis/config/config.dart';

class MenuScreen extends StatelessWidget {
  static const String name = 'Menu';

  const MenuScreen({super.key});
  
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
      body: const _MenuView(),
    );
  }
}

class _MenuView extends StatelessWidget {
  const _MenuView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón "Nueva Consulta"
            ElevatedButton(
              onPressed: () {
                appRouter.push('/features');
                debugPrint('Nueva Consulta presionado');
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 20.0,
                ),
              ),
              child: const Text(
                'Nueva Consulta',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            const SizedBox(height: 20.0), // Espacio entre los botones
            // Botón "Tutorial"
            ElevatedButton(
              onPressed: () {
                appRouter.push('/');
                debugPrint('Tutorial presionado');
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 20.0,
                ),
              ),
              child: const Text(
                'Tutorial',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
