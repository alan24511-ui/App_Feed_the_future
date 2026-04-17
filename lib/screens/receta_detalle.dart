import 'package:flutter/material.dart';

class RecetaDetalle extends StatefulWidget {
  final Map<String, dynamic> receta;

  const RecetaDetalle({super.key, required this.receta});

  @override
  State<RecetaDetalle> createState() => _RecetaDetalleState();
}

class _RecetaDetalleState extends State<RecetaDetalle> {

  int porciones = 1;

  @override
  Widget build(BuildContext context) {

    double calorias =
        (widget.receta["cal"] as num).toDouble() * porciones;

    List<String> ingredientes =
    List<String>.from(widget.receta["ingredientes"]);

    List<String> pasos =
    widget.receta["pasos"].split("\n");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receta["nombre"]),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(widget.receta["nombre"],
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Porciones"),
                Row(
                  children: [
                    IconButton(
                      onPressed: porciones > 1
                          ? () => setState(() => porciones--)
                          : null,
                      icon: const Icon(Icons.remove_circle),
                    ),
                    Text("$porciones"),
                    IconButton(
                      onPressed: () => setState(() => porciones++),
                      icon: const Icon(Icons.add_circle),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 10),

            Text("Calorías: ${calorias.toStringAsFixed(1)} kcal"),

            const SizedBox(height: 20),

            const Text("Ingredientes",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            ...ingredientes.map((i) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text("• $i"),
            )),

            const SizedBox(height: 20),

            const Text("Preparación",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            ...List.generate(pasos.length, (index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text("${index + 1}",
                        style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(pasos[index]),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}