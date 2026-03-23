import 'package:declia/core/enums/calendar_view.dart';
import 'package:declia/core/enums/payment_status.dart';
import 'package:declia/core/enums/session_status.dart';
import 'package:declia/core/enums/session_type.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/clock.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/calendar_event.dart';
import 'package:declia/domain/entities/external_calendar_event.dart';
import 'package:declia/domain/entities/session.dart';
import 'package:declia/presentation/controllers/planning_controller.dart';
import 'package:declia/usecases/calendar/params.dart';
import 'package:declia/usecases/google_calendar/params.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

final _now = DateTime(2026, 3, 19);
final Clock _clock = FakeClock(_now);

CalendarEvent _event() => CalendarEvent(
  session: Session(
    id: 's1',
    tenantId: 'tid',
    clientId: 'cid',
    type: SessionType.portrait,
    status: SessionStatus.scheduled,
    scheduledAt: _now,
    paymentStatus: PaymentStatus.pending,
    amount: 150.0,
    createdAt: _now,
    updatedAt: _now,
  ),
  clientFirstName: 'Alice',
  clientLastName: 'Dupont',
);

final class _FakeFetchCalendarSessions
    extends UseCase<List<CalendarEvent>, FetchCalendarSessionsParams> {
  List<CalendarEvent> eventsToReturn = [];
  Failure? failureToReturn;
  int callCount = 0;
  FetchCalendarSessionsParams? lastParams;

  @override
  Future<Result<List<CalendarEvent>, Failure>> call(
    FetchCalendarSessionsParams params,
  ) async {
    callCount++;
    lastParams = params;
    if (failureToReturn != null) return Err(failureToReturn!);
    return Ok(eventsToReturn);
  }
}

final class _FakeFetchExternalEvents
    extends UseCase<List<ExternalCalendarEvent>, FetchExternalEventsParams> {
  @override
  Future<Result<List<ExternalCalendarEvent>, Failure>> call(
    FetchExternalEventsParams params,
  ) async => const Ok([]);
}

PlanningController _makeController({
  _FakeFetchCalendarSessions? fetch,
  Clock? clock,
}) => PlanningController(
  fetch ?? _FakeFetchCalendarSessions(),
  FakeClientNavigationService(),
  _FakeFetchExternalEvents(),
  clock ?? _clock,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PlanningController', () {
    group('initialization', () {
      test('loads sessions for current month on init', () async {
        final fetch = _FakeFetchCalendarSessions()..eventsToReturn = [_event()];
        final controller = _makeController(fetch: fetch);

        await controller.loadSessions();

        expect(fetch.callCount, greaterThanOrEqualTo(1));
        expect(controller.events.length, 1);
        expect(controller.isLoading.value, isFalse);
        expect(controller.errorMessage.value, isNull);
      });

      test('sets errorMessage on load failure', () async {
        final fetch = _FakeFetchCalendarSessions()
          ..failureToReturn = const RepositoryFailure('load error');
        final controller = _makeController(fetch: fetch);

        await controller.loadSessions();

        expect(controller.events, isEmpty);
        expect(controller.errorMessage.value, 'load error');
        expect(controller.isLoading.value, isFalse);
      });
    });

    group('navigation', () {
      test('goToNext advances focused date by 1 day in day view', () async {
        final fetch = _FakeFetchCalendarSessions();
        final controller = _makeController(fetch: fetch);
        controller.currentView.value = CalendarView.day;
        final initial = controller.focusedDate.value;

        controller.goToNext();
        await controller.loadSessions();

        expect(controller.focusedDate.value.difference(initial).inDays, 1);
      });

      test('goToNext advances focused date by 7 days in week view', () async {
        final fetch = _FakeFetchCalendarSessions();
        final controller = _makeController(fetch: fetch);
        controller.currentView.value = CalendarView.week;
        final initial = controller.focusedDate.value;

        controller.goToNext();
        await controller.loadSessions();

        expect(controller.focusedDate.value.difference(initial).inDays, 7);
      });

      test('goToPrevious moves back 1 day in day view', () async {
        final fetch = _FakeFetchCalendarSessions();
        final controller = _makeController(fetch: fetch);
        controller.currentView.value = CalendarView.day;
        final initial = controller.focusedDate.value;

        controller.goToPrevious();
        await controller.loadSessions();

        expect(initial.difference(controller.focusedDate.value).inDays, 1);
      });

      test('goToToday resets focused date to today', () async {
        final fetch = _FakeFetchCalendarSessions();
        final controller = _makeController(fetch: fetch);
        controller.focusedDate.value = DateTime(2025, 1, 1);

        controller.goToToday();
        await controller.loadSessions();

        expect(controller.focusedDate.value.year, _now.year);
        expect(controller.focusedDate.value.month, _now.month);
        expect(controller.focusedDate.value.day, _now.day);
      });
    });

    group('setView', () {
      test('changes current view', () async {
        final fetch = _FakeFetchCalendarSessions();
        final controller = _makeController(fetch: fetch);

        controller.setView(CalendarView.day);
        await controller.loadSessions();

        expect(controller.currentView.value, CalendarView.day);
      });

      test('reloads sessions after view change', () async {
        final fetch = _FakeFetchCalendarSessions();
        final controller = _makeController(fetch: fetch);
        final countBefore = fetch.callCount;

        controller.setView(CalendarView.week);
        await controller.loadSessions();

        expect(fetch.callCount, greaterThan(countBefore));
      });
    });

    group('selectDate', () {
      test('sets focused date and switches to day view', () async {
        final fetch = _FakeFetchCalendarSessions();
        final controller = _makeController(fetch: fetch);
        final target = DateTime(2026, 5, 10);

        controller.selectDate(target);
        await controller.loadSessions();

        expect(controller.focusedDate.value, target);
        expect(controller.currentView.value, CalendarView.day);
      });
    });

    group('goToClientProfile', () {
      test('delegates to navigation service', () {
        final nav = FakeClientNavigationService();
        final controller = PlanningController(
          _FakeFetchCalendarSessions(),
          nav,
          _FakeFetchExternalEvents(),
          _clock,
        );

        controller.goToClientProfile('client-42');

        expect(nav.lastClientId, 'client-42');
      });
    });

    group('eventsForDate', () {
      test('returns only events matching the given date', () async {
        final event = _event();
        final fetch = _FakeFetchCalendarSessions()..eventsToReturn = [event];
        final controller = _makeController(fetch: fetch);
        await controller.loadSessions();

        final matches = controller.eventsForDate(_now);
        final noMatches = controller.eventsForDate(DateTime(2026, 1, 1));

        expect(matches.length, 1);
        expect(noMatches, isEmpty);
      });
    });
  });
}
