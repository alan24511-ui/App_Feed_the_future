import 'package:flutter/material.dart';
import 'theme/theme.dart';
import 'screens/logo_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: LogoScreen(),
    );
  }
}