import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import 'home_screen.dart';

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
  final FirestoreService _firestore = FirestoreService();

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

      // 🔐 1. Crear usuario en Firebase Auth
      final result = await _auth.createUserWithEmailAndPassword(
        email: correoCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      final user = result.user;

      if (user != null) {

        // ☁️ 2. Guardar datos en Firestore
        await _firestore.guardarUsuario(
          nombre: nombreCtrl.text,
          imc: imc,
        );

        // 🔥 EXTRA: guardar más datos
        await _firestore.db.collection('usuarios').doc(user.uid).update({
          'apellido': apellidoCtrl.text,
          'edad': edad,
          'sexo': sexo,
          'peso': peso,
          'altura': altura,
          'meta': meta,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registro exitoso")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(
              nombre: nombreCtrl.text,
              imc: imc,
            ),
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

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
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
      appBar: AppBar(title: const Text("Registro Firebase")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: SingleChildScrollView(
          child: Column(
            children: [

              campo("Correo electrónico", correoCtrl),
              campo("Contraseña", passCtrl, isPassword: true),

              const SizedBox(height: 10),

              campo("Nombre", nombreCtrl),
              campo("Apellido", apellidoCtrl),

              campo("Edad", edadCtrl, isNumber: true),

              DropdownButtonFormField<String>(
                value: sexo,
                items: ["Masculino", "Femenino"]
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
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
                  onPressed: registrar,
                  child: const Text("Registrarse"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}