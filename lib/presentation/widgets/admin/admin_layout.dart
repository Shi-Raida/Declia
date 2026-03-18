import 'package:flutter/material.dart';

import '../../theme/app_breakpoints.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_durations.dart';
import 'admin_sidebar.dart';
import 'admin_topbar.dart';

class AdminLayout extends StatelessWidget {
  const AdminLayout({super.key, required this.body, this.title = ''});

  final Widget body;
  final String title;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < AppBreakpoints.mobile;

    final animatedBody = Expanded(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: AppDurations.adminPageFadeIn,
        curve: Curves.easeOut,
        builder: (context, value, child) =>
            Opacity(opacity: value, child: child),
        child: body,
      ),
    );

    if (isMobile) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        drawer: const AdminSidebar(),
        body: Column(
          children: [
            AdminTopbar(title: title, showMenuButton: true),
            animatedBody,
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Row(
        children: [
          const AdminSidebar(),
          Expanded(
            child: Column(
              children: [
                AdminTopbar(title: title, showMenuButton: false),
                animatedBody,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
