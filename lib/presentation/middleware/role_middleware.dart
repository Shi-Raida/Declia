import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/enums/user_role.dart';
import '../controllers/auth_state_controller.dart';
import '../routes/app_routes.dart';
import '../routes/route_args.dart';

final class RoleMiddleware extends GetMiddleware {
  RoleMiddleware(this.allowedRoles);

  final Set<UserRole> allowedRoles;

  @override
  RouteSettings? redirect(String? route) {
    final user = Get.find<AuthStateController>().currentUser.value;
    if (user == null || !allowedRoles.contains(user.role)) {
      return const RouteSettings(
        name: AppRoutes.login,
        arguments: RouteArgs.unauthorizedRole,
      );
    }
    return null;
  }
}
