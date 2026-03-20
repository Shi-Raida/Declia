import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/enums/payment_status.dart';
import '../../core/enums/session_status.dart';
import '../../core/enums/session_type.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
class Session with _$Session {
  @JsonSerializable(explicitToJson: true)
  const factory Session({
    required String id,
    @JsonKey(name: 'tenant_id') required String tenantId,
    @JsonKey(name: 'client_id') required String clientId,
    required SessionType type,
    required SessionStatus status,
    @JsonKey(name: 'scheduled_at') required DateTime scheduledAt,
    String? location,
    @JsonKey(name: 'payment_status') required PaymentStatus paymentStatus,
    required double amount,
    String? notes,
    @JsonKey(name: 'duration_minutes') @Default(60) int durationMinutes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}
