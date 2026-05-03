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

  Widget macroBox(String label, double value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(label,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("${value.toStringAsFixed(0)} g",
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Historial"),
        centerTitle: true,
      ),

      body: Column(
        children: [

          // ================= CALENDARIO =================
          SizedBox(
            height: 95,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                final day = DateTime.now().subtract(Duration(days: index));
                final isSelected =
                    selectedDay.day == day.day &&
                        selectedDay.month == day.month;

                return GestureDetector(
                  onTap: () {
                    setState(() => selectedDay = day);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 70,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat.E().format(day),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${day.day}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
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

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.lightBlueAccent],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('dd MMM yyyy').format(selectedDay),
                      style: const TextStyle(color: Colors.white70),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "${total.toStringAsFixed(0)} kcal",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        macroBox("Proteína", p, Colors.red),
                        macroBox("Carbs", c, Colors.orange),
                        macroBox("Grasas", g, Colors.blue),
                      ],
                    )
                  ],
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
                  return const Center(
                    child: Text("No registraste comidas 😅"),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: data.length,
                  itemBuilder: (context, i) {

                    final item = data[i];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Row(
                        children: [

                          // ICONO
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.fastfood,
                                color: Colors.blue),
                          ),

                          const SizedBox(width: 12),

                          // INFO
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(item["nombre"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text(item["tipo"],
                                    style: const TextStyle(
                                        color: Colors.grey)),
                              ],
                            ),
                          ),

                          // CALORÍAS
                          Text(
                            "${item["calorias"].toStringAsFixed(0)} kcal",
                            style: TextStyle(
                              color: getColor(item["calorias"]),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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