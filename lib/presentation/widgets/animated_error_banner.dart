import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class AnimatedErrorBanner extends StatefulWidget {
  const AnimatedErrorBanner({super.key, required this.message});

  final String? message;

  @override
  State<AnimatedErrorBanner> createState() => _AnimatedErrorBannerState();
}

class _AnimatedErrorBannerState extends State<AnimatedErrorBanner>
    with TickerProviderStateMixin {
  late final AnimationController _visibilityController;
  late final AnimationController _shakeController;

  late final Animation<double> _visibilityCurved;

  @override
  void initState() {
    super.initState();

    _visibilityController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: widget.message != null ? 1.0 : 0.0,
    );

    _visibilityCurved = CurvedAnimation(
      parent: _visibilityController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedErrorBanner oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldMsg = oldWidget.message;
    final newMsg = widget.message;

    if (oldMsg == null && newMsg != null) {
      // null → non-null: show + shake
      _visibilityController.forward().then((_) {
        if (mounted) _shakeController.forward(from: 0);
      });
    } else if (oldMsg != null && newMsg == null) {
      // non-null → null: hide
      _visibilityController.reverse();
    } else if (oldMsg != null && newMsg != null && oldMsg != newMsg) {
      // different error: re-shake
      _shakeController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _visibilityController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _visibilityCurved,
      axisAlignment: -1.0,
      child: FadeTransition(
        opacity: _visibilityCurved,
        child: AnimatedBuilder(
          animation: _shakeController,
          builder: (context, child) {
            final dx = sin(_shakeController.value * pi * 3) * 4;
            return Transform.translate(offset: Offset(dx, 0), child: child);
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.errorLight,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: Text(
              widget.message ?? '',
              style: AppTypography.bodyMedium().copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
