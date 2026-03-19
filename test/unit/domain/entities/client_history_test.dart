import 'package:declia/core/enums/order_status.dart';
import 'package:declia/core/enums/payment_status.dart';
import 'package:declia/core/enums/session_status.dart';
import 'package:declia/core/enums/session_type.dart';
import 'package:declia/domain/entities/client_history.dart';
import 'package:declia/domain/entities/order.dart';
import 'package:declia/domain/entities/session.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 3, 20);

Session _session({
  required String id,
  required SessionStatus status,
  DateTime? scheduledAt,
}) => Session(
  id: id,
  tenantId: 'tid',
  clientId: 'cid',
  type: SessionType.portrait,
  status: status,
  scheduledAt: scheduledAt ?? _now,
  paymentStatus: PaymentStatus.paid,
  amount: 0,
  createdAt: _now,
  updatedAt: _now,
);

Order _order({
  required String id,
  required OrderStatus status,
  required double totalAmount,
}) => Order(
  id: id,
  tenantId: 'tid',
  clientId: 'cid',
  status: status,
  totalAmount: totalAmount,
  orderDate: _now,
  createdAt: _now,
  updatedAt: _now,
);

ClientHistory _history({
  List<Session> sessions = const [],
  List<Order> orders = const [],
}) => ClientHistory(
  clientId: 'cid',
  sessions: sessions,
  galleries: const [],
  orders: orders,
  communicationLogs: const [],
);

void main() {
  group('ClientHistory', () {
    group('sessionCount', () {
      test('returns 0 when no sessions', () {
        expect(_history().sessionCount, 0);
      });

      test('counts all sessions regardless of status', () {
        final h = _history(
          sessions: [
            _session(id: '1', status: SessionStatus.completed),
            _session(id: '2', status: SessionStatus.cancelled),
            _session(id: '3', status: SessionStatus.scheduled),
          ],
        );
        expect(h.sessionCount, 3);
      });
    });

    group('totalSpent', () {
      test('returns 0 when no orders', () {
        expect(_history().totalSpent, 0.0);
      });

      test('sums only non-cancelled and non-refunded orders', () {
        final h = _history(
          orders: [
            _order(id: '1', status: OrderStatus.delivered, totalAmount: 100),
            _order(id: '2', status: OrderStatus.cancelled, totalAmount: 50),
            _order(id: '3', status: OrderStatus.refunded, totalAmount: 30),
            _order(id: '4', status: OrderStatus.processing, totalAmount: 200),
          ],
        );
        expect(h.totalSpent, 300.0);
      });

      test('returns 0 when all orders are cancelled/refunded', () {
        final h = _history(
          orders: [
            _order(id: '1', status: OrderStatus.cancelled, totalAmount: 100),
            _order(id: '2', status: OrderStatus.refunded, totalAmount: 50),
          ],
        );
        expect(h.totalSpent, 0.0);
      });
    });

    group('lastShooting', () {
      test('returns null when no sessions', () {
        expect(_history().lastShooting, isNull);
      });

      test('returns null when no completed sessions', () {
        final h = _history(
          sessions: [
            _session(id: '1', status: SessionStatus.scheduled),
            _session(id: '2', status: SessionStatus.cancelled),
          ],
        );
        expect(h.lastShooting, isNull);
      });

      test('returns most recent completed session date', () {
        final older = DateTime(2025, 6, 1);
        final newer = DateTime(2026, 1, 15);
        final h = _history(
          sessions: [
            _session(
              id: '1',
              status: SessionStatus.completed,
              scheduledAt: older,
            ),
            _session(
              id: '2',
              status: SessionStatus.completed,
              scheduledAt: newer,
            ),
            _session(
              id: '3',
              status: SessionStatus.cancelled,
              scheduledAt: DateTime(2026, 3, 1),
            ),
          ],
        );
        expect(h.lastShooting, newer);
      });
    });
  });
}
