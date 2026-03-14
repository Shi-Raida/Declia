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
import 'presentation/translations/app_translations.dart';

Future<void> main() async {
  await runZonedGuarded(_bootstrap, (error, stack) {
    debugPrint('Uncaught async error: $error\n$stack');
  });
}

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

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
      translations: AppTranslations(),
      locale: const Locale('fr', 'FR'),
      fallbackLocale: const Locale('fr', 'FR'),
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
