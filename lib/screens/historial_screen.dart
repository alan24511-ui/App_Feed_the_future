import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_service.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  DateTime selectedDay = DateTime.now();

  Color getColor(double cal) {
    if (cal < 1800) return Colors.green;
    if (cal < 2500) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial"),
      ),

      body: Column(
        children: [

          // ================= CALENDARIO =================
          SizedBox(
            height: 90,
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: DatabaseService.historialStream(),
              builder: (context, snapshot) {

                final data = snapshot.data ?? [];

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (context, index) {

                    final day = DateTime.now().subtract(Duration(days: index));

                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedDay = day);
                      },
                      child: Container(
                        width: 70,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: selectedDay.day == day.day
                              ? Colors.blue
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(DateFormat.E().format(day)),
                            Text("${day.day}"),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // ================= RESUMEN =================
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: DatabaseService.historialPorDia(selectedDay),
            builder: (context, snapshot) {

              final data = snapshot.data ?? [];

              double total = 0;
              double p = 0, c = 0, g = 0;

              for (var item in data) {
                total += item["calorias"] ?? 0;
                p += item["proteinas"] ?? 0;
                c += item["carbohidratos"] ?? 0;
                g += item["grasas"] ?? 0;
              }

              return Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(DateFormat('dd MMM yyyy').format(selectedDay)),
                      Text("${total.toStringAsFixed(0)} kcal"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("P: ${p.toStringAsFixed(0)}"),
                          Text("C: ${c.toStringAsFixed(0)}"),
                          Text("G: ${g.toStringAsFixed(0)}"),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),

          // ================= LISTA =================
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: DatabaseService.historialPorDia(selectedDay),
              builder: (context, snapshot) {

                final data = snapshot.data ?? [];

                if (data.isEmpty) {
                  return const Center(child: Text("Sin comidas"));
                }

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, i) {

                    final item = data[i];

                    return ListTile(
                      title: Text(item["nombre"]),
                      subtitle: Text(item["tipo"]),
                      trailing: Text(
                        "${item["calorias"].toStringAsFixed(0)} kcal",
                        style: TextStyle(
                          color: getColor(item["calorias"]),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}