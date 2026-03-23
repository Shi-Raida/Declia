import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';

/// CGU consent row with tappable links for CGU and privacy policy.
Widget registerCguConsentRow({
  required bool value,
  required ValueChanged<bool> onChanged,
  required Color accentColor,
}) {
  final style = AppTypography.bodySmall();
  final linkStyle = style.copyWith(
    color: accentColor,
    decoration: TextDecoration.underline,
    decorationColor: accentColor,
  );

  return GestureDetector(
    onTap: () => onChanged(!value),
    behavior: HitTestBehavior.opaque,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
            activeColor: accentColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: Tr.auth.register.consentCguPrefix.tr,
                  style: style,
                ),
                TextSpan(
                  text: Tr.auth.register.consentCguLink.tr,
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.toNamed(AppRoutes.legalNotices),
                ),
                TextSpan(
                  text: Tr.auth.register.consentCguMiddle.tr,
                  style: style,
                ),
                TextSpan(
                  text: Tr.auth.register.consentPrivacyLink.tr,
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.toNamed(AppRoutes.legalPrivacy),
                ),
                TextSpan(text: ' *', style: style),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

/// Simple consent row with a checkbox and label text.
Widget registerConsentRow({
  required bool value,
  required ValueChanged<bool> onChanged,
  required String label,
  required Color accentColor,
}) {
  return GestureDetector(
    onTap: () => onChanged(!value),
    behavior: HitTestBehavior.opaque,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
            activeColor: accentColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: AppTypography.bodySmall())),
      ],
    ),
  );
}
