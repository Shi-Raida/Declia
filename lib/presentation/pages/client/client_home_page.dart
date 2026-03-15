import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/client_home_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';

class ClientHomePage extends GetView<ClientHomeController> {
  const ClientHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(Tr.clientHomeTitle.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: Tr.clientHomeLogout.tr,
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
            Tr.clientHomeWelcome.tr.replaceAll('@email', user.email),
            style: AppTypography.heading3().copyWith(
              color: AppColors.crepuscule,
            ),
          );
        }),
      ),
    );
  }
}
