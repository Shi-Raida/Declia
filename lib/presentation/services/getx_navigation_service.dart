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
  void toClientHome() => Get.offAllNamed(AppRoutes.clientHome);

  @override
  void toLegalPrivacy() => Get.toNamed(AppRoutes.legalPrivacy);

  @override
  void toClientDetail(String id, {dynamic arguments}) =>
      Get.toNamed('/admin/clients/$id', arguments: arguments);

  @override
  void toClientEdit(String id, {dynamic arguments}) =>
      Get.toNamed('/admin/clients/$id/edit', arguments: arguments);

  @override
  void toClientNew() => Get.toNamed(AppRoutes.adminClientNew);

  @override
  void goBack() => Get.back();
}
