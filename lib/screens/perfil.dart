import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'meta_screen.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final user = FirebaseAuth.instance.currentUser;

  final nombreCtrl = TextEditingController();
  final apellidoCtrl = TextEditingController();
  final edadCtrl = TextEditingController();
  final pesoCtrl = TextEditingController();
  final alturaCtrl = TextEditingController();

  bool editando = false;

  Future<Map<String, dynamic>> cargarDatos() async {
    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user!.uid)
        .get();

    final data = doc.data()!;

    nombreCtrl.text = data['nombre'] ?? "";
    apellidoCtrl.text = data['apellido'] ?? "";
    edadCtrl.text = data['edad'].toString();
    pesoCtrl.text = data['peso'].toString();
    alturaCtrl.text = data['altura'].toString();

    return data;
  }

  Future<void> guardar() async {
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user!.uid)
        .update({
      "nombre": nombreCtrl.text,
      "apellido": apellidoCtrl.text,
      "edad": int.parse(edadCtrl.text),
      "peso": double.parse(pesoCtrl.text),
      "altura": double.parse(alturaCtrl.text),
    });

    setState(() => editando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Perfil actualizado")),
    );
  }

  Widget campo(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      enabled: editando,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

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
        body: Center(child: Text("No hay usuario")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text("Perfil"),
        actions: [
          IconButton(
            icon: Icon(editando ? Icons.save : Icons.edit),
            onPressed: () {
              if (editando) {
                guardar();
              } else {
                setState(() => editando = true);
              }
            },
          )
        ],
      ),

      body: FutureBuilder<Map<String, dynamic>>(
        future: cargarDatos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          final meta =
          convertirMeta(data['metaSeleccionada'] ?? "mantener");
          final calorias = data['caloriasMeta'] ?? 2200;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [

                // HEADER
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.person,
                            size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${data['nombre']} ${data['apellido']}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(user!.email ?? ""),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // CAMPOS
                campo("Nombre", nombreCtrl),
                const SizedBox(height: 10),
                campo("Apellido", apellidoCtrl),
                const SizedBox(height: 10),
                campo("Edad", edadCtrl),
                const SizedBox(height: 10),
                campo("Peso (kg)", pesoCtrl),
                const SizedBox(height: 10),
                campo("Altura (m)", alturaCtrl),

                const SizedBox(height: 20),

                // META
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Meta nutricional",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text("Objetivo: $meta"),
                      Text("Calorías: $calorias kcal"),
                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            // 🔥 abre pantalla de meta
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MetaScreen(),
                              ),
                            );

                            // 🔥 refresca datos al volver
                            setState(() {});
                          },
                          child: const Text("Cambiar objetivo"),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // LOGOUT
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
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
}