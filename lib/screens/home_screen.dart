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

class HomeScreen extends StatefulWidget {
  final String nombre;
  final double imc;

  const HomeScreen({super.key, required this.nombre, required this.imc});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // 🔥 GRÁFICA
  Widget grafica() {
    final data = DatabaseService.caloriasPorTipoHoy();

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(value: data["Desayuno"]!, title: "Desayuno"),
            PieChartSectionData(value: data["Comida"]!, title: "Comida"),
            PieChartSectionData(value: data["Cena"]!, title: "Cena"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = DatabaseService.caloriasHoy();

    return Scaffold(
      appBar: AppBar(
        title: Text("Hola, ${widget.nombre} 👋"),
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

            // 🔹 TARJETA IMC
            Card(
              child: ListTile(
                leading: const Icon(Icons.monitor_heart, color: Colors.green),
                title: Text("IMC: ${widget.imc.toStringAsFixed(1)}"),
                subtitle: const Text("Estado saludable"),
              ),
            ),

            const SizedBox(height: 15),

            // 🔥 CALORÍAS DEL DÍA
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "Calorías de hoy",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${total.toStringAsFixed(1)} kcal",
                      style: const TextStyle(fontSize: 28),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 🔥 GRÁFICA
            grafica(),

            const SizedBox(height: 15),

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

                  // 🔥 NUEVO: HISTORIAL
                  _card(context, "Historial", Icons.history, HistorialScreen()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 TARJETA REUTILIZABLE
  Widget _card(BuildContext ctx, String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          ctx,
          MaterialPageRoute(builder: (_) => page),
        );
        setState(() {});
      },

      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: Colors.green),
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

// 🔥 HISTORIAL NUEVO (USANDO MODELO)
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