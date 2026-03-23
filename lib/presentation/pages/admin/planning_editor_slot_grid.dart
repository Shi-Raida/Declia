import 'package:flutter/material.dart';

import '../../../core/enums/availability_rule_type.dart';
import '../../../domain/entities/availability_rule.dart';
import '../../controllers/availability_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class SlotGrid extends StatelessWidget {
  const SlotGrid({
    super.key,
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
