import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/database_service.dart';

import 'registrar_comida.dart';
import 'recetas.dart';
import 'perfil.dart';
import 'mascota.dart';
import 'ajustes.dart';
import 'historial_screen.dart';

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

  Map<String, dynamic>? detalleSeleccionado;
  String? diaSeleccionado;
  String? origenDetalle;

  Timer? _timer;
  DateTime? _ultimoDia;

  double caloriasHoy = 0;
  StreamSubscription? _caloriasSub;

  @override
  void initState() {
    super.initState();
    cargarMeta();
    _ultimoDia = DateTime.now();

    _caloriasSub = DatabaseService.caloriasHoyStream().listen((value) {
      if (!mounted) return;
      setState(() {
        caloriasHoy = value.toDouble();
      });
    });
  }

  @override
  void dispose() {
    _caloriasSub?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  void verificarCambioDeDia() async {
    final now = DateTime.now();

    if (_ultimoDia == null) {
      _ultimoDia = now;
      return;
    }

    final cambio = now.year != _ultimoDia!.year ||
        now.month != _ultimoDia!.month ||
        now.day != _ultimoDia!.day;

    if (cambio) {
      _ultimoDia = now;
      await DatabaseService.guardarDiaAnterior();
      if (mounted) setState(() {});
    }
  }

  void cargarMeta() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid)
        .get();

    if (!doc.exists) return;

    final data = doc.data()!;
    setState(() {
      metaUsuario = data['metaSeleccionada'] ?? "mantener";
      metaCalorias = (data['caloriasMeta'] ?? 2200).toDouble();
    });
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

  Widget cardWidget(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: child,
    );
  }

  void mostrarDetalle(Map<String, dynamic> data, String dia, String origen) {
    _timer?.cancel();

    setState(() {
      detalleSeleccionado = data;
      diaSeleccionado = dia;
      origenDetalle = origen;
    });

    _timer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => detalleSeleccionado = null);
      }
    });
  }

  Widget buildHeader() {
    return cardWidget(
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              getPrimaryColor(),
              getPrimaryColor().withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hola ${widget.nombre}",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text("🔥 Seguimiento nutricional activo",
                style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),
            Text("IMC ${widget.imc.toStringAsFixed(1)}",
                style: const TextStyle(color: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget graficaDiariaPie(Map<String, dynamic> data) {
    final desayuno = (data["Desayuno"] ?? 0).toDouble();
    final comida = (data["Comida"] ?? 0).toDouble();
    final cena = (data["Cena"] ?? 0).toDouble();

    final total = desayuno + comida + cena;

    return GestureDetector(
      onTap: () async {
        final macros = await DatabaseService.macrosHoyStream().first;

        mostrarDetalle({
          "Desayuno": desayuno,
          "Comida": comida,
          "Cena": cena,
          "Proteína": (macros["prote"] ?? 0).toDouble(),
          "Carbs": (macros["carbs"] ?? 0).toDouble(),
          "Grasas": (macros["grasas"] ?? 0).toDouble(),
        }, "Hoy", "diario");
      },
      child: SizedBox(
        height: 260,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(210, 210),
              painter: PiePainter(
                values: [desayuno, comida, cena],
                colors: [Colors.orange, Colors.green, Colors.blue],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.local_fire_department,
                    color: Colors.red, size: 34),
                Text("${total.toStringAsFixed(0)} kcal",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ FIX REAL: ahora muestra macros correctamente
  Widget graficaSemanal(Map<String, dynamic> map) {
    final dias = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"];

    final valores = dias.map((d) {
      return (map[d] is Map)
          ? (map[d]["cal"] ?? 0).toDouble()
          : (map[d] ?? 0).toDouble();
    }).toList();

    final maxVal = valores.isEmpty
        ? 1.0
        : valores.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 260,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(dias.length, (i) {
          final value = valores[i];

          return Expanded(
            child: GestureDetector(
              onTap: () async {
                final macros = await DatabaseService.macrosSemanaStream().first;

                final data = macros[dias[i]] ?? {
                  "cal": 0.0,
                  "p": 0.0,
                  "c": 0.0,
                  "g": 0.0,
                };

                mostrarDetalle({
                  "Calorías": data["cal"],
                  "Proteínas": data["p"],
                  "Carbohidratos": data["c"],
                  "Grasas": data["g"],
                }, dias[i], "semanal");
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: maxVal == 0 ? 0 : (value / maxVal) * 200,
                    width: 14,
                    decoration: BoxDecoration(
                      color: getPrimaryColor(),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(dias[i], style: const TextStyle(fontSize: 11)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _homeContent() {
    verificarCambioDeDia();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
        child: Column(
          children: [
            buildHeader(),

            cardWidget(Column(
              children: [
                const Text("Calorías hoy"),
                Text("${caloriasHoy.toStringAsFixed(0)}",
                    style: const TextStyle(fontSize: 34)),
              ],
            )),

            StreamBuilder<Map<String, dynamic>>(
              stream: DatabaseService.caloriasPorTipoStream(),
              builder: (context, snapshot) {
                return cardWidget(Column(
                  children: [
                    const Text("Gráfica diaria"),
                    graficaDiariaPie(snapshot.data ?? {}),
                  ],
                ));
              },
            ),

            StreamBuilder<Map<String, dynamic>>(
              stream: DatabaseService.caloriasSemanaStream(),
              builder: (context, snapshot) {
                return cardWidget(Column(
                  children: [
                    const Text("Gráfica semanal"),
                    graficaSemanal(snapshot.data ?? {}),
                  ],
                ));
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
      Mascota(calorias: caloriasHoy, meta: metaCalorias),
      RegistrarComida(),
      Recetas(),
      Perfil(),
      Ajustes(),
      const HistorialScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Hola ${widget.nombre}"),
        backgroundColor: getPrimaryColor(),
      ),
      body: Stack(
        children: [
          screens[_index],
          if (detalleSeleccionado != null)
            Positioned(
              bottom: 120,
              left: 20,
              right: 20,
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$diaSeleccionado\n$origenDetalle\n$detalleSeleccionado",
                  ),
                ),
              ),
            )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        selectedItemColor: getPrimaryColor(),
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: "Mascota"),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Comida"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Recetas"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Ajustes"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Historial"),
        ],
      ),
    );
  }
}

class PiePainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  PiePainter({required this.values, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<double>(0.0, (a, b) => a + b);
    double start = -pi / 2;

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    for (int i = 0; i < values.length; i++) {
      final sweep = total == 0 ? 0.0 : (values[i] / total) * 2 * pi;

      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;

      canvas.drawArc(rect, start, sweep, true, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}