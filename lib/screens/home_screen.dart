import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/database_service.dart';

import 'registrar_comida.dart';
import 'recetas.dart';
import 'perfil.dart';
import 'mascota.dart';
import 'ajustes.dart';
import 'notificacion.dart';

class HomeScreen extends StatefulWidget {
  final String nombre;
  final double imc;

  const HomeScreen({
    super.key,
    required this.nombre,
    required this.imc,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  String metaUsuario = "mantener";
  double metaCalorias = 2200;

  @override
  void initState() {
    super.initState();
    cargarMeta();
  }

  void cargarMeta() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();

      setState(() {
        metaUsuario = doc['metaSeleccionada'] ?? "mantener";
        metaCalorias = (doc['caloriasMeta'] ?? 2200).toDouble();
      });
    }
  }

  Color getPrimaryColor() {
    switch (metaUsuario) {
      case "perder_peso":
        return Colors.green;
      case "ganar_masa":
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  String getMensajeMeta() {
    switch (metaUsuario) {
      case "perder_peso":
        return "🔥 Quema grasa activa";
      case "ganar_masa":
        return "💪 Modo volumen activo";
      default:
        return "⚖️ Equilibrio saludable";
    }
  }

  Widget cardWidget(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  Widget grafica(Map<String, double> data) {
    double desayuno = data["Desayuno"] ?? 0;
    double comida = data["Comida"] ?? 0;
    double cena = data["Cena"] ?? 0;

    double total = desayuno + comida + cena;

    double d = total == 0 ? 0 : desayuno / total;
    double c = total == 0 ? 0 : comida / total;
    double n = total == 0 ? 0 : cena / total;

    return Column(
      children: [
        const SizedBox(height: 10),

        SizedBox(
          height: 260,
          width: 260,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 260,
                width: 260,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 20,
                  color: Colors.grey.shade200,
                ),
              ),
              SizedBox(
                height: 260,
                width: 260,
                child: CircularProgressIndicator(
                  value: d,
                  strokeWidth: 20,
                  color: Colors.orange,
                ),
              ),
              SizedBox(
                height: 260,
                width: 260,
                child: CircularProgressIndicator(
                  value: c,
                  strokeWidth: 20,
                  color: Colors.green,
                ),
              ),
              SizedBox(
                height: 260,
                width: 260,
                child: CircularProgressIndicator(
                  value: n,
                  strokeWidth: 20,
                  color: Colors.blue,
                ),
              ),
              Text(
                "${total.toStringAsFixed(0)} kcal",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        Wrap(
          spacing: 20,
          children: const [
            _Legend(color: Colors.orange, text: "Desayuno"),
            _Legend(color: Colors.green, text: "Comida"),
            _Legend(color: Colors.blue, text: "Cena"),
          ],
        )
      ],
    );
  }

  Widget _homeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 90),
      child: Column(
        children: [

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: getPrimaryColor().withOpacity(0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(getMensajeMeta()),
          ),

          cardWidget(
            ListTile(
              leading: Icon(Icons.monitor_heart, color: getPrimaryColor()),
              title: Text("IMC: ${widget.imc.toStringAsFixed(1)}"),
            ),
          ),

          // 🔥 CALORÍAS + PROGRESO + MASCOTA
          StreamBuilder<double>(
            stream: DatabaseService.caloriasHoyStream(),
            builder: (context, snapshot) {
              final total = snapshot.data ?? 0;
              final progreso = total / metaCalorias;

              return Column(
                children: [

                  // 🐶 MASCOTA EN HOME (PRO LEVEL)
                  Mascota(
                    calorias: total,
                    meta: metaCalorias,
                  ),

                  cardWidget(
                    Column(
                      children: [
                        const Text("Calorías de hoy"),
                        Text(
                          total.toStringAsFixed(0),
                          style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  cardWidget(
                    Column(
                      children: [
                        const Text("Progreso diario"),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: progreso > 1 ? 1 : progreso,
                          backgroundColor: Colors.grey.shade200,
                          valueColor:
                          AlwaysStoppedAnimation(getPrimaryColor()),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${total.toStringAsFixed(0)} / ${metaCalorias.toStringAsFixed(0)} kcal",
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          StreamBuilder<Map<String, double>>(
            stream: DatabaseService.caloriasPorTipoStream(),
            builder: (context, snapshot) {
              final data = snapshot.data ?? {
                "Desayuno": 0,
                "Comida": 0,
                "Cena": 0,
              };

              return cardWidget(grafica(data));
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _homeContent(),
      RegistrarComida(),
      Recetas(),

      // 🐶 MASCOTA TAB CORREGIDA
      StreamBuilder<double>(
        stream: DatabaseService.caloriasHoyStream(),
        builder: (context, snapshot) {
          final total = snapshot.data ?? 0;

          return Mascota(
            calorias: total,
            meta: metaCalorias,
          );
        },
      ),

      Perfil(),
      Ajustes(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Hola ${widget.nombre}"),
        backgroundColor: getPrimaryColor(),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Notificacion()),
              );
            },
          )
        ],
      ),

      body: screens[_index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        selectedItemColor: getPrimaryColor(),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Comida"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Recetas"),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: "Mascota"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Ajustes"),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;

  const _Legend({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(text),
      ],
    );
  }
}