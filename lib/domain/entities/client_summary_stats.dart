import '../../core/enums/session_type.dart';

class ClientSummaryStats {
  const ClientSummaryStats({
    required this.clientId,
    required this.sessionCount,
    required this.totalSpent,
    this.lastShooting,
    this.sessionTypes = const [],
  });

  final String clientId;
  final int sessionCount;
  final double totalSpent;
  final DateTime? lastShooting;
  final List<SessionType> sessionTypes;
}
