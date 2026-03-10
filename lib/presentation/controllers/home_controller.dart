import 'package:get/get.dart';

import '../../usecases/auth/get_current_user.dart';
import '../../usecases/usecase.dart';
import '../routes/app_routes.dart';
import 'auth_state_controller.dart';

class HomeController extends GetxController {
  HomeController(this._getCurrentUser);

  final GetCurrentUser _getCurrentUser;

  @override
  void onReady() {
    super.onReady();
    _redirect();
  }

  Future<void> _redirect() async {
    final user = await _getCurrentUser(const NoParams());
    if (user != null) {
      Get.find<AuthStateController>().setUser(user);
      Get.offAllNamed(AppRoutes.adminDashboard);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
