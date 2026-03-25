import 'package:flutter/material.dart';

class Recetas extends StatelessWidget {
  final recetas = [
    {
      "nombre": "Ensalada saludable",
      "desc": "Lechuga, tomate, aguacate",
      "pasos": "1. Cortar\n2. Mezclar\n3. Servir"
    },
    {
      "nombre": "Pollo con arroz",
      "desc": "Proteína + energía",
      "pasos": "1. Cocinar pollo\n2. Hervir arroz\n3. Servir"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recetas")),

      body: ListView(
        children: recetas.map((r) {
          return Card(
            child: ListTile(
              title: Text(r["nombre"]!),
              subtitle: Text(r["desc"]!),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(r["nombre"]!),
                    content: Text(r["pasos"]!),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}