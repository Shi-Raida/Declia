import 'package:get/get.dart';

import '../pages/shared/home_binding.dart';
import '../pages/shared/home_page.dart';
import 'app_routes.dart';

final List<GetPage<dynamic>> appPages = [
  GetPage<void>(
    name: AppRoutes.home,
    page: () => const HomePage(),
    binding: HomeBinding(),
  ),
];
