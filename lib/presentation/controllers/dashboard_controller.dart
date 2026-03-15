import 'package:get/get.dart';

import '../models/user_view_model.dart';
import 'auth_state_controller.dart';

final class DashboardController extends GetxController {
  DashboardController(this._authState);

  final AuthStateController _authState;

  Rxn<UserViewModel> get currentUser => _authState.currentUser;
}
