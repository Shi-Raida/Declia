import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/availability_rule.dart';
import 'package:declia/domain/repositories/availability_repository.dart';
import 'package:declia/usecases/availability/delete_availability_rule.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeAvailabilityRepository implements AvailabilityRepository {
  String? lastDeletedId;
  Failure? failureToReturn;

  @override
  Future<Result<List<AvailabilityRule>, Failure>> fetchAll() async =>
      const Ok([]);

  @override
  Future<Result<AvailabilityRule, Failure>> create(
    AvailabilityRule rule,
  ) async => Ok(rule);

  @override
  Future<Result<AvailabilityRule, Failure>> update(
    AvailabilityRule rule,
  ) async => Ok(rule);

  @override
  Future<Result<void, Failure>> delete(String id) async {
    if (failureToReturn != null) return Err(failureToReturn!);
    lastDeletedId = id;
    return const Ok(null);
  }
}

void main() {
  group('DeleteAvailabilityRule', () {
    test('delegates to repository delete with correct id', () async {
      final repo = _FakeAvailabilityRepository();
      final useCase = DeleteAvailabilityRule(repo);

      await useCase((id: 'rule-42'));

      expect(repo.lastDeletedId, 'rule-42');
    });

    test('returns ok on success', () async {
      final repo = _FakeAvailabilityRepository();
      final useCase = DeleteAvailabilityRule(repo);

      final result = await useCase((id: 'r1'));

      expect(result.isOk, isTrue);
    });

    test('propagates failure from repository', () async {
      final repo = _FakeAvailabilityRepository()
        ..failureToReturn = const RepositoryFailure('delete error');
      final useCase = DeleteAvailabilityRule(repo);

      final result = await useCase((id: 'r1'));

      expect(result.isOk, isFalse);
      result.fold(
        ok: (_) => fail('expected error'),
        err: (f) => expect(f.message, 'delete error'),
      );
    });
  });
}
