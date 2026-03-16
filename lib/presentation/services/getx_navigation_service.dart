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
  void toClientRegister({String? tenantSlug}) => Get.toNamed(
    AppRoutes.clientRegister,
    parameters: tenantSlug != null ? {'tenant': tenantSlug} : null,
  );

  @override
  void toClientForgotPassword() => Get.toNamed(AppRoutes.clientForgotPassword);

  @override
  void toLegalPrivacy() => Get.toNamed(AppRoutes.legalPrivacy);
}
