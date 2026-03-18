import 'package:get/get.dart';

import '../pages/legal/legal_notices_page.dart';
import '../pages/legal/legal_privacy_page.dart';
import 'app_routes.dart';

final List<GetPage<dynamic>> legalPages = [
  GetPage<void>(
    name: AppRoutes.legalPrivacy,
    page: () => const LegalPrivacyPage(),
  ),
  GetPage<void>(
    name: AppRoutes.legalNotices,
    page: () => const LegalNoticesPage(),
  ),
];
