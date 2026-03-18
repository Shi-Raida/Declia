import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/tenant.dart';
import 'package:declia/domain/repositories/tenant_repository.dart';
import 'package:declia/usecases/tenant/check_tenant_slug.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeTenantRepository implements TenantRepository {
  final bool slugExists;

  _FakeTenantRepository({required this.slugExists});

  @override
  Future<Result<Tenant, Failure>> fetchCurrentUserTenant() =>
      throw UnimplementedError();

  @override
  Future<Result<Tenant, Failure>> fetchById(String id) =>
      throw UnimplementedError();

  @override
  Future<Result<bool, Failure>> existsBySlug(String slug) async =>
      Ok(slugExists);
}

void main() {
  group('CheckTenantSlug', () {
    test('returns Ok(true) when tenant exists', () async {
      final useCase = CheckTenantSlug(_FakeTenantRepository(slugExists: true));

      final result = await useCase((slug: 'fleur-de-lumiere'));

      expect(result, isA<Ok<bool, Failure>>());
      expect((result as Ok<bool, Failure>).value, isTrue);
    });

    test('returns Ok(false) when tenant does not exist', () async {
      final useCase = CheckTenantSlug(_FakeTenantRepository(slugExists: false));

      final result = await useCase((slug: 'nonexistent'));

      expect(result, isA<Ok<bool, Failure>>());
      expect((result as Ok<bool, Failure>).value, isFalse);
    });
  });
}
