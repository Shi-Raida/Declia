import 'package:declia/core/errors/app_exception.dart';
import 'package:declia/domain/datasources/tenant_data_source.dart';
import 'package:declia/domain/entities/tenant.dart';
import 'package:declia/infrastructure/repositories/tenant_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

// UUIDs matching seed.sql
const _tenantAId = '00000000-0000-0000-0000-000000000001';
const _tenantBId = '00000000-0000-0000-0000-000000000002';
const _userAId = '00000000-0000-0000-0001-000000000001';
const _userBId = '00000000-0000-0000-0001-000000000002';
const _userCId = '00000000-0000-0000-0001-000000000003';

final _tenantA = Tenant.fromJson(<String, dynamic>{
  'id': _tenantAId,
  'name': 'Fleur de Lumiere',
  'slug': 'fleur-de-lumiere',
  'branding': <String, dynamic>{'primary_color': '#C084A0', 'logo_url': null},
  'domain': 'fleur-de-lumiere.local',
  'created_at': '2026-01-01T00:00:00.000Z',
});

final _tenantB = Tenant.fromJson(<String, dynamic>{
  'id': _tenantBId,
  'name': 'Studio Luminos',
  'slug': 'studio-luminos',
  'branding': <String, dynamic>{},
  'domain': null,
  'created_at': '2026-01-02T00:00:00.000Z',
});

// Simulates RLS: the "current user" is set externally (mirrors auth session).
final class _FakeTenantDataSource implements TenantDataSource {
  _FakeTenantDataSource(this.currentUserId);

  final String currentUserId;

  // userId → tenantId mapping (mirrors seed.sql)
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
    // Simulate RLS: cross-tenant access is blocked.
    if (tenantId == _tenantBId && _userTenantMap[currentUserId] != _tenantBId) {
      throw const UnauthorisedTenantAccessException();
    }
    final fixture = _tenantFixtures[tenantId];
    if (fixture == null) throw NotFoundTenantException(tenantId);
    return fixture;
  }
}

TenantRepositoryImpl _makeRepo(String? userId) => TenantRepositoryImpl(
  dataSource: _FakeTenantDataSource(userId ?? ''),
  currentUserId: () => userId,
);

void main() {
  group('TenantRepositoryImpl', () {
    test('fetchCurrentUserTenant returns tenant A for user A', () async {
      final repo = _makeRepo(_userAId);
      final tenant = await repo.fetchCurrentUserTenant();

      expect(tenant.id, _tenantAId);
      expect(tenant.name, 'Fleur de Lumiere');
      expect(tenant.slug, 'fleur-de-lumiere');
      expect(tenant.domain, 'fleur-de-lumiere.local');
      expect(tenant.branding.primaryColor, '#C084A0');
    });

    test('fetchCurrentUserTenant returns tenant B for user C', () async {
      final repo = _makeRepo(_userCId);
      final tenant = await repo.fetchCurrentUserTenant();

      expect(tenant.id, _tenantBId);
      expect(tenant.name, 'Studio Luminos');
    });

    test(
      'fetchCurrentUserTenant throws UnauthorisedTenantAccessException when user is null',
      () async {
        final repo = _makeRepo(null);

        expect(
          () => repo.fetchCurrentUserTenant(),
          throwsA(isA<UnauthorisedTenantAccessException>()),
        );
      },
    );

    test(
      'fetchById tenant B with user A context throws UnauthorisedTenantAccessException',
      () async {
        final repo = _makeRepo(_userAId);

        expect(
          () => repo.fetchById(_tenantBId),
          throwsA(isA<UnauthorisedTenantAccessException>()),
        );
      },
    );
  });
}
