import 'package:json_annotation/json_annotation.dart';

enum CommunicationStatus {
  @JsonValue('queued')
  queued,
  @JsonValue('sent')
  sent,
  @JsonValue('delivered')
  delivered,
  @JsonValue('failed')
  failed,
  @JsonValue('bounced')
  bounced,
}

extension CommunicationStatusJson on CommunicationStatus {
  String get jsonValue => switch (this) {
    CommunicationStatus.queued => 'queued',
    CommunicationStatus.sent => 'sent',
    CommunicationStatus.delivered => 'delivered',
    CommunicationStatus.failed => 'failed',
    CommunicationStatus.bounced => 'bounced',
  };
}
