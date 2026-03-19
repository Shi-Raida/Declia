import '../../../domain/entities/communication_log.dart';
import '../../../domain/entities/gallery.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/session.dart';

abstract interface class ClientHistoryDataSource {
  Future<List<Session>> fetchSessions(String clientId);
  Future<List<Gallery>> fetchGalleries(String clientId);
  Future<List<Order>> fetchOrders(String clientId);
  Future<List<CommunicationLog>> fetchCommunicationLogs(String clientId);
  Future<Map<String, Map<String, dynamic>>> fetchSummaryStats(
    List<String> clientIds,
  );
}
