import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../services/database_service.dart';
import '../models/comida_model.dart';

import 'registrar_comida.dart';
import 'recetas.dart';
import 'perfil.dart';
import 'mascota.dart';
import 'ajustes.dart';
import 'notificacion.dart';
import 'meta_screen.dart';

class HomeScreen extends StatefulWidget {
  final String nombre;
  final double imc;

  const HomeScreen({super.key, required this.nombre, required this.imc});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // 🔥 WIDGET TARJETA MODERNA
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

  // 🔥 GRÁFICA MEJORADA
  Widget grafica() {
    final data = DatabaseService.caloriasPorTipoHoy();

    return SizedBox(
      height: 220,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,

          sections: [
            PieChartSectionData(
              value: data["Desayuno"]!,
              color: Colors.orange,
              radius: 60,
              title:
              "Desayuno\n${data["Desayuno"]!.toStringAsFixed(0)} kcal",
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            PieChartSectionData(
              value: data["Comida"]!,
              color: Colors.green,
              radius: 60,
              title:
              "Comida\n${data["Comida"]!.toStringAsFixed(0)} kcal",
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            PieChartSectionData(
              value: data["Cena"]!,
              color: Colors.blue,
              radius: 60,
              title:
              "Cena\n${data["Cena"]!.toStringAsFixed(0)} kcal",
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = DatabaseService.caloriasHoy();
    double meta = DatabaseService.getMeta();
    double progreso = total / meta;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: Text("Hola, ${widget.nombre} 👋"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
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

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // 🔹 IMC
            cardWidget(
              ListTile(
                leading: Icon(Icons.monitor_heart, color: Colors.green.shade600),
                title: Text("IMC: ${widget.imc.toStringAsFixed(1)}"),
                subtitle: const Text("Estado saludable"),
              ),
            ),

            // 🔥 CALORÍAS
            cardWidget(
              Column(
                children: [
                  const Text(
                    "Calorías de hoy",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${total.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "kcal",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            // 🔥 PROGRESO
            cardWidget(
              Column(
                children: [

                  const Text(
                    "Progreso diario",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progreso > 1 ? 1 : progreso,
                      minHeight: 12,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(
                        progreso > 1 ? Colors.red : Colors.green,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "${total.toStringAsFixed(0)} / ${meta.toStringAsFixed(0)} kcal",
                  ),
                ],
              ),
            ),

            // 🔥 GRÁFICA
            cardWidget(grafica()),

            const SizedBox(height: 10),

            // 🔹 GRID
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,

                children: [
                  _card(context, "Registrar comida", Icons.fastfood, const RegistrarComida()),
                  _card(context, "Recetas", Icons.menu_book, Recetas()),
                  _card(context, "Perfil", Icons.person, Perfil()),
                  _card(context, "Mascota", Icons.pets, Mascota()),
                  _card(context, "Ajustes", Icons.settings, Ajustes()),
                  _card(context, "Meta", Icons.flag, const MetaScreen()),
                  _card(context, "Historial", Icons.history, const HistorialScreen()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 TARJETAS DEL GRID
  Widget _card(BuildContext ctx, String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          ctx,
          MaterialPageRoute(builder: (_) => page),
        );
        setState(() {});
      },

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: Colors.green.shade600),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔥 HISTORIAL
class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<ComidaModel> data = DatabaseService.obtenerComidas();

    return Scaffold(
      appBar: AppBar(title: const Text("Historial")),
      body: data.isEmpty
          ? const Center(child: Text("No hay registros"))
          : ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, i) {
          final c = data[i];

          return ListTile(
            leading: const Icon(Icons.restaurant),
            title: Text(c.nombre),
            subtitle: Text(
              "${c.calorias.toStringAsFixed(1)} kcal - ${c.tipo}",
            ),
            trailing: Text(
              "${c.fecha.day}/${c.fecha.month}",
            ),
          );
        },
      ),
    );
  }
}