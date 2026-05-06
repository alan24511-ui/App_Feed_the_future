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

// 🔥 IMPORT LOCALIZATION
import '../l10n/app_localizations.dart';

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

  double proteMeta = 0;
  double carbsMeta = 0;
  double grasasMeta = 0;

  double proteHoy = 0;
  double carbsHoy = 0;
  double grasasHoy = 0;

  Timer? _timer;
  DateTime? _ultimoDia;

  double caloriasHoy = 0;
  StreamSubscription? _caloriasSub;
  StreamSubscription? _macrosSub;

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

    _macrosSub = DatabaseService.macrosHoyStream().listen((macros) {
      if (!mounted) return;

      setState(() {
        proteHoy = (macros["prote"] ?? 0).toDouble();
        carbsHoy = (macros["carbs"] ?? 0).toDouble();
        grasasHoy = (macros["grasas"] ?? 0).toDouble();
      });
    });
  }

  @override
  void dispose() {
    _caloriasSub?.cancel();
    _macrosSub?.cancel();
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

      proteMeta = (data['proteinaMeta'] ?? 150).toDouble();
      carbsMeta = (data['carbsMeta'] ?? 250).toDouble();
      grasasMeta = (data['grasasMeta'] ?? 70).toDouble();
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

  Widget buildHeader() {
    final t = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            getPrimaryColor(),
            getPrimaryColor().withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department,
              color: Colors.white, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${t.hola} ${widget.nombre}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                Text("🔥 ${t.seguimiento}",
                    style: const TextStyle(color: Colors.white70)),
                Text("IMC ${widget.imc.toStringAsFixed(1)}",
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget caloriasCard() {
    final t = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(t.caloriasHoy,
              style: const TextStyle(color: Colors.white)),
          Text(
            caloriasHoy.toStringAsFixed(0),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget objetivoCard() {
    final t = AppLocalizations.of(context)!;
    final progreso = (caloriasHoy / metaCalorias).clamp(0, 1);

    return cardWidget(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.objetivoDiario,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progreso.toDouble(),
            minHeight: 14,
            color: getPrimaryColor(),
          ),
          const SizedBox(height: 10),
          Text(
              "${caloriasHoy.toStringAsFixed(0)} / ${metaCalorias.toStringAsFixed(0)} kcal"),
        ],
      ),
    );
  }

  Widget macrosCard() {
    final t = AppLocalizations.of(context)!;

    return cardWidget(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.macronutrientes,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          macroProgress(t.proteina, proteHoy, proteMeta, Colors.red),
          macroProgress("Carbs", carbsHoy, carbsMeta, Colors.orange),
          macroProgress(t.grasas, grasasHoy, grasasMeta, Colors.blue),
        ],
      ),
    );
  }

  Widget macroProgress(
      String nombre, double actual, double meta, Color color) {

    final progreso = meta == 0 ? 0 : (actual / meta).clamp(0, 1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(nombre),
              const Spacer(),
              Text("${actual.toStringAsFixed(0)} / ${meta.toStringAsFixed(0)} g"),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: progreso.toDouble(),
            minHeight: 10,
            color: color,
            backgroundColor: color.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _homeContent() {
    final t = AppLocalizations.of(context)!;

    verificarCambioDeDia();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
        child: Column(
          children: [
            buildHeader(),
            caloriasCard(),
            objetivoCard(),
            macrosCard(),

            StreamBuilder<Map<String, dynamic>>(
              stream: DatabaseService.caloriasPorTipoStream(),
              builder: (context, snapshot) {
                return cardWidget(Column(
                  children: [
                    Text(t.graficaDiaria),
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
                    Text(t.graficaSemanal),
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

  Widget graficaDiariaPie(Map<String, dynamic> data) {
    final desayuno = (data["Desayuno"] ?? 0).toDouble();
    final comida = (data["Comida"] ?? 0).toDouble();
    final cena = (data["Cena"] ?? 0).toDouble();

    final total = desayuno + comida + cena;

    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(180, 180),
            painter: PiePainter(
              values: [desayuno, comida, cena],
              colors: [Colors.orange, Colors.green, Colors.blue],
            ),
          ),
          Text("${total.toStringAsFixed(0)} kcal"),
        ],
      ),
    );
  }

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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(dias.length, (i) {
        final value = valores[i];

        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: maxVal == 0 ? 0 : (value / maxVal) * 180,
                width: 14,
                color: getPrimaryColor(),
              ),
              Text(dias[i]),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

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
        title: Text("${t.hola} ${widget.nombre}"),
        backgroundColor: getPrimaryColor(),
      ),
      body: screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        selectedItemColor: getPrimaryColor(),
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _index = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: t.inicio),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: t.mascota),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: t.comida),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: t.recetas),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: t.perfil),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: t.ajustes),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: t.historial),
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