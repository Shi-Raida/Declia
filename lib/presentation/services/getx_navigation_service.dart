import 'package:get/get.dart';

import '../../core/enums/user_role.dart';
import '../routes/app_routes.dart';
import 'navigation_service.dart';

final class GetxNavigationService implements NavigationService {
  @override
  String get currentRoute => Get.currentRoute;

  @override
  void toLogin({String? reason}) =>
      Get.offAllNamed(AppRoutes.login, arguments: reason);

  @override
  void toHome(UserRole role) {
    switch (role) {
      case UserRole.client:
        toClientHome();
      case UserRole.photographer:
      case UserRole.tech:
        toDashboard();
    }
  }

  @override
  void toDashboard() => Get.offAllNamed(AppRoutes.adminDashboard);

  @override
  void toAdminPage(String route) => Get.offAllNamed(route);

  @override
  void toClientLogin() => Get.offAllNamed(AppRoutes.clientLogin);

  @override
  void toClientHome() => Get.offAllNamed(AppRoutes.clientHome);

  @override
  void toClientRegister({required String tenantSlug}) => Get.offAllNamed(
    AppRoutes.clientRegister,
    parameters: {'tenant': tenantSlug},
  );

  @override
  void toClientForgotPassword() =>
      Get.offAllNamed(AppRoutes.clientForgotPassword);
}
