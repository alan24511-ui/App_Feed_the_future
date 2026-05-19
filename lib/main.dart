import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'l10n/app_localizations.dart';
import 'screens/login.dart';
import 'services/notificacion_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔥 INICIALIZAR NOTIFICACIONES
  await NotificacionService.init();

  // 🔥 PROGRAMAR RECORDATORIOS
  await NotificacionService
      .programarNotificaciones();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  static void setLocale(
      BuildContext context,
      Locale locale,
      ) {

    final state =
    context.findAncestorStateOfType<_MyAppState>();

    state?.cambiarIdioma(locale);
  }

  static void setTheme(
      BuildContext context,
      bool oscuro,
      ) {

    final state =
    context.findAncestorStateOfType<_MyAppState>();

    state?.cambiarTema(oscuro);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Locale _locale = const Locale('es');

  bool _modoOscuro = false;

  @override
  void initState() {
    super.initState();

    cargarPreferencias();
  }

  // 🔥 CARGAR PREFERENCIAS
  Future<void> cargarPreferencias() async {

    final prefs =
    await SharedPreferences.getInstance();

    final lang =
        prefs.getString('idioma') ?? 'es';

    final dark =
        prefs.getBool('modoOscuro') ?? false;

    setState(() {

      _locale = Locale(lang);

      _modoOscuro = dark;
    });
  }

  // 🔥 CAMBIAR IDIOMA
  void cambiarIdioma(Locale locale) async {

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      'idioma',
      locale.languageCode,
    );

    setState(() {

      _locale = locale;
    });
  }

  // 🔥 CAMBIAR TEMA
  void cambiarTema(bool oscuro) async {

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setBool(
      'modoOscuro',
      oscuro,
    );

    setState(() {

      _modoOscuro = oscuro;
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🔥 IDIOMA
      locale: _locale,

      supportedLocales: const [
        Locale('es'),
        Locale('en'),
      ],

      localizationsDelegates: const [

        AppLocalizations.delegate,

        GlobalMaterialLocalizations.delegate,

        GlobalWidgetsLocalizations.delegate,

        GlobalCupertinoLocalizations.delegate,
      ],

      // 🔥 TEMA
      themeMode:
      _modoOscuro
          ? ThemeMode.dark
          : ThemeMode.light,

      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),

      // 🔥 RUTAS
      initialRoute: '/',

      routes: {
        '/': (context) => const Login(),
      },
    );
  }
}