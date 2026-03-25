import 'package:flutter/material.dart';

class Ajustes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajustes")),

      body: ListView(
        children: const [
          ListTile(title: Text("Modo oscuro")),
          ListTile(title: Text("Notificaciones")),
        ],
      ),
    );
  }
}