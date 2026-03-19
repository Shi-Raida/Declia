import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/enums/order_status.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  @JsonSerializable(explicitToJson: true)
  const factory Order({
    required String id,
    @JsonKey(name: 'tenant_id') required String tenantId,
    @JsonKey(name: 'client_id') required String clientId,
    @JsonKey(name: 'session_id') String? sessionId,
    required OrderStatus status,
    @JsonKey(name: 'total_amount') required double totalAmount,
    @JsonKey(name: 'order_date') required DateTime orderDate,
    String? description,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
