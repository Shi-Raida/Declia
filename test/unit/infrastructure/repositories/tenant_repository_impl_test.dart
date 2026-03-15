import 'package:declia/core/errors/app_exception.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/repositories/repository_guard.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/infrastructure/datasources/contract/tenant_data_source.dart';
import 'package:declia/domain/entities/tenant.dart';
import 'package:declia/infrastructure/repositories/tenant_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

// UUIDs matching seed.sql
const _tenantAId = '00000000-0000-0000-0000-000000000001';
const _tenantBId = '00000000-0000-0000-0000-000000000002';
const _userAId = '00000000-0000-0000-0001-000000000001';
const _userBId = '00000000-0000-0000-0001-000000000002';
const _userCId = '00000000-0000-0000-0001-000000000003';

final _tenantA = Tenant(
  id: _tenantAId,
  name: 'Fleur de Lumiere',
  slug: 'fleur-de-lumiere',
  branding: const TenantBranding(primaryColor: '#C084A0'),
  domain: 'fleur-de-lumiere.local',
  createdAt: DateTime.utc(2026, 1, 1),
);

final _tenantB = Tenant(
  id: _tenantBId,
  name: 'Studio Luminos',
  slug: 'studio-luminos',
  branding: const TenantBranding(),
  domain: null,
  createdAt: DateTime.utc(2026, 1, 2),
);

final class _FakeTenantDataSource implements TenantDataSource {
  _FakeTenantDataSource(this.currentUserId);

  final String currentUserId;

  static const _userTenantMap = {
    _userAId: _tenantAId,
    _userBId: _tenantAId,
    _userCId: _tenantBId,
  };

  late final _tenantFixtures = {_tenantAId: _tenantA, _tenantBId: _tenantB};

  @override
  Future<Tenant> fetchCurrentUserTenant() async {
    final tenantId = _userTenantMap[currentUserId];
    if (tenantId == null) throw const UnauthorisedTenantAccessException();
    return _tenantFixtures[tenantId]!;
  }

  @override
  Future<Tenant> fetchById(String tenantId) async {
    if (tenantId == _tenantBId && _userTenantMap[currentUserId] != _tenantBId) {
      throw const UnauthorisedTenantAccessException();
    }
    final fixture = _tenantFixtures[tenantId];
    if (fixture == null) throw NotFoundTenantException(tenantId);
    return fixture;
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

TenantRepositoryImpl _makeRepo(String? userId) => TenantRepositoryImpl(
  dataSource: _FakeTenantDataSource(userId ?? ''),
  currentUserId: () => userId,
  guard: _PassthroughGuard(),
);

void main() {
  group('TenantRepositoryImpl', () {
    test(
      'fetchCurrentUserTenant returns Ok with tenant A for user A',
      () async {
        final repo = _makeRepo(_userAId);
        final result = await repo.fetchCurrentUserTenant();

        expect(result, isA<Ok<Tenant, Failure>>());
        final tenant = (result as Ok<Tenant, Failure>).value;
        expect(tenant.id, _tenantAId);
        expect(tenant.name, 'Fleur de Lumiere');
        expect(tenant.slug, 'fleur-de-lumiere');
        expect(tenant.domain, 'fleur-de-lumiere.local');
        expect(tenant.branding.primaryColor, '#C084A0');
      },
    );

    test(
      'fetchCurrentUserTenant returns Ok with tenant B for user C',
      () async {
        final repo = _makeRepo(_userCId);
        final result = await repo.fetchCurrentUserTenant();

        expect(result, isA<Ok<Tenant, Failure>>());
        final tenant = (result as Ok<Tenant, Failure>).value;
        expect(tenant.id, _tenantBId);
        expect(tenant.name, 'Studio Luminos');
      },
    );

    test('fetchCurrentUserTenant returns Err when user is null', () async {
      final repo = _makeRepo(null);
      final result = await repo.fetchCurrentUserTenant();

      expect(result, isA<Err<Tenant, Failure>>());
      expect((result as Err).error, isA<UnauthorisedTenantAccessFailure>());
    });

    test(
      'fetchById returns Err when user A tries to access tenant B',
      () async {
        final repo = _makeRepo(_userAId);
        final result = await repo.fetchById(_tenantBId);

        expect(result, isA<Err<Tenant, Failure>>());
        expect((result as Err).error, isA<UnauthorisedTenantAccessFailure>());
      },
    );
  });
}
