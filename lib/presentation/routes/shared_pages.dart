import 'package:get/get.dart';

import '../pages/auth/auth_binding.dart';
import '../pages/auth/auth_page.dart';
import '../pages/shared/home_binding.dart';
import '../pages/shared/home_page.dart';
import 'app_routes.dart';

final List<GetPage<dynamic>> sharedPages = [
  GetPage<void>(
    name: AppRoutes.home,
    page: () => const HomePage(),
    binding: HomeBinding(),
  ),
  GetPage<void>(
    name: AppRoutes.login,
    page: () => const AuthPage(),
    binding: AuthBinding(),
  ),
  GetPage<void>(
    name: AppRoutes.authRegister,
    page: () => const AuthPage(),
    binding: AuthBinding(),
  ),
  GetPage<void>(
    name: AppRoutes.authForgotPassword,
    page: () => const AuthPage(),
    binding: AuthBinding(),
  ),
];
