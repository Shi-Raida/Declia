import 'package:declia/core/enums/consent_type.dart';
import 'package:declia/core/errors/app_exception.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/repositories/repository_guard.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/infrastructure/datasources/contract/consent_data_source.dart';
import 'package:declia/infrastructure/repositories/consent_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeConsentDataSource implements ConsentDataSource {
  String? lastConsentType;
  bool? lastGranted;
  String? lastAnonId;
  bool shouldThrow = false;

  @override
  Future<void> saveConsent({
    required String consentType,
    required bool granted,
    required String anonId,
  }) async {
    if (shouldThrow) {
      throw const RepositoryException('db unavailable');
    }
    lastConsentType = consentType;
    lastGranted = granted;
    lastAnonId = anonId;
  }
}

final class _PassthroughGuard implements RepositoryGuard {
  @override
  Future<Result<T, Failure>> call<T>(
    Future<T> Function() action, {
    required String method,
  }) async {
    try {
      return Ok(await action());
    } on AppException catch (e) {
      return Err(Failure.fromException(e));
    }
  }
}

ConsentRepositoryImpl _makeRepo(_FakeConsentDataSource ds) =>
    ConsentRepositoryImpl(dataSource: ds, guard: _PassthroughGuard());

void main() {
  group('ConsentRepositoryImpl', () {
    test('saveConsent delegates to datasource with correct args', () async {
      final ds = _FakeConsentDataSource();
      final repo = _makeRepo(ds);

      final result = await repo.saveConsent(
        consentType: ConsentType.analytics,
        granted: true,
        anonId: 'anon-123',
      );

      expect(result, isA<Ok<void, Failure>>());
      expect(ds.lastConsentType, 'analytics');
      expect(ds.lastGranted, isTrue);
      expect(ds.lastAnonId, 'anon-123');
    });

    test('saveConsent converts enum to name string', () async {
      final ds = _FakeConsentDataSource();
      final repo = _makeRepo(ds);

      await repo.saveConsent(
        consentType: ConsentType.marketing,
        granted: false,
        anonId: 'anon-456',
      );

      expect(ds.lastConsentType, 'marketing');
      expect(ds.lastGranted, isFalse);
    });

    test(
      'saveConsent returns Err when datasource throws RepositoryException',
      () async {
        final ds = _FakeConsentDataSource()..shouldThrow = true;
        final repo = _makeRepo(ds);

        final result = await repo.saveConsent(
          consentType: ConsentType.functional,
          granted: true,
          anonId: 'anon-789',
        );

        expect(result, isA<Err<void, Failure>>());
        expect((result as Err).error, isA<RepositoryFailure>());
      },
    );
  });
}
