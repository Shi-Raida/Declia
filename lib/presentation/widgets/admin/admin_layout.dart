import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/admin_shell_controller.dart';
import '../../theme/app_breakpoints.dart';
import '../../theme/app_colors.dart';
import 'admin_sidebar.dart';
import 'admin_topbar.dart';

class AdminLayout extends StatefulWidget {
  const AdminLayout({super.key, required this.body, this.title = ''});

  final Widget body;
  final String title;

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = Get.find<AdminShellController>();
      final route = Get.currentRoute;
      if (ctrl.currentRoute.value != route) {
        ctrl.currentRoute.value = route;
      }
    });
  }

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
            AdminTopbar(title: widget.title, showMenuButton: true),
            Expanded(child: widget.body),
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
                AdminTopbar(title: widget.title, showMenuButton: false),
                Expanded(child: widget.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
