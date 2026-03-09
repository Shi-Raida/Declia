import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'infrastructure/config/app_config.dart';
import 'presentation/routes/app_pages.dart';
import 'presentation/routes/app_routes.dart';
import 'presentation/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final config = AppConfig(
    supabaseUrl:
        dotenv.env['SUPABASE_URL'] ??
        (throw StateError('SUPABASE_URL not set')),
    supabaseAnonKey:
        dotenv.env['SUPABASE_ANON_KEY'] ??
        (throw StateError('SUPABASE_ANON_KEY not set')),
  );
  Get.put(config);
  await Supabase.initialize(
    url: config.supabaseUrl,
    anonKey: config.supabaseAnonKey,
  );
  runApp(const DecliaApp());
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
