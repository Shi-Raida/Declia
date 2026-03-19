class ClientSummaryStats {
  const ClientSummaryStats({
    required this.clientId,
    required this.sessionCount,
    required this.totalSpent,
    this.lastShooting,
  });

  final String clientId;
  final int sessionCount;
  final double totalSpent;
  final DateTime? lastShooting;
}
