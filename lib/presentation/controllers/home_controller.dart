import 'package:get/get.dart';

import '../../core/logger/app_logger.dart';
import '../../domain/entities/app_user.dart';
import '../../usecases/usecase.dart';
import '../services/navigation_service.dart';
import 'auth_state_controller.dart';

final class HomeController extends GetxController {
  HomeController(
    this._getCurrentUser,
    this._authState,
    this._nav,
    this._logger,
  );

  final UseCase<AppUser?, NoParams> _getCurrentUser;
  final AuthStateController _authState;
  final NavigationService _nav;
  final AppLogger _logger;

  @override
  void onReady() {
    super.onReady();
    _logger.debug('HomeController initialized');
    _redirect();
  }

  Future<void> _redirect() async {
    final user = await _getCurrentUser(const NoParams());
    if (user != null) {
      _authState.setUser(user);
      _logger.debug('Redirecting to dashboard');
      _nav.toDashboard();
    } else {
      _logger.debug('Redirecting to login');
      _nav.toLogin();
    }
  }
}
