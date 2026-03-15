import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_state_controller.dart';
import '../routes/app_routes.dart';

final class AuthMiddleware extends GetMiddleware {
  AuthMiddleware(this._authState, {this.redirectRoute = AppRoutes.login});
  final AuthStateController _authState;
  final String redirectRoute;

  @override
  RouteSettings? redirect(String? route) {
    if (!_authState.isAuthenticated) {
      return RouteSettings(name: redirectRoute);
    }
    return null;
  }
}
