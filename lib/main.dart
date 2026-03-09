import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'presentation/routes/app_pages.dart';
import 'presentation/routes/app_routes.dart';
import 'presentation/theme/app_theme.dart';

void main() {
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
