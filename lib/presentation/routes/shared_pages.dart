import 'package:get/get.dart';

import '../pages/auth/login_binding.dart';
import '../pages/auth/login_page.dart';
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
    page: () => const LoginPage(),
    binding: LoginBinding(),
  ),
];
