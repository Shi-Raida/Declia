import 'package:json_annotation/json_annotation.dart';

enum AvailabilityRuleType {
  @JsonValue('recurring')
  recurring,
  @JsonValue('override')
  override,
  @JsonValue('blocked')
  blocked,
}

extension AvailabilityRuleTypeJson on AvailabilityRuleType {
  String get jsonValue => switch (this) {
    AvailabilityRuleType.recurring => 'recurring',
    AvailabilityRuleType.override => 'override',
    AvailabilityRuleType.blocked => 'blocked',
  };
}
