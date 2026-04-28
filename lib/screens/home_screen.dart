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

  Map<String, double>? detalleSeleccionado;
  String? diaSeleccionado;

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

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          metaUsuario = data['metaSeleccionada'] ?? "mantener";
          metaCalorias = (data['caloriasMeta'] ?? 2200).toDouble();
        });
      }
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
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10)
        ],
      ),
      child: child,
    );
  }

  /// 🔥 GRAFICA DIARIA MEJORADA (MÁS GRANDE + LEGIBLE)
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
        Row(
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () async {
                  final macros =
                  await DatabaseService.macrosHoyStream().first;

                  setState(() {
                    diaSeleccionado = "Hoy";
                    detalleSeleccionado = {
                      "Calorías": total,
                      "Desayuno": desayuno,
                      "Comida": comida,
                      "Cena": cena,
                      "Proteína": macros["prote"] ?? 0,
                      "Carbohidratos": macros["carbs"] ?? 0,
                      "Grasas": macros["grasas"] ?? 0,
                    };
                  });
                },
                child: TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return SizedBox(
                      height: 340,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: 1,
                            strokeWidth: 24,
                            color: Colors.grey.shade200,
                          ),
                          CircularProgressIndicator(
                            value: d * value,
                            strokeWidth: 24,
                            color: Colors.orange,
                          ),
                          CircularProgressIndicator(
                            value: c * value,
                            strokeWidth: 24,
                            color: Colors.green,
                          ),
                          CircularProgressIndicator(
                            value: n * value,
                            strokeWidth: 24,
                            color: Colors.blue,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.local_fire_department,
                                  color: Colors.red, size: 32),
                              const SizedBox(height: 6),
                              Text(
                                "${total.toStringAsFixed(0)} kcal",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Desliza para detalle",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            if (detalleSeleccionado != null)
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Detalle ${diaSeleccionado ?? ""}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Divider(),
                      ...detalleSeleccionado!.entries.map(
                            (e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.key),
                              Text(
                                e.value.toStringAsFixed(1),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),

        /// 🔥 LEYENDA VISUAL
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 HEADER MEJORADO (NO AMONTONADO)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    getPrimaryColor(),
                    getPrimaryColor().withOpacity(0.7)
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      const Icon(Icons.bolt, color: Colors.white),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Hola ${widget.nombre}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    getMensajeMeta(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// IMC BADGE SEPARADO (NO AMONTONADO)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "IMC ${widget.imc.toStringAsFixed(1)}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 10),

            StreamBuilder<double>(
              stream: DatabaseService.caloriasHoyStream(),
              builder: (context, snapshot) {
                final total = snapshot.data ?? 0;
                final progreso = total / metaCalorias;

                return Column(
                  children: [
                    cardWidget(
                      Column(
                        children: [
                          const Text("Calorías de hoy"),
                          const SizedBox(height: 6),
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
                            minHeight: 14,
                            borderRadius: BorderRadius.circular(10),
                            color: getPrimaryColor(),
                            backgroundColor: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 8),
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

            /// 🔥 GRAFICA DIARIA
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

            /// 🔥 GRAFICA SEMANAL MEJORADA (SIN PERDER FUNCIONES)
            StreamBuilder<Map<String, double>>(
              stream: DatabaseService.caloriasSemanaStream(),
              builder: (context, snapshot) {
                final map = snapshot.data ?? {
                  "Lun": 0,
                  "Mar": 0,
                  "Mié": 0,
                  "Jue": 0,
                  "Vie": 0,
                  "Sáb": 0,
                  "Dom": 0,
                };

                final dias = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"];
                final data = dias.map((d) => map[d]!).toList();

                return cardWidget(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Calorías de la semana",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),

                      SizedBox(
                        height: 210,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(data.length, (i) {
                            final value = data[i];

                            return Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final macros = await DatabaseService
                                      .macrosHoyStream()
                                      .first;

                                  setState(() {
                                    diaSeleccionado = dias[i];
                                    detalleSeleccionado = {
                                      "Calorías": value,
                                      "Proteína": macros["prote"] ?? 0,
                                      "Carbs": macros["carbs"] ?? 0,
                                      "Grasas": macros["grasas"] ?? 0,
                                    };
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: value / 12,
                                      width: 18,
                                      decoration: BoxDecoration(
                                        color: getPrimaryColor(),
                                        borderRadius:
                                        BorderRadius.circular(6),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      dias[i],
                                      style: const TextStyle(fontSize: 11),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      const SizedBox(height: 10),

                      if (detalleSeleccionado != null)
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Detalle ${diaSeleccionado ?? ""}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Divider(),
                              ...detalleSeleccionado!.entries.map(
                                    (e) => Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(e.key),
                                    Text(e.value.toStringAsFixed(1)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _homeContent(),
      RegistrarComida(),
      Recetas(),
      StreamBuilder<double>(
        stream: DatabaseService.caloriasHoyStream(),
        builder: (context, snapshot) {
          final calorias = snapshot.data ?? 0;
          return Mascota(calorias: calorias, meta: metaCalorias);
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

/// 🔥 LEGEND WIDGET (MEJORA VISUAL SIN ROMPER ESTRUCTURA)
class _Legend extends StatelessWidget {
  final Color color;
  final String text;

  const _Legend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration:
          BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}