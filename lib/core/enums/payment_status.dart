import 'package:json_annotation/json_annotation.dart';

enum PaymentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('partial')
  partial,
  @JsonValue('paid')
  paid,
  @JsonValue('refunded')
  refunded,
}

extension PaymentStatusJson on PaymentStatus {
  String get jsonValue => switch (this) {
    PaymentStatus.pending => 'pending',
    PaymentStatus.partial => 'partial',
    PaymentStatus.paid => 'paid',
    PaymentStatus.refunded => 'refunded',
  };
}
