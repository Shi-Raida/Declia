import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/enums/availability_rule_type.dart';

part 'availability_rule.freezed.dart';
part 'availability_rule.g.dart';

@freezed
class AvailabilityRule with _$AvailabilityRule {
  @JsonSerializable(explicitToJson: true)
  const factory AvailabilityRule({
    required String id,
    @JsonKey(name: 'tenant_id') required String tenantId,
    @JsonKey(name: 'rule_type') required AvailabilityRuleType ruleType,
    @JsonKey(name: 'day_of_week') int? dayOfWeek,
    @JsonKey(name: 'specific_date') DateTime? specificDate,
    @JsonKey(name: 'start_time') String? startTime,
    @JsonKey(name: 'end_time') String? endTime,
    String? label,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _AvailabilityRule;

  factory AvailabilityRule.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityRuleFromJson(json);
}
