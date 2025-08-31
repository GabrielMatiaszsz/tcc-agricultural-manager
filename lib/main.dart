import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/insumos_screen.dart';
import 'screens/maquinarios_screen.dart';
import 'screens/colaboradores_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador Agrícola',
      theme: AppTheme.theme,
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/insumos': (context) => const InsumosScreen(),
        '/maquinarios': (context) => const MaquinariosScreen(),
        '/colaboradores': (context) => const ColaboradoresScreen(),
      },
    );
  }
}
