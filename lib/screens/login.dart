import 'package:flutter/material.dart';
import '../services/imc_service.dart';
import 'home_screen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double peso = 60;
  double estatura = 1.60;
  TextEditingController nombre = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Datos del usuario")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nombre,
              decoration: const InputDecoration(
                labelText: "Nombre",
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 20),

            Text("Peso: ${peso.toStringAsFixed(0)} kg"),
            Slider(
              value: peso,
              min: 30,
              max: 150,
              onChanged: (v) => setState(() => peso = v),
            ),

            const SizedBox(height: 20),

            Text("Estatura: ${estatura.toStringAsFixed(2)} m"),
            Slider(
              value: estatura,
              min: 1.2,
              max: 2.2,
              onChanged: (v) => setState(() => estatura = v),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                double imc = IMCService.calcularIMC(peso, estatura);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomeScreen(
                      nombre: nombre.text,
                      imc: imc,
                    ),
                  ),
                );
              },
              child: const Text("Continuar"),
            ),
          ],
        ),
      ),
    );
  }
}