import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';
import 'home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {

        // Cargando
        if (snapshot.connectionState ==
            ConnectionState.waiting) {

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Usuario logueado
        if (snapshot.hasData) {

          final user = snapshot.data!;

          return HomeScreen(
            nombre: user.displayName ?? "Usuario",
            imc: 0,
          );
        }

        // Usuario no logueado
        return const Login();
      },
    );
  }
}