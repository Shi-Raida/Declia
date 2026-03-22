import 'package:get/get.dart';

import '../../core/enums/user_role.dart';
import '../controllers/auth_state_controller.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/role_middleware.dart';
import '../pages/client/client_home_binding.dart';
import '../pages/client/client_home_page.dart';
import 'app_routes.dart';

final List<GetPage<dynamic>> clientPages = [
  GetPage<void>(
    name: AppRoutes.clientHome,
    page: () => const ClientHomePage(),
    binding: ClientHomeBinding(),
    middlewares: [
      AuthMiddleware(
        Get.find<AuthStateController>(),
        redirectRoute: AppRoutes.login,
      ),
      RoleMiddleware(Get.find<AuthStateController>(), {
        UserRole.client,
      }, redirectRoute: AppRoutes.login),
    ],
  ),
];
