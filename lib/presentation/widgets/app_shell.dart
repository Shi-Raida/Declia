import 'package:flutter/material.dart';

import 'consent/cookie_banner.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.child});

  final Widget? child;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _firstFrameDone = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _firstFrameDone = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child ?? const SizedBox.shrink(),
        if (_firstFrameDone) const CookieBanner(),
      ],
    );
  }
}
