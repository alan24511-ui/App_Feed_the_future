import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'meta_screen.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final correoCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nombreCtrl = TextEditingController();
  final apellidoCtrl = TextEditingController();
  final edadCtrl = TextEditingController();
  final pesoCtrl = TextEditingController();
  final alturaCtrl = TextEditingController();

  String sexo = "Masculino";

  final FirebaseAuth _auth = FirebaseAuth.instance;

  double calcularIMC(double peso, double altura) {
    return peso / (altura * altura);
  }

  double calcularMeta(double imc) {
    if (imc < 18.5) return 2500;
    if (imc < 25) return 2000;
    return 1800;
  }

  void registrar() async {
    if (correoCtrl.text.isEmpty ||
        passCtrl.text.isEmpty ||
        nombreCtrl.text.isEmpty ||
        edadCtrl.text.isEmpty ||
        pesoCtrl.text.isEmpty ||
        alturaCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    try {
      double peso = double.parse(pesoCtrl.text);
      double altura = double.parse(alturaCtrl.text);
      int edad = int.parse(edadCtrl.text);

      double imc = calcularIMC(peso, altura);
      double meta = calcularMeta(imc);

      final result = await _auth.createUserWithEmailAndPassword(
        email: correoCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      final user = result.user;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .set({
          'nombre': nombreCtrl.text,
          'apellido': apellidoCtrl.text,
          'correo': correoCtrl.text.trim(),
          'edad': edad,
          'sexo': sexo,
          'peso': peso,
          'altura': altura,
          'imc': imc,
          'meta': meta,
          'metaSeleccionada': null,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registro exitoso")),
        );

        if (!mounted) return;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MetaScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String mensaje = "Error";

      if (e.code == 'email-already-in-use') {
        mensaje = "El correo ya existe";
      } else if (e.code == 'weak-password') {
        mensaje = "Contraseña muy débil";
      } else if (e.code == 'invalid-email') {
        mensaje = "Correo inválido";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
    }
  }

  Widget campo(String label, TextEditingController ctrl,
      {bool isNumber = false, bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const Text("Crear cuenta 🥗"),
        backgroundColor: const Color(0xFF66BB6A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              campo("Correo electrónico", correoCtrl),
              campo("Contraseña", passCtrl, isPassword: true),
              campo("Nombre", nombreCtrl),
              campo("Apellido", apellidoCtrl),
              campo("Edad", edadCtrl, isNumber: true),

              DropdownButtonFormField<String>(
                value: sexo,
                items: ["Masculino", "Femenino"]
                    .map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(s),
                ))
                    .toList(),
                onChanged: (v) => setState(() => sexo = v!),
                decoration: const InputDecoration(
                  labelText: "Sexo",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              campo("Peso (kg)", pesoCtrl, isNumber: true),
              campo("Altura (m)", alturaCtrl, isNumber: true),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF66BB6A),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: registrar,
                  child: const Text("Registrarme"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}