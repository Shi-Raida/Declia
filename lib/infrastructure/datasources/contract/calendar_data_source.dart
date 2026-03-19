abstract interface class CalendarDataSource {
  Future<List<Map<String, dynamic>>> fetchSessionsByDateRange(
    DateTime start,
    DateTime end,
  );
}
