import '../../core/errors/failures.dart';
import '../../core/repositories/repository_guard.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/calendar_event.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../datasources/contract/calendar_data_source.dart';

final class CalendarRepositoryImpl implements CalendarRepository {
  const CalendarRepositoryImpl({
    required CalendarDataSource dataSource,
    required RepositoryGuard guard,
  }) : _dataSource = dataSource,
       _guard = guard;

  final CalendarDataSource _dataSource;
  final RepositoryGuard _guard;

  @override
  Future<Result<List<CalendarEvent>, Failure>> fetchByDateRange(
    DateTime start,
    DateTime end,
  ) => _guard(() async {
    final rows = await _dataSource.fetchSessionsByDateRange(start, end);
    return rows.map((row) {
      final clientData = row['clients'] as Map<String, dynamic>;
      final sessionRow = Map<String, dynamic>.from(row)..remove('clients');
      return CalendarEvent(
        session: Session.fromJson(sessionRow),
        clientFirstName: clientData['first_name'] as String,
        clientLastName: clientData['last_name'] as String,
      );
    }).toList();
  }, method: 'fetchByDateRange');
}
