import 'package:declia/core/errors/app_exception.dart';
import 'package:declia/infrastructure/datasources/supabase_tenant_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('mapPostgrestException', () {
    test('PGRST116 maps to NotFoundTenantException', () {
      const e = PostgrestException(
        message: 'JSON object requested, multiple (or no) rows returned',
        code: 'PGRST116',
      );

      final result = mapPostgrestException(e, 'tenant-123');

      expect(result, isA<NotFoundTenantException>());
      final notFound = result as NotFoundTenantException;
      expect(notFound.tenantId, 'tenant-123');
    });

    test('42501 maps to UnauthorisedTenantAccessException', () {
      const e = PostgrestException(
        message: 'permission denied for table tenants',
        code: '42501',
      );

      final result = mapPostgrestException(e, 'some-tenant-id');

      expect(result, isA<UnauthorisedTenantAccessException>());
    });

    test('unknown code maps to RepositoryException', () {
      const e = PostgrestException(
        message: 'connection refused',
        code: '08006',
      );

      final result = mapPostgrestException(e, 'some-id');

      expect(result, isA<RepositoryException>());
      final repo = result as RepositoryException;
      expect(repo.message, 'connection refused');
      expect(repo.cause, e);
    });

    test('null code maps to RepositoryException', () {
      const e = PostgrestException(message: 'unexpected error');

      final result = mapPostgrestException(e, 'some-id');

      expect(result, isA<RepositoryException>());
    });
  });
}
