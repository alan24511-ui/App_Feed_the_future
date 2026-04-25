import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final user = FirebaseAuth.instance.currentUser;

  String convertirMeta(String meta) {
    switch (meta) {
      case "perder_peso":
        return "Perder peso";
      case "ganar_masa":
        return "Ganar masa muscular";
      default:
        return "Mantener peso";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No hay usuario logueado")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text("Perfil"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user!.uid)
            .get(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final metaTexto = convertirMeta(
            data['metaSeleccionada'] ?? "mantener",
          );

          final calorias = data['caloriasMeta'] ?? 2200;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [

                // 🔹 HEADER
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),

                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.person,
                            size: 50, color: Colors.white),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "${data['nombre']} ${data['apellido']}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        data['correo'] ?? user!.email,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 INFO PERSONAL
                _card(
                  title: "Información personal",
                  children: [
                    _item("Edad", "${data['edad']} años"),
                    _item("Sexo", data['sexo']),
                  ],
                ),

                // 🔹 DATOS FÍSICOS
                _card(
                  title: "Datos físicos",
                  children: [
                    _item("Peso", "${data['peso']} kg"),
                    _item("Altura", "${data['altura']} m"),
                    _item("IMC", data['imc'].toString()),
                  ],
                ),

                // 🔥 META (CORREGIDA)
                _card(
                  title: "Meta nutricional",
                  children: [
                    _item("Objetivo", metaTexto),
                    _item("Calorías diarias", "$calorias kcal"),
                  ],
                ),

                const SizedBox(height: 20),

                // 🔴 BOTÓN CERRAR SESIÓN
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),

                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();

                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                              (route) => false,
                        );
                      }
                    },

                    child: const Text("Cerrar sesión"),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // 🔹 CARD
  Widget _card({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  // 🔹 ITEM
  Widget _item(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.grey)),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}