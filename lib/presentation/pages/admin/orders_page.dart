import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/admin/admin_layout.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: Tr.adminSidebarOrders.tr,
      body: Center(
        child: Text(
          Tr.adminPlaceholderComingSoon.tr,
          style: AppTypography.heading3(),
        ),
      ),
    );
  }
}
