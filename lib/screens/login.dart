import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_screen.dart';
import 'registro_screen.dart';

import '../services/notificacion_service.dart';

class Login extends StatefulWidget {

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final correoCtrl = TextEditingController();

  final passCtrl = TextEditingController();

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  bool cargando = false;

  void login() async {

    if (correoCtrl.text.trim().isEmpty ||
        passCtrl.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Completa todos los campos",
          ),
        ),
      );

      return;
    }

    setState(() {
      cargando = true;
    });

    try {

      final result =
      await _auth.signInWithEmailAndPassword(

        email: correoCtrl.text.trim(),

        password: passCtrl.text.trim(),
      );

      final user = result.user;

      if (user != null) {

        // 🔥 RECARGAR USUARIO
        await user.reload();

        await Future.delayed(
          const Duration(milliseconds: 300),
        );

        // 🔥 PROGRAMAR NOTIFICACIONES
        await NotificacionService
            .programarNotificaciones();

        // 🔥 OBTENER DATOS FIRESTORE
        final doc =
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .get();

        final data = doc.data();

        if (data == null) {

          throw Exception(
            "No existe el perfil en Firestore",
          );
        }

        if (!mounted) return;

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (_) => HomeScreen(

              nombre:
              data['nombre'] ??
                  user.email ??
                  "Usuario",

              imc:
              (data['imc'] ?? 0)
                  .toDouble(),
            ),
          ),
        );
      }

    } on FirebaseAuthException catch (e) {

      String mensaje = "Error";

      if (e.code == 'user-not-found') {

        mensaje = "Usuario no existe";

      } else if (e.code ==
          'wrong-password') {

        mensaje =
        "Contraseña incorrecta";

      } else if (e.code ==
          'invalid-email') {

        mensaje = "Correo inválido";

      } else if (e.code ==
          'invalid-credential') {

        mensaje =
        "Correo o contraseña incorrectos";
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(mensaje),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            "Error: $e",
          ),
        ),
      );

    } finally {

      if (mounted) {

        setState(() {
          cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,

        height: double.infinity,

        // 🌈 FONDO
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

        child: Center(

          child: SingleChildScrollView(

            padding: const EdgeInsets.all(20),

            child: Container(

              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(25),

                boxShadow: [

                  BoxShadow(

                    color:
                    Colors.black.withOpacity(
                      0.15,
                    ),

                    blurRadius: 20,

                    offset:
                    const Offset(0, 10),
                  )
                ],
              ),

              child: Column(

                mainAxisSize: MainAxisSize.min,

                children: [

                  // 🧠 ICONO
                  const Icon(

                    Icons.health_and_safety,

                    size: 70,

                    color: Color(0xFF4FACFE),
                  ),

                  const SizedBox(height: 10),

                  const Text(

                    "Bienvenido",

                    style: TextStyle(

                      fontSize: 22,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(

                    "Inicia sesión para continuar",

                    style:
                    TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 📧 CORREO
                  TextField(

                    controller: correoCtrl,

                    keyboardType:
                    TextInputType.emailAddress,

                    decoration: InputDecoration(

                      labelText: "Correo",

                      prefixIcon:
                      const Icon(Icons.email),

                      filled: true,

                      fillColor:
                      Colors.grey.shade100,

                      border: OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),

                        borderSide:
                        BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔒 PASSWORD
                  TextField(

                    controller: passCtrl,

                    obscureText: true,

                    decoration: InputDecoration(

                      labelText:
                      "Contraseña",

                      prefixIcon:
                      const Icon(Icons.lock),

                      filled: true,

                      fillColor:
                      Colors.grey.shade100,

                      border: OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(
                          15,
                        ),

                        borderSide:
                        BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 🔵 BOTÓN LOGIN
                  SizedBox(

                    width: double.infinity,

                    height: 50,

                    child: ElevatedButton(

                      onPressed:
                      cargando ? null : login,

                      style:
                      ElevatedButton.styleFrom(

                        backgroundColor:
                        const Color(
                          0xFF4FACFE,
                        ),

                        shape:
                        RoundedRectangleBorder(

                          borderRadius:
                          BorderRadius.circular(
                            15,
                          ),
                        ),

                        elevation: 5,
                      ),

                      child: cargando

                          ? const SizedBox(

                        width: 24,

                        height: 24,

                        child:
                        CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )

                          : const Text(

                        "Iniciar sesión",

                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 📝 REGISTRO
                  TextButton(

                    onPressed: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>
                          const RegistroScreen(),
                        ),
                      );
                    },

                    child: const Text(

                      "Crear cuenta",

                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}