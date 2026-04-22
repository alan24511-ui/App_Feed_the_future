import 'package:flutter/material.dart';
import '../services/database_service.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DatabaseService.usuarioActual;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No hay usuario registrado")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text("Perfil"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // 🔹 HEADER
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),

              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "${user.nombre} ${user.apellido}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    user.correo,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 INFO PERSONAL
            _card(
              title: "Información personal",
              children: [
                _item("Edad", "${user.edad} años"),
                _item("Sexo", user.sexo),
              ],
            ),

            // 🔹 DATOS FÍSICOS
            _card(
              title: "Datos físicos",
              children: [
                _item("Peso", "${user.peso} kg"),
                _item("Altura", "${user.altura} m"),
                _item("IMC", user.imc.toStringAsFixed(1)),
              ],
            ),

            // 🔹 META
            _card(
              title: "Meta nutricional",
              children: [
                _item("Calorías diarias", "${user.meta.toStringAsFixed(0)} kcal"),
              ],
            ),

            const SizedBox(height: 20),

            // 🔴 BOTÓN CERRAR SESIÓN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  DatabaseService.usuarioActual = null;

                  Navigator.pop(context);
                },
                child: const Text("Cerrar sesión"),
              ),
            )
          ],
        ),
      ),
    );
  }

  // 🔹 TARJETA REUTILIZABLE
  Widget _card({required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  // 🔹 ITEM DE INFO
  Widget _item(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}