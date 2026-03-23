import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/staggered_fade_slide_column.dart';

class AuthLeftPanelFeatures extends StatelessWidget {
  const AuthLeftPanelFeatures({required this.isClient, super.key});

  final bool isClient;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo
        Image.asset('assets/images/logo.png', width: 110, height: 110),
        const SizedBox(height: 40),
        // Tagline + subtitle
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            layoutBuilder: (currentChild, _) =>
                currentChild ?? const SizedBox.shrink(),
            child: StaggeredFadeSlideColumn(
              key: ValueKey('left_$isClient'),
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: isClient
                            ? Tr.auth.login.clientTagline.tr
                            : Tr.auth.login.tagline.tr,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                      TextSpan(
                        text: isClient
                            ? Tr.auth.login.clientTaglineHighlight.tr
                            : Tr.auth.login.taglineHighlight.tr,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                          color: AppColors.or,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isClient
                      ? Tr.auth.login.clientSubtitle.tr
                      : Tr.auth.login.subtitle.tr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.white.withValues(alpha: 0.6),
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 48),
        // Feature bullets
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          layoutBuilder: (currentChild, _) =>
              currentChild ?? const SizedBox.shrink(),
          child: StaggeredFadeSlideColumn(
            key: ValueKey('features_$isClient'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                (isClient
                        ? [
                            Tr.auth.login.clientFeature1.tr,
                            Tr.auth.login.clientFeature2.tr,
                            Tr.auth.login.clientFeature3.tr,
                            Tr.auth.login.clientFeature4.tr,
                          ]
                        : [
                            Tr.auth.login.feature1.tr,
                            Tr.auth.login.feature2.tr,
                            Tr.auth.login.feature3.tr,
                            Tr.auth.login.feature4.tr,
                          ])
                    .map(
                      (feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.or,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              feature,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}
