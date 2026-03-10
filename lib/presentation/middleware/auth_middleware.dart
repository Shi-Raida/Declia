import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_state_controller.dart';
import '../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final controller = Get.find<AuthStateController>();
    if (!controller.isAuthenticated) {
      return const RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}
