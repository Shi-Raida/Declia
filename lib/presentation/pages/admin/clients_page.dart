import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/admin/admin_layout.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: Tr.adminSidebarClients.tr,
      body: Center(
        child: Text(
          Tr.adminPlaceholderComingSoon.tr,
          style: AppTypography.heading3(),
        ),
      ),
    );
  }
}
