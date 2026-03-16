import 'package:flutter/material.dart';

import 'consent/cookie_banner.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [child ?? const SizedBox.shrink(), const CookieBanner()],
    );
  }
}
