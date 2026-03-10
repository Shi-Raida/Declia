import 'package:get/get.dart';

import '../../domain/entities/app_user.dart';
import '../services/navigation_service.dart';
import 'auth_state_controller.dart';

class DashboardController extends GetxController {
  DashboardController(this._authState, this._nav);

  final AuthStateController _authState;
  final NavigationService _nav;

  final currentUser = Rxn<AppUser>();

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  void _loadUser() {
    currentUser.value = _authState.currentUser.value;
  }

  Future<void> logout() async {
    await _authState.signOut();
    _nav.toLogin();
  }
}
