import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/admin_shell_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_durations.dart';
import '../../translations/translation_keys.dart';

class AdminTopbar extends GetView<AdminShellController> {
  const AdminTopbar({
    super.key,
    required this.title,
    required this.showMenuButton,
  });

  final String title;
  final bool showMenuButton;

  static const double height = 60;

  @override
  Widget build(BuildContext context) {
    final animatedTitle = Expanded(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: AppDurations.adminPageFadeIn,
        curve: Curves.easeOut,
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: child,
        ),
        child: Text(
          title,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.encre,
          ),
        ),
      ),
    );

    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (showMenuButton)
            IconButton(
              icon: const Icon(Icons.menu, color: AppColors.encre),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: 'Menu',
            ),
          if (showMenuButton) const SizedBox(width: 4),
          animatedTitle,
          Obx(() {
            final user = controller.currentUser.value;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (user != null)
                  Text(
                    user.email,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: AppColors.pierre,
                    ),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.logout, color: AppColors.pierre),
                  tooltip: Tr.adminTopbarLogout.tr,
                  onPressed: controller.logout,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
