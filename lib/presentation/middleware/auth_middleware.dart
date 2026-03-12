import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_state_controller.dart';
import '../routes/app_routes.dart';

final class AuthMiddleware extends GetMiddleware {
  AuthMiddleware(this._authState);
  final AuthStateController _authState;

  @override
  RouteSettings? redirect(String? route) {
    if (!_authState.isAuthenticated) {
      return const RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}
