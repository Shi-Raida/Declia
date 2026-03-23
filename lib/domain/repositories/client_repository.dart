import '../../core/errors/failures.dart';
import '../../core/utils/paged_result.dart';
import '../../core/utils/result.dart';
import '../entities/client.dart';
import '../entities/client_list_query.dart';

abstract interface class ClientReader {
  Future<Result<List<Client>, Failure>> fetchAll();
  Future<Result<Client, Failure>> fetchById(String id);
  Future<Result<List<Client>, Failure>> search(String query);
  Future<Result<PagedResult<Client>, Failure>> fetchList(ClientListQuery query);
  Future<Result<List<String>, Failure>> fetchDistinctTags();
}

abstract interface class ClientWriter {
  Future<Result<Client, Failure>> create(Client client);
  Future<Result<Client, Failure>> update(Client client);
  Future<Result<void, Failure>> delete(String id);
}

abstract interface class ClientRepository
    implements ClientReader, ClientWriter {}
