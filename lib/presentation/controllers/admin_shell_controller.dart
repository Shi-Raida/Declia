import 'package:get/get.dart';

import '../../core/logger/app_logger.dart';
import '../models/user_view_model.dart';
import '../services/navigation_service.dart';
import 'auth_state_controller.dart';

final class AdminShellController extends GetxController {
  AdminShellController(this._authState, this._nav, this._logger);

  final AuthStateController _authState;
  final NavigationService _nav;
  final AppLogger _logger;

  final currentRoute = ''.obs;

  Rxn<UserViewModel> get currentUser => _authState.currentUser;

  @override
  void onInit() {
    super.onInit();
    currentRoute.value = _nav.currentRoute;
    _logger.debug(
      'AdminShellController initialized, route: ${currentRoute.value}',
    );
  }

  Future<void> logout() async {
    _logger.debug('Admin shell: logging out');
    await _authState.signOut();
    _nav.toLogin();
  }

  void navigateTo(String route) {
    _logger.debug('Admin shell: navigating to $route');
    currentRoute.value = route;
    _nav.toAdminPage(route);
  }
}
