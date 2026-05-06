import '../main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 🔥 IMPORT LOCALIZATION
import '../l10n/app_localizations.dart';

class Ajustes extends StatefulWidget {
  const Ajustes({super.key});

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

  // 🔥 CAMBIAR MODO OSCURO REAL
  Future<void> cambiarModo(bool value) async {
    await guardar("modoOscuro", value);

    setState(() => modoOscuro = value);

    // 🔥 ACTUALIZA GLOBALMENTE
    MyApp.setTheme(context, value);
  }

  Future<void> cambiarNotificaciones(bool value) async {
    await guardar("notificaciones", value);
    setState(() => notificaciones = value);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.ajustes)),

      body: ListView(
        children: [

          // 🔹 MODO OSCURO
          SwitchListTile(
            title: Text(t.modoOscuro),
            subtitle: const Text("Cambiar apariencia de la app"),
            value: modoOscuro,
            onChanged: cambiarModo,
          ),

          // 🔹 IDIOMA
          ListTile(
            title: const Text("Idioma"),
            trailing: DropdownButton<String>(
              value: Localizations.localeOf(context).languageCode,
              items: const [
                DropdownMenuItem(value: "es", child: Text("Español")),
                DropdownMenuItem(value: "en", child: Text("English")),
              ],
              onChanged: (value) {
                if (value == "es") {
                  MyApp.setLocale(context, const Locale('es'));
                } else {
                  MyApp.setLocale(context, const Locale('en'));
                }
              },
            ),
          ),

          // 🔹 NOTIFICACIONES
          SwitchListTile(
            title: Text(t.notificaciones),
            subtitle: const Text("Recordatorios diarios"),
            value: notificaciones,
            onChanged: cambiarNotificaciones,
          ),

          const Divider(),

          // 🔹 INFO APP
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(t.acercaDe),
            subtitle: const Text("Versión 1.0"),
          ),

          // 🔹 RESET
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: Text(t.restablecer),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(t.confirmar),
                  content: Text(t.borrarAjustes),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(t.cancelar),
                    ),
                    TextButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();

                        if (context.mounted) {
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(t.ajustesReiniciados),
                            ),
                          );

                          // 🔥 RESET GLOBAL
                          MyApp.setTheme(context, false);
                          MyApp.setLocale(context, const Locale('es'));
                        }
                      },
                      child: Text(t.eliminar),
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