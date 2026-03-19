import 'package:declia/core/enums/availability_rule_type.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/availability_rule.dart';
import 'package:declia/domain/entities/calendar_event.dart';
import 'package:declia/presentation/controllers/planning_controller.dart';
import 'package:declia/presentation/services/navigation_service.dart';
import 'package:declia/usecases/availability/params.dart';
import 'package:declia/usecases/calendar/params.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 3, 19);

// Wednesday 2026-03-18 (weekday = 3)
final _wednesday = DateTime(2026, 3, 18);

AvailabilityRule _recurringWed() => AvailabilityRule(
  id: 'r1',
  tenantId: 'tid',
  ruleType: AvailabilityRuleType.recurring,
  dayOfWeek: 3, // Wednesday
  startTime: '09:00:00',
  endTime: '18:00:00',
  createdAt: _now,
  updatedAt: _now,
);

AvailabilityRule _blockedRule() => AvailabilityRule(
  id: 'r2',
  tenantId: 'tid',
  ruleType: AvailabilityRuleType.blocked,
  specificDate: _wednesday,
  createdAt: _now,
  updatedAt: _now,
);


final class _FakeFetchSessions
    extends UseCase<List<CalendarEvent>, FetchCalendarSessionsParams> {
  List<CalendarEvent> eventsToReturn = [];

  @override
  Future<Result<List<CalendarEvent>, Failure>> call(
    FetchCalendarSessionsParams params,
  ) async => Ok(eventsToReturn);
}

final class _FakeFetchAvailabilityRules
    extends UseCase<List<AvailabilityRule>, NoParams> {
  List<AvailabilityRule> rulesToReturn = [];
  Failure? failureToReturn;
  int callCount = 0;

  @override
  Future<Result<List<AvailabilityRule>, Failure>> call(NoParams params) async {
    callCount++;
    if (failureToReturn != null) return Err(failureToReturn!);
    return Ok(rulesToReturn);
  }
}

final class _FakeCreateAvailabilityRule
    extends UseCase<AvailabilityRule, CreateAvailabilityRuleParams> {
  AvailabilityRule? lastRule;

  @override
  Future<Result<AvailabilityRule, Failure>> call(
    CreateAvailabilityRuleParams params,
  ) async {
    lastRule = params.rule;
    return Ok(params.rule);
  }
}

final class _FakeUpdateAvailabilityRule
    extends UseCase<AvailabilityRule, UpdateAvailabilityRuleParams> {
  AvailabilityRule? lastRule;

  @override
  Future<Result<AvailabilityRule, Failure>> call(
    UpdateAvailabilityRuleParams params,
  ) async {
    lastRule = params.rule;
    return Ok(params.rule);
  }
}

final class _FakeDeleteAvailabilityRule
    extends UseCase<void, DeleteAvailabilityRuleParams> {
  String? lastId;

  @override
  Future<Result<void, Failure>> call(DeleteAvailabilityRuleParams params) async {
    lastId = params.id;
    return const Ok(null);
  }
}

final class _FakeNavigationService implements NavigationService {
  @override
  String get currentRoute => '';
  @override
  void toLogin({String? reason}) {}
  @override
  void toHome(dynamic role) {}
  @override
  void toDashboard() {}
  @override
  void toAdminPage(String route) {}
  @override
  void toClientLogin({String? tenantSlug}) {}
  @override
  void toClientHome() {}
  @override
  void toClientRegister({String? tenantSlug}) {}
  @override
  void toClientForgotPassword() {}
  @override
  void toLegalPrivacy() {}
  @override
  void toClientDetail(String id, {dynamic arguments}) {}
  @override
  void toClientEdit(String id, {dynamic arguments}) {}
  @override
  void toClientNew() {}
  @override
  void goBack() {}
}

PlanningController _makeController({
  _FakeFetchAvailabilityRules? fetchRules,
  _FakeCreateAvailabilityRule? create,
  _FakeUpdateAvailabilityRule? update,
  _FakeDeleteAvailabilityRule? delete,
}) => PlanningController(
  _FakeFetchSessions(),
  fetchRules ?? _FakeFetchAvailabilityRules(),
  create ?? _FakeCreateAvailabilityRule(),
  update ?? _FakeUpdateAvailabilityRule(),
  delete ?? _FakeDeleteAvailabilityRule(),
  _FakeNavigationService(),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PlanningController availability', () {
    group('loadAvailabilityRules', () {
      test('loads rules into availabilityRules on success', () async {
        final fetch = _FakeFetchAvailabilityRules()
          ..rulesToReturn = [_recurringWed()];
        final controller = _makeController(fetchRules: fetch);

        await controller.loadAvailabilityRules();

        expect(controller.availabilityRules.length, 1);
      });

      test('silently ignores failure (keeps existing state)', () async {
        final fetch = _FakeFetchAvailabilityRules()
          ..failureToReturn = const RepositoryFailure('error');
        final controller = _makeController(fetchRules: fetch);

        await controller.loadAvailabilityRules();

        expect(controller.availabilityRules, isEmpty);
      });
    });

    group('toggleAvailability', () {
      test('flips showAvailability from false to true', () {
        final controller = _makeController();

        expect(controller.showAvailability.value, isFalse);
        controller.toggleAvailability();
        expect(controller.showAvailability.value, isTrue);
      });

      test('flips showAvailability back to false', () {
        final controller = _makeController();
        controller.toggleAvailability();
        controller.toggleAvailability();

        expect(controller.showAvailability.value, isFalse);
      });
    });

    group('isDateBlocked', () {
      test('returns true when blocked rule exists for date', () async {
        final fetch = _FakeFetchAvailabilityRules()
          ..rulesToReturn = [_blockedRule()];
        final controller = _makeController(fetchRules: fetch);
        await controller.loadAvailabilityRules();

        expect(controller.isDateBlocked(_wednesday), isTrue);
      });

      test('returns false when no blocked rule for date', () async {
        final fetch = _FakeFetchAvailabilityRules()
          ..rulesToReturn = [_recurringWed()];
        final controller = _makeController(fetchRules: fetch);
        await controller.loadAvailabilityRules();

        expect(controller.isDateBlocked(_wednesday), isFalse);
      });
    });

    group('hasAvailability', () {
      test('returns true when slots available for date', () async {
        final fetch = _FakeFetchAvailabilityRules()
          ..rulesToReturn = [_recurringWed()];
        final controller = _makeController(fetchRules: fetch);
        await controller.loadAvailabilityRules();

        expect(controller.hasAvailability(_wednesday), isTrue);
      });

      test('returns false when blocked', () async {
        final fetch = _FakeFetchAvailabilityRules()
          ..rulesToReturn = [_blockedRule()];
        final controller = _makeController(fetchRules: fetch);
        await controller.loadAvailabilityRules();

        expect(controller.hasAvailability(_wednesday), isFalse);
      });
    });

    group('availableSlotsForDate', () {
      test('returns slots based on rules', () async {
        final fetch = _FakeFetchAvailabilityRules()
          ..rulesToReturn = [_recurringWed()];
        final controller = _makeController(fetchRules: fetch);
        await controller.loadAvailabilityRules();

        final slots = controller.availableSlotsForDate(_wednesday);

        expect(slots.length, 1);
        expect(slots.first.start, DateTime(2026, 3, 18, 9, 0));
        expect(slots.first.end, DateTime(2026, 3, 18, 18, 0));
      });
    });

    group('createRule', () {
      test('calls create use case and reloads rules', () async {
        final createUc = _FakeCreateAvailabilityRule();
        final fetchUc = _FakeFetchAvailabilityRules()
          ..rulesToReturn = [_recurringWed()];
        final controller = _makeController(
          fetchRules: fetchUc,
          create: createUc,
        );
        final initialCallCount = fetchUc.callCount;

        await controller.createRule(_recurringWed());

        expect(createUc.lastRule, isNotNull);
        expect(fetchUc.callCount, greaterThan(initialCallCount));
      });
    });

    group('updateRule', () {
      test('calls update use case and reloads rules', () async {
        final updateUc = _FakeUpdateAvailabilityRule();
        final fetchUc = _FakeFetchAvailabilityRules();
        final controller = _makeController(
          fetchRules: fetchUc,
          update: updateUc,
        );
        final initialCallCount = fetchUc.callCount;

        await controller.updateRule(_recurringWed());

        expect(updateUc.lastRule, isNotNull);
        expect(fetchUc.callCount, greaterThan(initialCallCount));
      });
    });

    group('deleteRule', () {
      test('calls delete use case with correct id and reloads rules', () async {
        final deleteUc = _FakeDeleteAvailabilityRule();
        final fetchUc = _FakeFetchAvailabilityRules();
        final controller = _makeController(
          fetchRules: fetchUc,
          delete: deleteUc,
        );
        final initialCallCount = fetchUc.callCount;

        await controller.deleteRule('rule-99');

        expect(deleteUc.lastId, 'rule-99');
        expect(fetchUc.callCount, greaterThan(initialCallCount));
      });
    });
  });
}
