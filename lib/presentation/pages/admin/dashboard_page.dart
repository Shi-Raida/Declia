import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/dashboard_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(Tr.dashboardTitle.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: Tr.dashboardLogout.tr,
            onPressed: controller.logout,
          ),
        ],
      ),
      body: Center(
        child: Obx(() {
          final user = controller.currentUser.value;
          if (user == null) {
            return const CircularProgressIndicator();
          }
          return Text(
            Tr.dashboardWelcome.tr.replaceAll('@email', user.email),
            style: AppTypography.heading3().copyWith(color: AppColors.prune),
          );
        }),
      ),
    );
  }
}
