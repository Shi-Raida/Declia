import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/enums/availability_rule_type.dart';
import '../../../domain/entities/availability_rule.dart';
import '../../controllers/availability_controller.dart';
import '../../controllers/planning_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';

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
                    Tr.planningEditorIntro.tr,
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
                label: Tr.planningQuickFillWeek.tr,
                icon: Icons.calendar_view_week_outlined,
                onPressed: () => _quickFillWeek(context),
              ),
              const SizedBox(width: 8),
              _QuickFillButton(
                label: Tr.planningQuickFillMorning.tr,
                icon: Icons.wb_sunny_outlined,
                onPressed: () => _quickFillMorning(context),
              ),
              const SizedBox(width: 8),
              _QuickFillButton(
                label: Tr.planningQuickFillAfternoon.tr,
                icon: Icons.wb_twilight_outlined,
                onPressed: () => _quickFillAfternoon(context),
              ),
              const Spacer(),
              _QuickFillButton(
                label: Tr.planningQuickFillClear.tr,
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
              return _SlotGrid(
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
            return _WeeklySummary(rules: rules);
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
                child: Text(Tr.planningEditorCancel.tr),
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
                child: Text(Tr.planningEditorSave.tr),
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
          Tr.planningQuickFillClear.tr,
          style: AppTypography.heading4(),
        ),
        content: Text(
          Tr.planningEditorClearConfirm.tr,
          style: AppTypography.bodyMedium(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              Tr.planningEditorCancel.tr,
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
              Tr.planningQuickFillClear.tr,
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

class _SlotGrid extends StatelessWidget {
  const _SlotGrid({
    required this.focusedDate,
    required this.rules,
    required this.availabilityController,
  });

  final DateTime focusedDate;
  final List<AvailabilityRule> rules;
  final AvailabilityController availabilityController;

  static const _startHour = 8;
  static const _endHour = 20; // exclusive
  static const _slotsPerHour = 2; // 30-min slots

  static final _dayNames = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

  DateTime _mondayOf(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  bool _slotHasRule(int weekday, int slotIndex) {
    final hour = _startHour + slotIndex ~/ _slotsPerHour;
    final minute = (slotIndex % _slotsPerHour) * 30;
    final slotMinutes = hour * 60 + minute;

    return rules.any((r) {
      if (r.ruleType != AvailabilityRuleType.recurring) return false;
      if (r.dayOfWeek != weekday) return false;
      final start = _parseTime(r.startTime);
      final end = _parseTime(r.endTime);
      if (start == null || end == null) return false;
      return slotMinutes >= start && slotMinutes < end;
    });
  }

  static int? _parseTime(String? time) {
    if (time == null) return null;
    final parts = time.split(':');
    if (parts.length < 2) return null;
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  AvailabilityRule? _findRuleForSlot(int weekday, int slotIndex) {
    final hour = _startHour + slotIndex ~/ _slotsPerHour;
    final minute = (slotIndex % _slotsPerHour) * 30;
    final slotMinutes = hour * 60 + minute;

    for (final r in rules) {
      if (r.ruleType != AvailabilityRuleType.recurring) continue;
      if (r.dayOfWeek != weekday) continue;
      final start = _parseTime(r.startTime);
      final end = _parseTime(r.endTime);
      if (start == null || end == null) continue;
      if (slotMinutes >= start && slotMinutes < end) return r;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final monday = _mondayOf(focusedDate);
    final totalSlots = (_endHour - _startHour) * _slotsPerHour;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header row
            Container(
              decoration: const BoxDecoration(
                color: AppColors.bgAlt,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  // Time column header
                  Container(
                    width: 56,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const SizedBox.shrink(),
                  ),
                  // Day headers
                  for (int d = 0; d < 7; d++) ...[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: AppColors.border),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _dayNames[d],
                              style: AppTypography.sectionTitle(),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '${monday.add(Duration(days: d)).day}',
                              style: AppTypography.bodySmall().copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.encre,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Time slots
            for (int slot = 0; slot < totalSlots; slot++)
              _buildSlotRow(slot, monday),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotRow(int slotIndex, DateTime monday) {
    final hour = _startHour + slotIndex ~/ _slotsPerHour;
    final minute = (slotIndex % _slotsPerHour) * 30;
    final isHourBoundary = slotIndex % _slotsPerHour == 0;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Time label
          Container(
            width: 56,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: 0.5),
                right: BorderSide(color: AppColors.border),
              ),
            ),
            child: isHourBoundary
                ? Text(
                    '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
                    style: AppTypography.bodySmall().copyWith(fontSize: 10),
                  )
                : const SizedBox.shrink(),
          ),
          // Day cells
          for (int d = 0; d < 7; d++)
            Expanded(
              child: _SlotCell(
                weekday: d + 1,
                slotIndex: slotIndex,
                hasRule: _slotHasRule(d + 1, slotIndex),
                existingRule: _findRuleForSlot(d + 1, slotIndex),
                availabilityController: availabilityController,
                hour: hour,
                minute: minute,
              ),
            ),
        ],
      ),
    );
  }
}

class _SlotCell extends StatelessWidget {
  const _SlotCell({
    required this.weekday,
    required this.slotIndex,
    required this.hasRule,
    required this.existingRule,
    required this.availabilityController,
    required this.hour,
    required this.minute,
  });

  final int weekday;
  final int slotIndex;
  final bool hasRule;
  final AvailabilityRule? existingRule;
  final AvailabilityController availabilityController;
  final int hour;
  final int minute;

  @override
  Widget build(BuildContext context) {
    final bgColor = hasRule
        ? AppColors.success.withValues(alpha: 0.15)
        : Colors.transparent;

    return GestureDetector(
      onTap: () async {
        if (hasRule && existingRule != null) {
          await availabilityController.deleteRule(existingRule!.id);
        } else {
          final endHour = minute == 30 ? hour + 1 : hour;
          final endMinute = minute == 30 ? 0 : 30;
          final startTime =
              '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
          final endTime =
              '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';
          final now = DateTime.now();
          await availabilityController.createRule(
            AvailabilityRule(
              id: '',
              tenantId: '',
              ruleType: AvailabilityRuleType.recurring,
              dayOfWeek: weekday,
              startTime: startTime,
              endTime: endTime,
              createdAt: now,
              updatedAt: now,
            ),
          );
        }
      },
      child: Container(
        height: 20,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(
            left: BorderSide(
              color: hasRule ? AppColors.success : AppColors.border,
              width: hasRule ? 2.0 : 0.5,
            ),
            bottom: const BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
      ),
    );
  }
}

class _WeeklySummary extends StatelessWidget {
  const _WeeklySummary({required this.rules});

  final List<AvailabilityRule> rules;

  static const _dayNames = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

  int _countMinutes(int weekday) {
    int total = 0;
    for (final rule in rules) {
      if (rule.dayOfWeek != weekday) continue;
      final start = _parseTime(rule.startTime);
      final end = _parseTime(rule.endTime);
      if (start != null && end != null && end > start) {
        total += end - start;
      }
    }
    return total;
  }

  static int? _parseTime(String? time) {
    if (time == null) return null;
    final parts = time.split(':');
    if (parts.length < 2) return null;
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(7, (i) {
        final minutes = _countMinutes(i + 1);
        final hours = minutes ~/ 60;
        final mins = minutes % 60;
        final label = minutes > 0
            ? (mins > 0 ? '${hours}h$mins' : '${hours}h')
            : '—';
        final hasAny = minutes > 0;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: hasAny
                  ? AppColors.success.withValues(alpha: 0.08)
                  : AppColors.bgAlt,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: hasAny
                    ? AppColors.success.withValues(alpha: 0.3)
                    : AppColors.border,
              ),
            ),
            child: Column(
              children: [
                Text(
                  _dayNames[i],
                  style: AppTypography.sectionTitle(),
                  textAlign: TextAlign.center,
                ),
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: hasAny ? AppColors.success : AppColors.pierre,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }),
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
