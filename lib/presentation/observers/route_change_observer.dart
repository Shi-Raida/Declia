import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/admin_shell_controller.dart';

final class RouteChangeObserver extends NavigatorObserver {
  void _sync() {
    if (Get.isRegistered<AdminShellController>()) {
      Get.find<AdminShellController>().syncRoute(Get.currentRoute);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => _sync();

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => _sync();

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      _sync();
}
