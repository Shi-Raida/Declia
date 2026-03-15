import 'package:get/get.dart';

import '../../core/logger/app_logger.dart';
import '../models/user_view_model.dart';
import '../services/navigation_service.dart';
import 'auth_state_controller.dart';

final class ClientHomeController extends GetxController {
  ClientHomeController(this._authState, this._nav, this._logger);

  final AuthStateController _authState;
  final NavigationService _nav;
  final AppLogger _logger;

  Rxn<UserViewModel> get currentUser => _authState.currentUser;

  Future<void> logout() async {
    _logger.debug('Client logging out');
    await _authState.signOut();
    _nav.toClientLogin();
  }
}
