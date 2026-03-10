import 'package:get/get.dart';

import '../../domain/entities/app_user.dart';
import '../routes/app_routes.dart';
import 'auth_state_controller.dart';

class DashboardController extends GetxController {
  final currentUser = Rxn<AppUser>();

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  void _loadUser() {
    currentUser.value = Get.find<AuthStateController>().currentUser.value;
  }

  Future<void> logout() async {
    await Get.find<AuthStateController>().signOut();
    Get.offAllNamed(AppRoutes.login);
  }
}
