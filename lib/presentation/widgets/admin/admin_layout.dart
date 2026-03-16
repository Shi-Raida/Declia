import 'package:flutter/material.dart';

import '../../theme/app_breakpoints.dart';
import '../../theme/app_colors.dart';
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

    if (isMobile) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        drawer: const AdminSidebar(),
        body: Column(
          children: [
            AdminTopbar(title: title, showMenuButton: true),
            Expanded(child: body),
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
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
