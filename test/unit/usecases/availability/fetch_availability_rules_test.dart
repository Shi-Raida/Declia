import 'package:declia/core/enums/availability_rule_type.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/availability_rule.dart';
import 'package:declia/domain/repositories/availability_repository.dart';
import 'package:declia/usecases/availability/fetch_availability_rules.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 3, 19);

AvailabilityRule _rule() => AvailabilityRule(
  id: 'r1',
  tenantId: 'tid',
  ruleType: AvailabilityRuleType.recurring,
  dayOfWeek: 3,
  startTime: '09:00:00',
  endTime: '18:00:00',
  createdAt: _now,
  updatedAt: _now,
);

final class _FakeAvailabilityRepository implements AvailabilityRepository {
  List<AvailabilityRule> rulesToReturn = [];
  Failure? failureToReturn;

  @override
  Future<Result<List<AvailabilityRule>, Failure>> fetchAll() async {
    if (failureToReturn != null) return Err(failureToReturn!);
    return Ok(rulesToReturn);
  }

  @override
  Future<Result<AvailabilityRule, Failure>> create(
    AvailabilityRule rule,
  ) async => Ok(rule);

  @override
  Future<Result<AvailabilityRule, Failure>> update(
    AvailabilityRule rule,
  ) async => Ok(rule);

  @override
  Future<Result<void, Failure>> delete(String id) async => const Ok(null);
}

void main() {
  group('FetchAvailabilityRules', () {
    test('returns rules from repository', () async {
      final repo = _FakeAvailabilityRepository()..rulesToReturn = [_rule()];
      final useCase = FetchAvailabilityRules(repo);

      final result = await useCase(const NoParams());

      expect(result.isOk, isTrue);
      result.fold(
        ok: (rules) => expect(rules.length, 1),
        err: (_) => fail('expected ok'),
      );
    });

    test('returns empty list when repository returns empty', () async {
      final repo = _FakeAvailabilityRepository();
      final useCase = FetchAvailabilityRules(repo);

      final result = await useCase(const NoParams());

      expect(result.isOk, isTrue);
      result.fold(
        ok: (rules) => expect(rules, isEmpty),
        err: (_) => fail('expected ok'),
      );
    });

    test('propagates failure from repository', () async {
      final repo = _FakeAvailabilityRepository()
        ..failureToReturn = const RepositoryFailure('fetch error');
      final useCase = FetchAvailabilityRules(repo);

      final result = await useCase(const NoParams());

      expect(result.isOk, isFalse);
      result.fold(
        ok: (_) => fail('expected error'),
        err: (f) => expect(f.message, 'fetch error'),
      );
    });
  });
}
