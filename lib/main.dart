import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';

import 'l10n/app_localizations.dart';

import 'screens/login.dart';
import 'screens/home_screen.dart';

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

      // 🔥 MANTENER SESIÓN INICIADA
      home: StreamBuilder<User?>(
        stream:
        FirebaseAuth.instance.authStateChanges(),

        builder: (context, snapshot) {

          // 🔄 CARGANDO
          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // ✅ USUARIO LOGUEADO
          if (snapshot.hasData) {

            final user = snapshot.data!;

            return HomeScreen(
              nombre:
              user.displayName ?? "Usuario",

              imc: 0,
            );
          }

          // ❌ NO LOGUEADO
          return const Login();
        },
      ),
    );
  }
}