import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_screen.dart';

class MetaScreen extends StatelessWidget {
  const MetaScreen({super.key});

  Future<void> seleccionarMeta(BuildContext context, String meta) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      double caloriasMeta;

      if (meta == "perder_peso") {
        caloriasMeta = 1800;
      } else if (meta == "mantener") {
        caloriasMeta = 2200;
      } else {
        caloriasMeta = 2600;
      }

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .update({
        'metaSeleccionada': meta,
        'caloriasMeta': caloriasMeta,
      });

      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();

      final data = doc.data()!;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            nombre: data['nombre'],
            imc: data['imc'],
          ),
        ),
            (route) => false,
      );
    }
  }

  Widget card(BuildContext context, String titulo, String desc,
      IconData icon, String meta) {
    return GestureDetector(
      onTap: () => seleccionarMeta(context, meta),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade300,
              Colors.green.shade600,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 35),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    desc,
                    style: const TextStyle(color: Colors.white70),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const Text("Tu objetivo 🥗"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Elige tu meta calórica",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),

            card(context, "Perder peso", "1800 kcal/día",
                Icons.local_fire_department, "perder_peso"),

            card(context, "Mantener peso", "2200 kcal/día",
                Icons.balance, "mantener"),

            card(context, "Ganar masa muscular", "2600 kcal/día",
                Icons.fitness_center, "ganar_masa"),
          ],
        ),
      ),
    );
  }
}