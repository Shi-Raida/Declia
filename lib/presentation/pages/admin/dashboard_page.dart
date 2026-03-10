import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/dashboard_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
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
            'Bienvenue, ${user.email}',
            style: AppTypography.heading3().copyWith(color: AppColors.prune),
          );
        }),
      ),
    );
  }
}
