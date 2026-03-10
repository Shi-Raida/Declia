import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'infrastructure/config/app_config.dart';
import 'infrastructure/di/injection.dart';
import 'presentation/di/presentation_injection.dart';
import 'presentation/routes/app_pages.dart';
import 'presentation/routes/app_routes.dart';
import 'presentation/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  await runZonedGuarded(_bootstrap, (error, stack) {
    debugPrint('Uncaught async error: $error\n$stack');
  });
}

Future<void> _bootstrap() async {
  try {
    await dotenv.load();
    final config = AppConfig(
      supabaseUrl:
          dotenv.env['SUPABASE_URL'] ??
          (throw StateError('SUPABASE_URL not set')),
      supabaseAnonKey:
          dotenv.env['SUPABASE_ANON_KEY'] ??
          (throw StateError('SUPABASE_ANON_KEY not set')),
    );
    await Injection.init(config);
    PresentationInjection.init();
    runApp(const DecliaApp());
  } catch (error, stack) {
    debugPrint('Bootstrap failed: $error\n$stack');
    runApp(_BootstrapErrorApp(error: error));
  }
}

class DecliaApp extends StatelessWidget {
  const DecliaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Declia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.home,
      getPages: appPages,
    );
  }
}

class _BootstrapErrorApp extends StatelessWidget {
  const _BootstrapErrorApp({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Center(child: Text('Erreur de démarrage: $error'))),
    );
  }
}
