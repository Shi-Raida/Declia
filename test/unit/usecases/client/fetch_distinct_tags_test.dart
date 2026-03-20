import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/paged_result.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/client.dart';
import 'package:declia/domain/entities/client_list_query.dart';
import 'package:declia/domain/repositories/client_repository.dart';
import 'package:declia/usecases/client/fetch_distinct_tags.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FetchDistinctTags', () {
    test('delegates to repository and returns Ok with tag list', () async {
      final repo = _FakeClientRepository(tagsToReturn: ['portrait', 'wedding']);
      final useCase = FetchDistinctTags(repo);

      final result = await useCase(const NoParams());

      expect(result, isA<Ok<List<String>, Failure>>());
      expect((result as Ok<List<String>, Failure>).value, [
        'portrait',
        'wedding',
      ]);
    });

    test('returns Err when repository returns failure', () async {
      final repo = _FakeClientRepository(
        failureToReturn: const RepositoryFailure('DB error'),
      );
      final useCase = FetchDistinctTags(repo);

      final result = await useCase(const NoParams());

      expect(result, isA<Err<List<String>, Failure>>());
      expect((result as Err<List<String>, Failure>).error.message, 'DB error');
    });
  });
}

final class _FakeClientRepository implements ClientRepository {
  _FakeClientRepository({this.tagsToReturn, this.failureToReturn});

  final List<String>? tagsToReturn;
  final Failure? failureToReturn;

  @override
  Future<Result<List<String>, Failure>> fetchDistinctTags() async {
    if (failureToReturn != null) return Err(failureToReturn!);
    return Ok(tagsToReturn ?? []);
  }

  @override
  Future<Result<List<Client>, Failure>> fetchAll() =>
      throw UnimplementedError();
  @override
  Future<Result<Client, Failure>> fetchById(String id) =>
      throw UnimplementedError();
  @override
  Future<Result<Client, Failure>> create(Client client) =>
      throw UnimplementedError();
  @override
  Future<Result<Client, Failure>> update(Client client) =>
      throw UnimplementedError();
  @override
  Future<Result<void, Failure>> delete(String id) => throw UnimplementedError();
  @override
  Future<Result<List<Client>, Failure>> search(String query) =>
      throw UnimplementedError();
  @override
  Future<Result<PagedResult<Client>, Failure>> fetchList(
    ClientListQuery query,
  ) => throw UnimplementedError();
}
