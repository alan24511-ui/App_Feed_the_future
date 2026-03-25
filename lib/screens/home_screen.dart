import 'package:flutter/material.dart';
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

  HomeScreen({required this.nombre, required this.imc});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    var Historial = DatabaseService.obtener();

    return Scaffold(
      appBar: AppBar(
        title: Text("Hola, ${widget.nombre} 👋"),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
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
                leading: Icon(Icons.monitor_heart, color: Colors.green),
                title: Text("IMC: ${widget.imc.toStringAsFixed(1)}"),
                subtitle: Text("Estado saludable"),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 GRID DE OPCIONES
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,

                children: [

                  _card(context, "Registrar comida", Icons.fastfood, RegistrarComida()),
                  _card(context, "Recetas", Icons.menu_book, Recetas()),
                  _card(context, "Perfil", Icons.person, Perfil()),
                  _card(context, "Mascota", Icons.pets, Mascota()),
                  _card(context, "Ajustes", Icons.settings, Ajustes()),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 TARJETA REUTILIZABLE
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

  // 🔥 PANTALLA DE HISTORIAL
  Widget _HistorialScreen() {
    var data = DatabaseService.obtener();

    return Scaffold(
      appBar: AppBar(title: Text("Historial")),

      body: data.isEmpty
          ? const Center(child: Text("No hay registros"))
          : ListView(
        children: data.map((c) {
          return ListTile(
            leading: Icon(Icons.restaurant),
            title: Text(c["nombre"]),
            subtitle: Text("${c["cal"]} kcal"),
          );
        }).toList(),
      ),
    );
  }
}
class HistorialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var data = DatabaseService.obtener();

    return Scaffold(
      appBar: AppBar(title: Text("Historial")),
      body: data.isEmpty
          ? Center(child: Text("No hay registros"))
          : ListView(
        children: data.map((c) {
          return ListTile(
            leading: Icon(Icons.restaurant),
            title: Text(c["nombre"]),
            subtitle: Text("${c["cal"]} kcal"),
          );
        }).toList(),
      ),
    );
  }
}