import 'package:declia/core/enums/availability_rule_type.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/clock.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/availability_rule.dart';
import 'package:declia/domain/repositories/availability_repository.dart';
import 'package:declia/usecases/availability/update_availability_rule.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 3, 19, 12, 0, 0);
final _originalUpdatedAt = DateTime(2026, 1, 1);

final class _FakeClock implements Clock {
  @override
  DateTime now() => _now;
}

final class _FakeAvailabilityRepository implements AvailabilityRepository {
  AvailabilityRule? lastUpdated;
  Failure? failureToReturn;

  @override
  Future<Result<List<AvailabilityRule>, Failure>> fetchAll() async =>
      const Ok([]);

  @override
  Future<Result<AvailabilityRule, Failure>> create(AvailabilityRule rule) async =>
      Ok(rule);

  @override
  Future<Result<AvailabilityRule, Failure>> update(
    AvailabilityRule rule,
  ) async {
    if (failureToReturn != null) return Err(failureToReturn!);
    lastUpdated = rule;
    return Ok(rule);
  }

  @override
  Future<Result<void, Failure>> delete(String id) async => const Ok(null);
}

AvailabilityRule _ruleInput() => AvailabilityRule(
  id: 'r1',
  tenantId: 'tid',
  ruleType: AvailabilityRuleType.recurring,
  dayOfWeek: 3,
  startTime: '09:00:00',
  endTime: '18:00:00',
  createdAt: _originalUpdatedAt,
  updatedAt: _originalUpdatedAt,
);

void main() {
  group('UpdateAvailabilityRule', () {
    test('stamps updatedAt from clock', () async {
      final repo = _FakeAvailabilityRepository();
      final useCase = UpdateAvailabilityRule(repo, _FakeClock());

      await useCase((rule: _ruleInput()));

      expect(repo.lastUpdated, isNotNull);
      expect(repo.lastUpdated!.updatedAt, _now.toUtc());
    });

    test('preserves createdAt from original rule', () async {
      final repo = _FakeAvailabilityRepository();
      final useCase = UpdateAvailabilityRule(repo, _FakeClock());

      await useCase((rule: _ruleInput()));

      expect(repo.lastUpdated!.createdAt, _originalUpdatedAt);
    });

    test('delegates to repository update', () async {
      final repo = _FakeAvailabilityRepository();
      final useCase = UpdateAvailabilityRule(repo, _FakeClock());

      final result = await useCase((rule: _ruleInput()));

      expect(result.isOk, isTrue);
    });

    test('propagates failure from repository', () async {
      final repo = _FakeAvailabilityRepository()
        ..failureToReturn = const RepositoryFailure('update error');
      final useCase = UpdateAvailabilityRule(repo, _FakeClock());

      final result = await useCase((rule: _ruleInput()));

      expect(result.isOk, isFalse);
    });
  });
}
