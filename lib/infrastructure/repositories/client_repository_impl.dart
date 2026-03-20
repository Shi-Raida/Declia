import '../../core/errors/failures.dart';
import '../../core/repositories/repository_guard.dart';
import '../../core/utils/paged_result.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/client_list_query.dart';
import '../../domain/repositories/client_repository.dart';
import '../datasources/contract/client_data_source.dart';

final class ClientRepositoryImpl implements ClientRepository {
  const ClientRepositoryImpl({
    required ClientDataSource dataSource,
    required RepositoryGuard guard,
  }) : _dataSource = dataSource,
       _guard = guard;

  final ClientDataSource _dataSource;
  final RepositoryGuard _guard;

  @override
  Future<Result<List<Client>, Failure>> fetchAll() =>
      _guard(() => _dataSource.fetchAll(), method: 'fetchAll');

  @override
  Future<Result<Client, Failure>> fetchById(String id) =>
      _guard(() => _dataSource.fetchById(id), method: 'fetchById');

  @override
  Future<Result<Client, Failure>> create(Client client) =>
      _guard(() => _dataSource.create(client), method: 'create');

  @override
  Future<Result<Client, Failure>> update(Client client) =>
      _guard(() => _dataSource.update(client), method: 'update');

  @override
  Future<Result<void, Failure>> delete(String id) =>
      _guard(() => _dataSource.delete(id), method: 'delete');

  @override
  Future<Result<List<Client>, Failure>> search(String query) =>
      _guard(() => _dataSource.search(query), method: 'search');

  @override
  Future<Result<PagedResult<Client>, Failure>> fetchList(
    ClientListQuery query,
  ) async {
    final result = await _guard(
      () => _dataSource.fetchList(query),
      method: 'fetchList',
    );
    return result.map(
      (tuple) => PagedResult(items: tuple.$1, totalCount: tuple.$2),
    );
  }

  @override
  Future<Result<List<String>, Failure>> fetchDistinctTags() => _guard(
    () => _dataSource.fetchDistinctTags(),
    method: 'fetchDistinctTags',
  );
}
