import 'package:declia/core/enums/availability_rule_type.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/clock.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/availability_rule.dart';
import 'package:declia/domain/repositories/availability_repository.dart';
import 'package:declia/usecases/availability/create_availability_rule.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 3, 19, 12, 0, 0);

final class _FakeClock implements Clock {
  @override
  DateTime now() => _now;
}

final class _FakeAvailabilityRepository implements AvailabilityRepository {
  AvailabilityRule? lastCreated;
  Failure? failureToReturn;

  @override
  Future<Result<List<AvailabilityRule>, Failure>> fetchAll() async =>
      const Ok([]);

  @override
  Future<Result<AvailabilityRule, Failure>> create(
    AvailabilityRule rule,
  ) async {
    if (failureToReturn != null) return Err(failureToReturn!);
    lastCreated = rule;
    return Ok(rule);
  }

  @override
  Future<Result<AvailabilityRule, Failure>> update(AvailabilityRule rule) async =>
      Ok(rule);

  @override
  Future<Result<void, Failure>> delete(String id) async => const Ok(null);
}

AvailabilityRule _ruleInput() => AvailabilityRule(
  id: '',
  tenantId: '',
  ruleType: AvailabilityRuleType.recurring,
  dayOfWeek: 3,
  startTime: '09:00:00',
  endTime: '18:00:00',
  createdAt: DateTime(2000),
  updatedAt: DateTime(2000),
);

void main() {
  group('CreateAvailabilityRule', () {
    test('stamps createdAt and updatedAt from clock', () async {
      final repo = _FakeAvailabilityRepository();
      final useCase = CreateAvailabilityRule(repo, _FakeClock());

      await useCase((rule: _ruleInput()));

      expect(repo.lastCreated, isNotNull);
      expect(repo.lastCreated!.createdAt, _now.toUtc());
      expect(repo.lastCreated!.updatedAt, _now.toUtc());
    });

    test('delegates to repository create', () async {
      final repo = _FakeAvailabilityRepository();
      final useCase = CreateAvailabilityRule(repo, _FakeClock());

      final result = await useCase((rule: _ruleInput()));

      expect(result.isOk, isTrue);
    });

    test('propagates failure from repository', () async {
      final repo = _FakeAvailabilityRepository()
        ..failureToReturn = const RepositoryFailure('create error');
      final useCase = CreateAvailabilityRule(repo, _FakeClock());

      final result = await useCase((rule: _ruleInput()));

      expect(result.isOk, isFalse);
      result.fold(
        ok: (_) => fail('expected error'),
        err: (f) => expect(f.message, 'create error'),
      );
    });
  });
}
