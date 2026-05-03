import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ajustes extends StatefulWidget {
  @override
  State<Ajustes> createState() => _AjustesState();
}

class _AjustesState extends State<Ajustes> {

  bool modoOscuro = false;
  bool notificaciones = true;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      modoOscuro = prefs.getBool('modoOscuro') ?? false;
      notificaciones = prefs.getBool('notificaciones') ?? true;
    });
  }

  Future<void> guardar(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajustes")),

      body: ListView(
        children: [

          // 🔹 MODO OSCURO
          SwitchListTile(
            title: const Text("Modo oscuro"),
            subtitle: const Text("Cambiar apariencia de la app"),
            value: modoOscuro,
            onChanged: (value) {
              setState(() => modoOscuro = value);
              guardar("modoOscuro", value);
            },
          ),

          // 🔹 NOTIFICACIONES
          SwitchListTile(
            title: const Text("Notificaciones"),
            subtitle: const Text("Recordatorios diarios"),
            value: notificaciones,
            onChanged: (value) {
              setState(() => notificaciones = value);
              guardar("notificaciones", value);
            },
          ),

          const Divider(),

          // 🔹 INFO APP
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("Acerca de"),
            subtitle: const Text("Versión 1.0"),
          ),

          // 🔹 RESET
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text("Restablecer app"),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Confirmar"),
                  content: const Text("Se borrarán ajustes locales"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancelar"),
                    ),
                    TextButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();

                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Ajustes reiniciados")),
                          );
                        }
                      },
                      child: const Text("Eliminar"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}