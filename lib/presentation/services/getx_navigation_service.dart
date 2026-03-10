import 'package:get/get.dart';

import '../routes/app_routes.dart';
import 'navigation_service.dart';

final class GetxNavigationService implements NavigationService {
  @override
  void toLogin({String? reason}) =>
      Get.offAllNamed(AppRoutes.login, arguments: reason);

  @override
  void toDashboard() => Get.offAllNamed(AppRoutes.adminDashboard);
}
