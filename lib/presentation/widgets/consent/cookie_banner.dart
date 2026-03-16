import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/enums/consent_type.dart';
import '../../controllers/cookie_consent_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';

class CookieBanner extends GetView<CookieConsentController> {
  const CookieBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.showBanner.value) return const SizedBox.shrink();
      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Material(
          elevation: 8,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: const BoxDecoration(
              color: AppColors.bgCard,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Obx(
              () => controller.showCustomize.value
                  ? _CustomizePanel(controller: controller)
                  : _DefaultPanel(controller: controller),
            ),
          ),
        ),
      );
    });
  }
}

class _DefaultPanel extends StatelessWidget {
  const _DefaultPanel({required this.controller});

  final CookieConsentController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Tr.cookieBannerTitle.tr, style: AppTypography.heading4()),
        const SizedBox(height: AppSpacing.sm),
        Text(Tr.cookieBannerDescription.tr, style: AppTypography.bodySmall()),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            ElevatedButton(
              onPressed: controller.acceptAll,
              child: Text(Tr.cookieBannerAcceptAll.tr),
            ),
            OutlinedButton(
              onPressed: controller.refuseAll,
              child: Text(Tr.cookieBannerRefuseAll.tr),
            ),
            TextButton(
              onPressed: controller.toggleCustomize,
              child: Text(Tr.cookieBannerCustomize.tr),
            ),
            TextButton(
              onPressed: controller.openPrivacyPolicy,
              child: Text(
                Tr.cookieBannerPrivacyPolicy.tr,
                style: AppTypography.bodySmall().copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CustomizePanel extends StatelessWidget {
  const _CustomizePanel({required this.controller});

  final CookieConsentController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Tr.cookieBannerCustomize.tr, style: AppTypography.heading4()),
        const SizedBox(height: AppSpacing.md),
        ...ConsentType.values.map(
          (type) => Obx(
            () => CheckboxListTile(
              title: Text(_typeLabel(type).tr),
              value: controller.choices[type] ?? false,
              onChanged: (v) => controller.setChoice(type, value: v ?? false),
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            ElevatedButton(
              onPressed: controller.saveCustom,
              child: Text(Tr.cookieBannerSavePreferences.tr),
            ),
            TextButton(
              onPressed: controller.toggleCustomize,
              child: Text(Tr.cookieBannerRefuseAll.tr),
            ),
          ],
        ),
      ],
    );
  }

  String _typeLabel(ConsentType type) => switch (type) {
    ConsentType.analytics => Tr.cookieBannerAnalytics,
    ConsentType.marketing => Tr.cookieBannerMarketing,
    ConsentType.functional => Tr.cookieBannerFunctional,
  };
}
