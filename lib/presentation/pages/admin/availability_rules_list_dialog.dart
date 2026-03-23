import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/enums/availability_rule_type.dart';
import '../../../domain/entities/availability_rule.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import 'availability_rule_dialog.dart';

class AvailabilityRulesListDialog extends StatelessWidget {
  const AvailabilityRulesListDialog({
    super.key,
    required this.rules,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final List<AvailabilityRule> rules;
  final void Function(AvailabilityRule) onAdd;
  final void Function(AvailabilityRule) onEdit;
  final void Function(String id) onDelete;

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    final grouped = {
      AvailabilityRuleType.recurring: rules
          .where((r) => r.ruleType == AvailabilityRuleType.recurring)
          .toList(),
      AvailabilityRuleType.override: rules
          .where((r) => r.ruleType == AvailabilityRuleType.override)
          .toList(),
      AvailabilityRuleType.blocked: rules
          .where((r) => r.ruleType == AvailabilityRuleType.blocked)
          .toList(),
    };

    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(
              Tr.admin.availability.title.tr,
              style: AppTypography.heading4(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openAddDialog(context),
            tooltip: Tr.admin.availability.addRule.tr,
          ),
        ],
      ),
      content: SizedBox(
        width: 480,
        child: rules.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  Tr.admin.availability.empty.tr,
                  style: AppTypography.bodySmall().copyWith(
                    color: AppColors.pierre,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: AvailabilityRuleType.values
                      .where((t) => grouped[t]!.isNotEmpty)
                      .expand(
                        (type) => [
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 6),
                            child: Text(
                              _typeLabel(type),
                              style: AppTypography.bodySmall().copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.pierre,
                              ),
                            ),
                          ),
                          ...grouped[type]!.map(
                            (rule) => _RuleListTile(
                              rule: rule,
                              weekdays: _weekdays,
                              onEdit: () => _openEditDialog(context, rule),
                            ),
                          ),
                        ],
                      )
                      .toList(),
                ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(Tr.admin.clientForm.cancel.tr),
        ),
      ],
    );
  }

  String _typeLabel(AvailabilityRuleType type) => switch (type) {
    AvailabilityRuleType.recurring => Tr.admin.availability.recurring.tr,
    AvailabilityRuleType.override => Tr.admin.availability.override.tr,
    AvailabilityRuleType.blocked => Tr.admin.availability.blocked.tr,
  };

  void _openAddDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AvailabilityRuleDialog(onSave: onAdd),
    );
  }

  void _openEditDialog(BuildContext context, AvailabilityRule rule) {
    showDialog<void>(
      context: context,
      builder: (_) => AvailabilityRuleDialog(
        rule: rule,
        onSave: onEdit,
        onDelete: onDelete,
      ),
    );
  }
}

class _RuleListTile extends StatelessWidget {
  const _RuleListTile({
    required this.rule,
    required this.weekdays,
    required this.onEdit,
  });

  final AvailabilityRule rule;
  final List<String> weekdays;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(_title(), style: AppTypography.bodySmall()),
      subtitle: rule.label != null
          ? Text(
              rule.label!,
              style: AppTypography.bodySmall().copyWith(
                color: AppColors.pierre,
              ),
            )
          : null,
      trailing: IconButton(
        icon: const Icon(Icons.edit, size: 16),
        onPressed: onEdit,
      ),
    );
  }

  String _title() {
    switch (rule.ruleType) {
      case AvailabilityRuleType.recurring:
        final day = rule.dayOfWeek != null && rule.dayOfWeek! >= 1
            ? weekdays[(rule.dayOfWeek! - 1) % 7]
            : '?';
        return '$day  ${rule.startTime ?? '?'} – ${rule.endTime ?? '?'}';
      case AvailabilityRuleType.override:
        final d = rule.specificDate;
        final dateStr = d != null
            ? '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}'
            : '?';
        return '$dateStr  ${rule.startTime ?? '?'} – ${rule.endTime ?? '?'}';
      case AvailabilityRuleType.blocked:
        final d = rule.specificDate;
        return d != null
            ? '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}'
            : '?';
    }
  }
}
