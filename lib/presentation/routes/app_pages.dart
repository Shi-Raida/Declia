import 'package:get/get.dart';

import '../../core/enums/user_role.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/role_middleware.dart';
import '../pages/admin/dashboard_binding.dart';
import '../pages/admin/dashboard_page.dart';
import '../pages/auth/login_binding.dart';
import '../pages/auth/login_page.dart';
import '../pages/shared/home_binding.dart';
import '../pages/shared/home_page.dart';
import 'app_routes.dart';

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
    middlewares: [
      AuthMiddleware(),
      RoleMiddleware({UserRole.photographer}),
    ],
  ),
];
