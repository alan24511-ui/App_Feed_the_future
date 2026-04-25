import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void login() async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: correoCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      final user = result.user;

      if (user != null) {
        // 🔥 OBTENER DATOS REALES DESDE FIRESTORE
        final doc = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .get();

        final data = doc.data();

        if (data == null) {
          throw Exception("No existe el perfil en Firestore");
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(
              nombre: data['nombre'] ?? user.email,
              imc: (data['imc'] ?? 0).toDouble(),
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String mensaje = "Error";

      if (e.code == 'user-not-found') {
        mensaje = "Usuario no existe";
      } else if (e.code == 'wrong-password') {
        mensaje = "Contraseña incorrecta";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Firebase")),

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