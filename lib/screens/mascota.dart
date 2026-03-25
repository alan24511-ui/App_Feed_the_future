import 'package:flutter/material.dart';

class Mascota extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tu mascota")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("🐱", style: TextStyle(fontSize: 100)),
            SizedBox(height: 20),
            Text("¡Sigue registrando comida para hacer feliz a tu mascota!",
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}