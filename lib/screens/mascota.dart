import 'package:flutter/material.dart';

class Mascota extends StatelessWidget {
  final double calorias;
  final double meta;

  const Mascota({
    super.key,
    required this.calorias,
    required this.meta,
  });

  @override
  Widget build(BuildContext context) {

    String imagen;
    String mensaje;

    // 🔥 lógica mejorada con 3 estados reales
    if (calorias <= meta) {
      imagen = 'assets/images/mascota.png';
      mensaje = "¡Vas excelente! 💪";
    }
    else if (calorias <= meta * 1.2) {
      imagen = 'assets/images/enojado.png';
      mensaje = "Cuidado... te estás pasando 😡";
    }
    else {
      imagen = 'assets/images/triste.png';
      mensaje = "Te pasaste demasiado 😢";
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Tu mascota")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // 🐾 animación suave al cambiar estado
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Image.asset(
                imagen,
                key: ValueKey(imagen),
                width: 200,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Calorías: ${calorias.toStringAsFixed(0)} / ${meta.toStringAsFixed(0)}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}