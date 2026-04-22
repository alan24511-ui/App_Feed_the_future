import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
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

  double calcularIMC(double peso, double altura) {
    return peso / (altura * altura);
  }

  double calcularMeta(double imc) {
    if (imc < 18.5) return 2500;
    if (imc < 25) return 2000;
    return 1800;
  }

  void registrar() {

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

    double peso = double.parse(pesoCtrl.text);
    double altura = double.parse(alturaCtrl.text);
    int edad = int.parse(edadCtrl.text);

    double imc = calcularIMC(peso, altura);
    double meta = calcularMeta(imc);

    UserModel user = UserModel(
      correo: correoCtrl.text,
      password: passCtrl.text,
      nombre: nombreCtrl.text,
      apellido: apellidoCtrl.text,
      edad: edad,
      sexo: sexo,
      peso: peso,
      altura: altura,
      imc: imc,
      meta: meta,
    );

    DatabaseService.guardarUsuario(user);
    DatabaseService.setMeta(meta);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          nombre: user.nombre,
          imc: user.imc,
        ),
      ),
    );
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
      appBar: AppBar(title: const Text("Registro")),

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