import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/database_service.dart';
import '../l10n/app_localizations.dart';

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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "${value.toStringAsFixed(0)} g",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> abrirCalendario() async {

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDay,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDay = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: Text(t.historial),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: abrirCalendario,
        child: const Icon(Icons.calendar_month),
      ),

      body: Column(
        children: [

          // 🔥 HEADER FECHA
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.lightBlueAccent,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Column(
              children: [

                const Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: 34,
                ),

                const SizedBox(height: 10),

                Text(
                  DateFormat.yMMMMd(
                    Localizations.localeOf(context).languageCode,
                  ).format(selectedDay),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                 Text(
                  "📊 ${t.resumenNutricional}",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // 🔥 RESUMEN
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: DatabaseService.historialPorDia(selectedDay),

            builder: (context, snapshot) {

              final data = snapshot.data ?? [];

              double total = 0;
              double p = 0;
              double c = 0;
              double g = 0;

              for (var item in data) {
                total += (item["calorias"] ?? 0).toDouble();
                p += (item["proteinas"] ?? 0).toDouble();
                c += (item["carbohidratos"] ?? 0).toDouble();
                g += (item["grasas"] ?? 0).toDouble();
              }

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                    )
                  ],
                ),

                child: Column(
                  children: [

                    Text(
                      "${total.toStringAsFixed(0)} kcal",
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        macroBox(t.proteina, p, Colors.red),
                        macroBox(t.carbs, c, Colors.orange),
                        macroBox(t.grasas, g, Colors.blue),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // 🔥 LISTA COMIDAS
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: DatabaseService.historialPorDia(selectedDay),

              builder: (context, snapshot) {

                final data = snapshot.data ?? [];

                if (data.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Icon(
                          Icons.fastfood,
                          size: 70,
                          color: Colors.grey[400],
                        ),

                        const SizedBox(height: 12),

                        Text(
                          t.noComidas,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: data.length,

                  itemBuilder: (context, i) {

                    final item = data[i];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          )
                        ],
                      ),

                      child: Row(
                        children: [

                          // 🔥 ICONO
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.restaurant,
                              color: Colors.blue,
                            ),
                          ),

                          const SizedBox(width: 14),

                          // 🔥 INFO
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                Text(
                                  item["nombre"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  item["tipo"],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 🔥 CALORÍAS
                          Text(
                            "${item["calorias"].toStringAsFixed(0)} kcal",
                            style: TextStyle(
                              color: getColor(
                                (item["calorias"] ?? 0).toDouble(),
                              ),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}