import 'package:json_annotation/json_annotation.dart';

enum OrderStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('processing')
  processing,
  @JsonValue('shipped')
  shipped,
  @JsonValue('delivered')
  delivered,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('refunded')
  refunded,
}

extension OrderStatusJson on OrderStatus {
  String get jsonValue => switch (this) {
    OrderStatus.pending => 'pending',
    OrderStatus.processing => 'processing',
    OrderStatus.shipped => 'shipped',
    OrderStatus.delivered => 'delivered',
    OrderStatus.cancelled => 'cancelled',
    OrderStatus.refunded => 'refunded',
  };
}
