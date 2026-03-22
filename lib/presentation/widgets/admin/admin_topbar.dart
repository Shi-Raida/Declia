import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/admin_shell_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_durations.dart';

class AdminTopbar extends GetView<AdminShellController> {
  const AdminTopbar({
    super.key,
    required this.title,
    required this.showMenuButton,
    this.subtitle,
    this.actions,
  });

  final String title;
  final bool showMenuButton;
  final String? subtitle;
  final List<Widget>? actions;

  static const double height = 60;
  static const double heightWithSubtitle = 76;

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = subtitle != null ? heightWithSubtitle : height;

    final titleColumn = TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: AppDurations.adminPageFadeIn,
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.encre,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: GoogleFonts.outfit(fontSize: 12, color: AppColors.pierre),
            ),
        ],
      ),
    );

    return Container(
      height: effectiveHeight,
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
          titleColumn,
          const Spacer(),
          if (actions != null) ...actions!,
          if (actions != null) const SizedBox(width: 16),
          // Notification bell
          Obx(() {
            final user = controller.currentUser.value;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border, width: 1.5),
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Icon(
                          Icons.notifications_outlined,
                          size: 18,
                          color: AppColors.pierre,
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.terracotta,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // User avatar
                if (user != null)
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.terracotta,
                    child: Text(
                      user.email.isNotEmpty ? user.email[0].toUpperCase() : '?',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
