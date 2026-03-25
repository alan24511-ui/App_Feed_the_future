import 'package:flutter/material.dart';

class Notificacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notificaciones")),

      body: const Center(
        child: Text("No hay notificaciones aún"),
      ),
    );
  }
}