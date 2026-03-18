import 'package:get/get.dart';

import '../../core/enums/user_role.dart';
import '../controllers/auth_state_controller.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/role_middleware.dart';
import '../pages/client/client_forgot_password_binding.dart';
import '../pages/client/client_forgot_password_page.dart';
import '../pages/client/client_home_binding.dart';
import '../pages/client/client_home_page.dart';
import '../pages/client/client_login_binding.dart';
import '../pages/client/client_login_page.dart';
import '../pages/client/client_register_binding.dart';
import '../pages/client/client_register_page.dart';
import 'app_routes.dart';

final List<GetPage<dynamic>> clientPages = [
  GetPage<void>(
    name: AppRoutes.clientLogin,
    page: () => const ClientLoginPage(),
    binding: ClientLoginBinding(),
  ),
  GetPage<void>(
    name: AppRoutes.clientRegister,
    page: () => const ClientRegisterPage(),
    binding: ClientRegisterBinding(),
  ),
  GetPage<void>(
    name: AppRoutes.clientForgotPassword,
    page: () => const ClientForgotPasswordPage(),
    binding: ClientForgotPasswordBinding(),
  ),
  GetPage<void>(
    name: AppRoutes.clientHome,
    page: () => const ClientHomePage(),
    binding: ClientHomeBinding(),
    middlewares: [
      AuthMiddleware(
        Get.find<AuthStateController>(),
        redirectRoute: AppRoutes.clientLogin,
      ),
      RoleMiddleware(Get.find<AuthStateController>(), {
        UserRole.client,
      }, redirectRoute: AppRoutes.clientLogin),
    ],
  ),
];
