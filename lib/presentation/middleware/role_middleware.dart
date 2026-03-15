import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/enums/user_role.dart';
import '../controllers/auth_state_controller.dart';
import '../routes/app_routes.dart';
import '../routes/route_args.dart';

final class RoleMiddleware extends GetMiddleware {
  RoleMiddleware(
    this._authState,
    this.allowedRoles, {
    this.redirectRoute = AppRoutes.login,
  });

  final AuthStateController _authState;
  final Set<UserRole> allowedRoles;
  final String redirectRoute;

  @override
  RouteSettings? redirect(String? route) {
    final user = _authState.currentUser.value;
    if (user == null || !allowedRoles.contains(user.role)) {
      return RouteSettings(
        name: redirectRoute,
        arguments: RouteArgs.unauthorizedRole,
      );
    }
    return null;
  }
}
