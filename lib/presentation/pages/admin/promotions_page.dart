import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/admin/admin_layout.dart';

class PromotionsPage extends StatelessWidget {
  const PromotionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: Tr.admin.sidebar.promotions.tr,
      body: Center(
        child: Text(
          Tr.admin.placeholder.comingSoon.tr,
          style: AppTypography.heading3(),
        ),
      ),
    );
  }
}
