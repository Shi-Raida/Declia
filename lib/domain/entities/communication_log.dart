import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/enums/communication_channel.dart';
import '../../core/enums/communication_status.dart';

part 'communication_log.freezed.dart';
part 'communication_log.g.dart';

@freezed
class CommunicationLog with _$CommunicationLog {
  @JsonSerializable(explicitToJson: true)
  const factory CommunicationLog({
    required String id,
    @JsonKey(name: 'tenant_id') required String tenantId,
    @JsonKey(name: 'client_id') required String clientId,
    required CommunicationChannel channel,
    String? subject,
    required CommunicationStatus status,
    @JsonKey(name: 'sent_at') DateTime? sentAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _CommunicationLog;

  factory CommunicationLog.fromJson(Map<String, dynamic> json) =>
      _$CommunicationLogFromJson(json);
}
