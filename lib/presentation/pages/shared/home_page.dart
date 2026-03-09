import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Declia',
                style: AppTypography.heading1().copyWith(
                  color: AppColors.prune,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'La plateforme des photographes professionnels',
                style: AppTypography.bodyLarge().copyWith(
                  color: AppColors.warmGray,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(onPressed: () {}, child: const Text('Commencer')),
            ],
          ),
        ),
      ),
    );
  }
}
