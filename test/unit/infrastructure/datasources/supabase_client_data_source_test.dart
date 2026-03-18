import 'package:declia/core/errors/app_exception.dart';
import 'package:declia/infrastructure/datasources/supabase_client_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('mapClientPostgrestException', () {
    test('PGRST116 maps to ClientNotFoundException', () {
      const e = PostgrestException(
        message: 'JSON object requested, multiple (or no) rows returned',
        code: 'PGRST116',
      );

      final result = mapClientPostgrestException(e, 'client-123');

      expect(result, isA<ClientNotFoundException>());
      final notFound = result as ClientNotFoundException;
      expect(notFound.clientId, 'client-123');
    });

    test('42501 maps to UnauthorisedClientAccessException', () {
      const e = PostgrestException(
        message: 'permission denied for table clients',
        code: '42501',
      );

      final result = mapClientPostgrestException(e, 'some-id');

      expect(result, isA<UnauthorisedClientAccessException>());
    });

    test('unknown code maps to RepositoryException', () {
      const e = PostgrestException(
        message: 'connection refused',
        code: '08006',
      );

      final result = mapClientPostgrestException(e, 'some-id');

      expect(result, isA<RepositoryException>());
      final repo = result as RepositoryException;
      expect(repo.message, 'connection refused');
      expect(repo.cause, e);
    });

    test('null code maps to RepositoryException', () {
      const e = PostgrestException(message: 'unexpected error');

      final result = mapClientPostgrestException(e, 'some-id');

      expect(result, isA<RepositoryException>());
    });
  });
}
