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
    String imagen = 'assets/images/mascota.png';
    String mensaje = "Tu mascota está feliz contigo 💙";

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // 🌈 FONDO GRADIENTE
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4FACFE),
              Color(0xFF00F2FE),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [

              // 🔝 HEADER
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: const [
                    Icon(Icons.pets, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Tu mascota",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 🐶 TARJETA CENTRAL
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),

                child: Column(
                  children: [

                    // 🐾 IMAGEN
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Image.asset(
                        imagen,
                        key: ValueKey(imagen),
                        height: 180,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 💬 MENSAJE
                    Text(
                      mensaje,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // 📊 INFO CALORÍAS
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        "${calorias.toStringAsFixed(0)} / ${meta.toStringAsFixed(0)} kcal",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 🔽 FOOTER
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "Sigue registrando tus comidas 🍎",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}