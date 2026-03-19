import 'package:declia/core/enums/availability_rule_type.dart';
import 'package:declia/domain/entities/availability_rule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 3, 19);

  group('AvailabilityRule JSON round-trip', () {
    test('recurring rule serializes and deserializes correctly', () {
      final rule = AvailabilityRule(
        id: 'r1',
        tenantId: 'tid',
        ruleType: AvailabilityRuleType.recurring,
        dayOfWeek: 3,
        startTime: '09:00:00',
        endTime: '18:00:00',
        label: 'Wednesday slot',
        createdAt: now,
        updatedAt: now,
      );

      final json = rule.toJson();
      final restored = AvailabilityRule.fromJson(json);

      expect(restored.id, rule.id);
      expect(restored.ruleType, AvailabilityRuleType.recurring);
      expect(restored.dayOfWeek, 3);
      expect(restored.startTime, '09:00:00');
      expect(restored.endTime, '18:00:00');
      expect(restored.label, 'Wednesday slot');
      expect(restored.specificDate, isNull);
    });

    test('override rule serializes and deserializes correctly', () {
      final specificDate = DateTime(2026, 4, 5);
      final rule = AvailabilityRule(
        id: 'r2',
        tenantId: 'tid',
        ruleType: AvailabilityRuleType.override,
        specificDate: specificDate,
        startTime: '10:00:00',
        endTime: '14:00:00',
        createdAt: now,
        updatedAt: now,
      );

      final json = rule.toJson();
      final restored = AvailabilityRule.fromJson(json);

      expect(restored.ruleType, AvailabilityRuleType.override);
      expect(restored.specificDate, isNotNull);
      expect(restored.dayOfWeek, isNull);
      expect(restored.startTime, '10:00:00');
      expect(restored.endTime, '14:00:00');
    });

    test('blocked rule serializes and deserializes correctly', () {
      final blockedDate = DateTime(2026, 5, 1);
      final rule = AvailabilityRule(
        id: 'r3',
        tenantId: 'tid',
        ruleType: AvailabilityRuleType.blocked,
        specificDate: blockedDate,
        label: 'Public holiday',
        createdAt: now,
        updatedAt: now,
      );

      final json = rule.toJson();
      final restored = AvailabilityRule.fromJson(json);

      expect(restored.ruleType, AvailabilityRuleType.blocked);
      expect(restored.specificDate, isNotNull);
      expect(restored.startTime, isNull);
      expect(restored.endTime, isNull);
      expect(restored.label, 'Public holiday');
    });

    test('rule_type JSON value maps correctly', () {
      expect(AvailabilityRuleType.recurring.jsonValue, 'recurring');
      expect(AvailabilityRuleType.override.jsonValue, 'override');
      expect(AvailabilityRuleType.blocked.jsonValue, 'blocked');
    });
  });
}
