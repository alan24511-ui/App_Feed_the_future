import 'package:flutter/material.dart';
import '../services/database_service.dart';
import 'home_screen.dart';
import 'registro_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final correoCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  void login() {
    var user = DatabaseService.usuarioActual;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No hay usuario registrado")),
      );
      return;
    }

    if (correoCtrl.text == user.correo &&
        passCtrl.text == user.password) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            nombre: user.nombre,
            imc: user.imc,
          ),
        ),
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Datos incorrectos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: correoCtrl,
              decoration: const InputDecoration(
                labelText: "Correo",
                prefixIcon: Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Contraseña",
                prefixIcon: Icon(Icons.lock),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: login,
              child: const Text("Iniciar sesión"),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegistroScreen(),
                  ),
                );
              },
              child: const Text("Crear cuenta"),
            )
          ],
        ),
      ),
    );
  }
}