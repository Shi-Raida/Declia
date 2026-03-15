import 'package:get/get.dart';

import '../../core/enums/user_role.dart';
import '../controllers/auth_state_controller.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/role_middleware.dart';
import '../pages/admin/clients_page.dart';
import '../pages/admin/dashboard_binding.dart';
import '../pages/admin/dashboard_page.dart';
import '../pages/admin/galleries_page.dart';
import '../pages/admin/invoicing_page.dart';
import '../pages/admin/planning_page.dart';
import '../pages/admin/settings_page.dart';
import '../pages/admin/shop_page.dart';
import '../pages/admin/statistics_page.dart';
import '../pages/auth/login_binding.dart';
import '../pages/auth/login_page.dart';
import '../pages/client/client_forgot_password_binding.dart';
import '../pages/client/client_forgot_password_page.dart';
import '../pages/client/client_home_binding.dart';
import '../pages/client/client_home_page.dart';
import '../pages/client/client_login_binding.dart';
import '../pages/client/client_login_page.dart';
import '../pages/client/client_register_binding.dart';
import '../pages/client/client_register_page.dart';
import '../pages/shared/home_binding.dart';
import '../pages/shared/home_page.dart';
import 'app_routes.dart';

List<GetMiddleware> _adminMiddlewares() => [
  AuthMiddleware(Get.find<AuthStateController>()),
  RoleMiddleware(Get.find<AuthStateController>(), {UserRole.photographer}),
];

final List<GetPage<dynamic>> appPages = [
  GetPage<void>(
    name: AppRoutes.home,
    page: () => const HomePage(),
    binding: HomeBinding(),
  ),
  GetPage<void>(
    name: AppRoutes.login,
    page: () => const LoginPage(),
    binding: LoginBinding(),
  ),
  GetPage<void>(
    name: AppRoutes.adminDashboard,
    page: () => const DashboardPage(),
    binding: DashboardBinding(),
    middlewares: _adminMiddlewares(),
  ),
  GetPage<void>(
    name: AppRoutes.adminClients,
    page: () => const ClientsPage(),
    middlewares: _adminMiddlewares(),
  ),
  GetPage<void>(
    name: AppRoutes.adminPlanning,
    page: () => const PlanningPage(),
    middlewares: _adminMiddlewares(),
  ),
  GetPage<void>(
    name: AppRoutes.adminGalleries,
    page: () => const GalleriesPage(),
    middlewares: _adminMiddlewares(),
  ),
  GetPage<void>(
    name: AppRoutes.adminShop,
    page: () => const ShopPage(),
    middlewares: _adminMiddlewares(),
  ),
  GetPage<void>(
    name: AppRoutes.adminInvoicing,
    page: () => const InvoicingPage(),
    middlewares: _adminMiddlewares(),
  ),
  GetPage<void>(
    name: AppRoutes.adminStatistics,
    page: () => const StatisticsPage(),
    middlewares: _adminMiddlewares(),
  ),
  GetPage<void>(
    name: AppRoutes.adminSettings,
    page: () => const SettingsPage(),
    middlewares: _adminMiddlewares(),
  ),
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
