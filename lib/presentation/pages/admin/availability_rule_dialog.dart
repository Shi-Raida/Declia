import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/enums/availability_rule_type.dart';
import '../../../domain/entities/availability_rule.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';

class AvailabilityRuleDialog extends StatefulWidget {
  const AvailabilityRuleDialog({
    super.key,
    this.rule,
    required this.onSave,
    this.onDelete,
  });

  final AvailabilityRule? rule;
  final void Function(AvailabilityRule) onSave;
  final void Function(String id)? onDelete;

  @override
  State<AvailabilityRuleDialog> createState() => _AvailabilityRuleDialogState();
}

class _AvailabilityRuleDialogState extends State<AvailabilityRuleDialog> {
  late AvailabilityRuleType _ruleType;
  late int? _dayOfWeek;
  late DateTime? _specificDate;
  late TimeOfDay? _startTime;
  late TimeOfDay? _endTime;
  final _labelController = TextEditingController();

  static const _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    final r = widget.rule;
    _ruleType = r?.ruleType ?? AvailabilityRuleType.recurring;
    _dayOfWeek = r?.dayOfWeek;
    _specificDate = r?.specificDate;
    _startTime = _parseTime(r?.startTime);
    _endTime = _parseTime(r?.endTime);
    _labelController.text = r?.label ?? '';
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  TimeOfDay? _parseTime(String? s) {
    if (s == null) return null;
    final parts = s.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _specificDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _specificDate = picked);
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) setState(() => _startTime = picked);
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? const TimeOfDay(hour: 18, minute: 0),
    );
    if (picked != null) setState(() => _endTime = picked);
  }

  bool get _isEditing => widget.rule != null;

  void _save() {
    final now = DateTime.now().toUtc();
    final rule = AvailabilityRule(
      id: widget.rule?.id ?? '',
      tenantId: widget.rule?.tenantId ?? '',
      ruleType: _ruleType,
      dayOfWeek: _ruleType == AvailabilityRuleType.recurring ? _dayOfWeek : null,
      specificDate: _ruleType != AvailabilityRuleType.recurring
          ? _specificDate
          : null,
      startTime: _ruleType != AvailabilityRuleType.blocked && _startTime != null
          ? _formatTime(_startTime!)
          : null,
      endTime: _ruleType != AvailabilityRuleType.blocked && _endTime != null
          ? _formatTime(_endTime!)
          : null,
      label: _labelController.text.trim().isEmpty
          ? null
          : _labelController.text.trim(),
      createdAt: widget.rule?.createdAt ?? now,
      updatedAt: now,
    );
    Navigator.of(context).pop();
    widget.onSave(rule);
  }

  void _delete() {
    Navigator.of(context).pop();
    widget.onDelete!(widget.rule!.id);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _isEditing
            ? Tr.adminAvailabilityEditRule.tr
            : Tr.adminAvailabilityAddRule.tr,
        style: AppTypography.heading4(),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rule type
            Text(
              'Type',
              style: AppTypography.bodySmall().copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.pierre,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: AvailabilityRuleType.values.map((type) {
                return ChoiceChip(
                  label: Text(_ruleTypeLabel(type)),
                  selected: _ruleType == type,
                  onSelected: (_) => setState(() => _ruleType = type),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // Recurring: day of week
            if (_ruleType == AvailabilityRuleType.recurring) ...[
              DropdownButtonFormField<int>(
                value: _dayOfWeek, // ignore: deprecated_member_use
                decoration: InputDecoration(
                  labelText: Tr.adminAvailabilityDayOfWeek.tr,
                  border: const OutlineInputBorder(),
                ),
                items: List.generate(
                  7,
                  (i) => DropdownMenuItem(
                    value: i + 1,
                    child: Text(_weekdays[i]),
                  ),
                ),
                onChanged: (v) => setState(() => _dayOfWeek = v),
              ),
              const SizedBox(height: 12),
            ],
            // Override/Blocked: specific date
            if (_ruleType != AvailabilityRuleType.recurring) ...[
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: Tr.adminAvailabilityDate.tr,
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.calendar_today, size: 18),
                  ),
                  child: Text(
                    _specificDate != null
                        ? '${_specificDate!.day.toString().padLeft(2, '0')}/'
                            '${_specificDate!.month.toString().padLeft(2, '0')}/'
                            '${_specificDate!.year}'
                        : '—',
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            // Times (not for blocked)
            if (_ruleType != AvailabilityRuleType.blocked) ...[
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _pickStartTime,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: Tr.adminAvailabilityStartTime.tr,
                          border: const OutlineInputBorder(),
                        ),
                        child: Text(
                          _startTime != null
                              ? _startTime!.format(context)
                              : '—',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: _pickEndTime,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: Tr.adminAvailabilityEndTime.tr,
                          border: const OutlineInputBorder(),
                        ),
                        child: Text(
                          _endTime != null ? _endTime!.format(context) : '—',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            // Label
            TextField(
              controller: _labelController,
              decoration: InputDecoration(
                labelText: Tr.adminAvailabilityLabel.tr,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (_isEditing && widget.onDelete != null)
          TextButton(
            onPressed: _delete,
            child: Text(
              Tr.adminAvailabilityDelete.tr,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        const Spacer(),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(Tr.adminClientFormCancel.tr),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(Tr.adminAvailabilitySave.tr),
        ),
      ],
    );
  }

  String _ruleTypeLabel(AvailabilityRuleType type) => switch (type) {
    AvailabilityRuleType.recurring => Tr.adminAvailabilityRecurring.tr,
    AvailabilityRuleType.override => Tr.adminAvailabilityOverride.tr,
    AvailabilityRuleType.blocked => Tr.adminAvailabilityBlocked.tr,
  };
}
