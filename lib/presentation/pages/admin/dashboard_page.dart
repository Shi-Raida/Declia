import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/dashboard_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/admin/admin_layout.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: Tr.dashboardTitle.tr,
      body: Center(
        child: Obx(() {
          final user = controller.currentUser.value;
          if (user == null) {
            return const CircularProgressIndicator();
          }
          return Text(
            Tr.dashboardWelcome.tr.replaceAll('@email', user.email),
            style: AppTypography.heading3().copyWith(
              color: AppColors.crepuscule,
            ),
          );
        }),
      ),
    );
  }
}
