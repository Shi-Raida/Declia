import 'package:declia/core/enums/availability_rule_type.dart';
import 'package:declia/core/errors/app_exception.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/domain/entities/availability_rule.dart';
import 'package:declia/infrastructure/datasources/contract/availability_data_source.dart';
import 'package:declia/infrastructure/repositories/availability_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mocks.dart';

final _now = DateTime(2026, 3, 19);

AvailabilityRule _rule({String id = 'r1'}) => AvailabilityRule(
  id: id,
  tenantId: 'tid',
  ruleType: AvailabilityRuleType.recurring,
  dayOfWeek: 3,
  startTime: '09:00:00',
  endTime: '18:00:00',
  createdAt: _now,
  updatedAt: _now,
);

final class _FakeAvailabilityDataSource implements AvailabilityDataSource {
  List<AvailabilityRule> rulesToReturn = [];
  AvailabilityRule? ruleToReturn;
  Exception? errorToThrow;

  @override
  Future<List<AvailabilityRule>> fetchAll() async {
    if (errorToThrow != null) throw errorToThrow!;
    return rulesToReturn;
  }

  @override
  Future<AvailabilityRule> create(AvailabilityRule rule) async {
    if (errorToThrow != null) throw errorToThrow!;
    return ruleToReturn ?? rule;
  }

  @override
  Future<AvailabilityRule> update(AvailabilityRule rule) async {
    if (errorToThrow != null) throw errorToThrow!;
    return ruleToReturn ?? rule;
  }

  @override
  Future<void> delete(String id) async {
    if (errorToThrow != null) throw errorToThrow!;
  }
}

void main() {
  group('AvailabilityRepositoryImpl', () {
    group('fetchAll', () {
      test('returns rules from data source', () async {
        final ds = _FakeAvailabilityDataSource()..rulesToReturn = [_rule()];
        final repo = AvailabilityRepositoryImpl(
          dataSource: ds,
          guard: MockRepositoryGuard(),
        );

        final result = await repo.fetchAll();

        expect(result.isOk, isTrue);
        result.fold(
          ok: (rules) => expect(rules.length, 1),
          err: (_) => fail('expected ok'),
        );
      });

      test('returns failure when guard is offline', () async {
        final ds = _FakeAvailabilityDataSource();
        final guard = MockRepositoryGuard()..isOnline = false;
        final repo = AvailabilityRepositoryImpl(dataSource: ds, guard: guard);

        final result = await repo.fetchAll();

        expect(result.isOk, isFalse);
      });
    });

    group('create', () {
      test('delegates to data source create', () async {
        final rule = _rule();
        final ds = _FakeAvailabilityDataSource()..ruleToReturn = rule;
        final repo = AvailabilityRepositoryImpl(
          dataSource: ds,
          guard: MockRepositoryGuard(),
        );

        final result = await repo.create(rule);

        expect(result.isOk, isTrue);
        result.fold(
          ok: (r) => expect(r.id, rule.id),
          err: (_) => fail('expected ok'),
        );
      });

      test('returns failure on data source error', () async {
        final ds = _FakeAvailabilityDataSource()
          ..errorToThrow = const RepositoryException('create error');
        final repo = AvailabilityRepositoryImpl(
          dataSource: ds,
          guard: MockRepositoryGuard(),
        );

        final result = await repo.create(_rule());

        expect(result.isOk, isFalse);
        result.fold(
          ok: (_) => fail('expected error'),
          err: (f) => expect(f.message, 'create error'),
        );
      });
    });

    group('update', () {
      test('delegates to data source update', () async {
        final rule = _rule();
        final ds = _FakeAvailabilityDataSource()..ruleToReturn = rule;
        final repo = AvailabilityRepositoryImpl(
          dataSource: ds,
          guard: MockRepositoryGuard(),
        );

        final result = await repo.update(rule);

        expect(result.isOk, isTrue);
      });
    });

    group('delete', () {
      test('delegates to data source delete', () async {
        final ds = _FakeAvailabilityDataSource();
        final repo = AvailabilityRepositoryImpl(
          dataSource: ds,
          guard: MockRepositoryGuard(),
        );

        final result = await repo.delete('r1');

        expect(result.isOk, isTrue);
      });

      test('returns failure when guard override set', () async {
        final ds = _FakeAvailabilityDataSource();
        final guard = MockRepositoryGuard()
          ..failureOverride = const RepositoryFailure('DB error');
        final repo = AvailabilityRepositoryImpl(dataSource: ds, guard: guard);

        final result = await repo.delete('r1');

        expect(result.isOk, isFalse);
        result.fold(
          ok: (_) => fail('expected error'),
          err: (f) => expect(f.message, 'DB error'),
        );
      });
    });
  });
}
