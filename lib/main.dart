import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_theme.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/insumos_screen.dart';
import 'screens/maquinarios_screen.dart';
import 'screens/colaboradores_screen.dart';

// Data layer
import 'data/api_client.dart';
import 'data/repositories/collaborators_repository.dart';
import 'data/repositories/insumos_repository.dart';
import 'data/repositories/machines_repository.dart';

// State (notifiers)
import 'state/collaborators_notifier.dart';
import 'state/insumos_notifier.dart';
import 'state/machines_notifier.dart';

void main() {
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Cliente HTTP base
        Provider<ApiClient>(create: (_) => ApiClient()),

        // Repositories (dependem do ApiClient)
        ProxyProvider<ApiClient, CollaboratorsRepository>(
          update: (_, api, __) => CollaboratorsRepository(api),
        ),
        ProxyProvider<ApiClient, InsumosRepository>(
          update: (_, api, __) => InsumosRepository(api),
        ),
        ProxyProvider<ApiClient, MachinesRepository>(
          update: (_, api, __) => MachinesRepository(api),
        ),

        // Notifiers (estado) — já fazem o load inicial
        ChangeNotifierProxyProvider<
          CollaboratorsRepository,
          CollaboratorsNotifier
        >(
          create: (ctx) =>
              CollaboratorsNotifier(ctx.read<CollaboratorsRepository>())
                ..load(page: 1),
          update: (ctx, repo, notifier) => notifier!..load(page: 1),
        ),
        ChangeNotifierProxyProvider<InsumosRepository, InsumosNotifier>(
          create: (ctx) =>
              InsumosNotifier(ctx.read<InsumosRepository>())..load(page: 1),
          update: (ctx, repo, notifier) => notifier!..load(page: 1),
        ),
        ChangeNotifierProxyProvider<MachinesRepository, MachinesNotifier>(
          create: (ctx) =>
              MachinesNotifier(ctx.read<MachinesRepository>())..load(page: 1),
          update: (ctx, repo, notifier) => notifier!..load(page: 1),
        ),
      ],
      child: const MyApp(),
    );
  }
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
