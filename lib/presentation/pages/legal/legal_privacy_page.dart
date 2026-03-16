import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../translations/translation_keys.dart';
import '../../theme/app_typography.dart';

class LegalPrivacyPage extends StatelessWidget {
  const LegalPrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Tr.legalPrivacyTitle.tr)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          Tr.legalPrivacyContent.tr,
          style: AppTypography.bodyMedium(),
        ),
      ),
    );
  }
}
