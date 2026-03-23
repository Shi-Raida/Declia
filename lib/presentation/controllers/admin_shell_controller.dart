import 'package:get/get.dart';

import '../../core/logger/app_logger.dart';
import '../models/user_view_model.dart';
import '../services/auth_navigation_service.dart';
import '../services/shell_navigation_service.dart';
import 'auth_state_controller.dart';

final class AdminShellController extends GetxController {
  AdminShellController(
    this._authState,
    this._authNav,
    this._shellNav,
    this._logger,
  );

  final AuthStateController _authState;
  final AuthNavigationService _authNav;
  final ShellNavigationService _shellNav;
  final AppLogger _logger;

  final currentRoute = ''.obs;

  Rxn<UserViewModel> get currentUser => _authState.currentUser;

  @override
  void onInit() {
    super.onInit();
    currentRoute.value = _shellNav.currentRoute;
    _logger.debug(
      'AdminShellController initialized, route: ${currentRoute.value}',
    );
  }

  Future<void> logout() async {
    _logger.debug('Admin shell: logging out');
    await _authState.signOut();
    _authNav.toLogin();
  }

  void navigateTo(String route) {
    _logger.debug('Admin shell: navigating to $route');
    currentRoute.value = route;
    _shellNav.toAdminPage(route);
  }

  void syncRoute(String route) => currentRoute.value = route;
}
