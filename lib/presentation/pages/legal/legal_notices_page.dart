import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../translations/translation_keys.dart';
import '../../theme/app_typography.dart';

class LegalNoticesPage extends StatelessWidget {
  const LegalNoticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Tr.common.legal.noticesTitle.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          Tr.common.legal.noticesContent.tr,
          style: AppTypography.bodyMedium(),
        ),
      ),
    );
  }
}
