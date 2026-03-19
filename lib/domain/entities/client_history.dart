import '../../core/enums/order_status.dart';
import '../../core/enums/session_status.dart';
import 'communication_log.dart';
import 'gallery.dart';
import 'order.dart';
import 'session.dart';

class ClientHistory {
  const ClientHistory({
    required this.clientId,
    required this.sessions,
    required this.galleries,
    required this.orders,
    required this.communicationLogs,
  });

  final String clientId;
  final List<Session> sessions;
  final List<Gallery> galleries;
  final List<Order> orders;
  final List<CommunicationLog> communicationLogs;

  int get sessionCount => sessions.length;

  double get totalSpent => orders
      .where(
        (o) =>
            o.status != OrderStatus.cancelled &&
            o.status != OrderStatus.refunded,
      )
      .fold(0.0, (sum, o) => sum + o.totalAmount);

  DateTime? get lastShooting {
    final completed = sessions
        .where((s) => s.status == SessionStatus.completed)
        .map((s) => s.scheduledAt)
        .toList();
    if (completed.isEmpty) return null;
    return completed.reduce((a, b) => a.isAfter(b) ? a : b);
  }
}
