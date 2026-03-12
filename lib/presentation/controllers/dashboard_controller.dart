import 'package:get/get.dart';

import '../../domain/entities/app_user.dart';
import '../services/navigation_service.dart';
import 'auth_state_controller.dart';

final class DashboardController extends GetxController {
  DashboardController(this._authState, this._nav);

  final AuthStateController _authState;
  final NavigationService _nav;

  Rxn<AppUser> get currentUser => _authState.currentUser;

  Future<void> logout() async {
    await _authState.signOut();
    _nav.toLogin();
  }
}
