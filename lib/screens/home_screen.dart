import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
  double metaCalorias = 2200; // fallback seguro

  @override
  void initState() {
    super.initState();
    cargarMeta();
  }

  // 🔥 TRAER META REAL DESDE FIREBASE
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

  // 🎨 COLOR DINÁMICO
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
        return "🔥 Estás en modo quema grasa. Vamos con todo!";
      case "ganar_masa":
        return "💪 Modo volumen activo. Nutrición fuerte!";
      default:
        return "⚖️ Manteniendo equilibrio saludable.";
    }
  }

  Widget cardWidget(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
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
      child: child,
    );
  }

  Widget grafica(Map<String, double> data) {
    return SizedBox(
      height: 220,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: [
            PieChartSectionData(
              value: data["Desayuno"] ?? 0,
              color: Colors.orange,
              radius: 60,
              title: "Desayuno",
            ),
            PieChartSectionData(
              value: data["Comida"] ?? 0,
              color: Colors.green,
              radius: 60,
              title: "Comida",
            ),
            PieChartSectionData(
              value: data["Cena"] ?? 0,
              color: Colors.blue,
              radius: 60,
              title: "Cena",
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 🔥 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: getPrimaryColor().withOpacity(0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getMensajeMeta(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: getPrimaryColor(),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "En la app tienes recetas diseñadas para ayudarte 🥗",
                ),
              ],
            ),
          ),

          // IMC
          cardWidget(
            ListTile(
              leading: Icon(Icons.monitor_heart, color: getPrimaryColor()),
              title: Text("IMC: ${widget.imc.toStringAsFixed(1)}"),
              subtitle: const Text("Estado corporal"),
            ),
          ),

          // CALORÍAS HOY
          FutureBuilder<double>(
            future: DatabaseService.caloriasHoy(),
            builder: (context, snapshot) {
              final total = snapshot.data ?? 0;
              final progreso = total / metaCalorias;

              return Column(
                children: [
                  cardWidget(
                    Column(
                      children: [
                        const Text("Calorías de hoy"),
                        Text(
                          total.toStringAsFixed(0),
                          style: const TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        const Text("kcal"),
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
                          minHeight: 10,
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

          // GRÁFICA
          FutureBuilder<Map<String, double>>(
            future: DatabaseService.caloriasPorTipoHoy(),
            builder: (context, snapshot) {
              final data = snapshot.data ??
                  {
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

  late final List<Widget> _screens = [
    _homeContent(),
    RegistrarComida(),
    Recetas(),
    Mascota(),
    Perfil(),
    Ajustes(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: Text("Hola, ${widget.nombre} 👋"),
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

      body: _screens[_index],

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