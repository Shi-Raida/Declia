import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/enums/availability_rule_type.dart';
import '../../../domain/entities/availability_rule.dart';
import '../../controllers/availability_controller.dart';
import '../../controllers/planning_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import 'planning_editor_slot_grid.dart';
import 'planning_editor_weekly_summary.dart';

class PlanningEditorTab extends StatelessWidget {
  const PlanningEditorTab({super.key, required this.availabilityController});

  final AvailabilityController availabilityController;

  PlanningController get planningController => Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Intro card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bleuOuvert.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.bleuOuvert.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.bleuOuvert,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    Tr.admin.planning.editorIntro.tr,
                    style: AppTypography.bodySmall().copyWith(
                      color: AppColors.bleuOuvert,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Quick fill buttons
          Row(
            children: [
              _QuickFillButton(
                label: Tr.admin.planning.quickFillWeek.tr,
                icon: Icons.calendar_view_week_outlined,
                onPressed: () => _quickFillWeek(context),
              ),
              const SizedBox(width: 8),
              _QuickFillButton(
                label: Tr.admin.planning.quickFillMorning.tr,
                icon: Icons.wb_sunny_outlined,
                onPressed: () => _quickFillMorning(context),
              ),
              const SizedBox(width: 8),
              _QuickFillButton(
                label: Tr.admin.planning.quickFillAfternoon.tr,
                icon: Icons.wb_twilight_outlined,
                onPressed: () => _quickFillAfternoon(context),
              ),
              const Spacer(),
              _QuickFillButton(
                label: Tr.admin.planning.quickFillClear.tr,
                icon: Icons.clear_all,
                onPressed: () => _confirmClearAll(context),
                destructive: true,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Slot grid
          Expanded(
            child: Obx(() {
              final focusedDate = planningController.focusedDate.value;
              final rules = availabilityController.availabilityRules;
              return SlotGrid(
                focusedDate: focusedDate,
                rules: rules.toList(),
                availabilityController: availabilityController,
              );
            }),
          ),
          const SizedBox(height: 12),

          // Weekly summary
          Obx(() {
            final rules = availabilityController.availabilityRules
                .where((r) => r.ruleType == AvailabilityRuleType.recurring)
                .toList();
            return WeeklySummary(rules: rules);
          }),
          const SizedBox(height: 12),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => planningController.selectedTab.value = 0,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.pierre,
                ),
                child: Text(Tr.admin.planning.editorCancel.tr),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: () {
                  // Rules are saved immediately via the controller
                  planningController.selectedTab.value = 0;
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.terracotta,
                ),
                child: Text(Tr.admin.planning.editorSave.tr),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _quickFillWeek(BuildContext context) async {
    for (int day = 1; day <= 5; day++) {
      await availabilityController.createRule(_makeRule(day, '09:00', '12:00'));
      await availabilityController.createRule(_makeRule(day, '14:00', '18:00'));
    }
  }

  Future<void> _quickFillMorning(BuildContext context) async {
    for (int day = 1; day <= 5; day++) {
      await availabilityController.createRule(_makeRule(day, '09:00', '12:00'));
    }
  }

  Future<void> _quickFillAfternoon(BuildContext context) async {
    for (int day = 1; day <= 5; day++) {
      await availabilityController.createRule(_makeRule(day, '14:00', '18:00'));
    }
  }

  void _confirmClearAll(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          Tr.admin.planning.quickFillClear.tr,
          style: AppTypography.heading4(),
        ),
        content: Text(
          Tr.admin.planning.editorClearConfirm.tr,
          style: AppTypography.bodyMedium(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              Tr.admin.planning.editorCancel.tr,
              style: AppTypography.button().copyWith(color: AppColors.pierre),
            ),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final recurringRules = availabilityController.availabilityRules
                  .where((r) => r.ruleType == AvailabilityRuleType.recurring)
                  .toList();
              for (final rule in recurringRules) {
                await availabilityController.deleteRule(rule.id);
              }
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(
              Tr.admin.planning.quickFillClear.tr,
              style: AppTypography.button(),
            ),
          ),
        ],
      ),
    );
  }

  static AvailabilityRule _makeRule(int dayOfWeek, String start, String end) {
    final now = DateTime.now();
    return AvailabilityRule(
      id: '',
      tenantId: '',
      ruleType: AvailabilityRuleType.recurring,
      dayOfWeek: dayOfWeek,
      startTime: start,
      endTime: end,
      createdAt: now,
      updatedAt: now,
    );
  }
}

class _QuickFillButton extends StatelessWidget {
  const _QuickFillButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.destructive = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: destructive ? AppColors.error : AppColors.crepuscule,
        side: BorderSide(
          color: destructive ? AppColors.error : AppColors.border,
        ),
        textStyle: AppTypography.button(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
