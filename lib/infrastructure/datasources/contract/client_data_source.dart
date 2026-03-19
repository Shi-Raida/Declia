import '../../../domain/entities/client.dart';
import '../../../domain/entities/client_list_query.dart';

abstract interface class ClientDataSource {
  Future<List<Client>> fetchAll();
  Future<Client> fetchById(String id);
  Future<Client> create(Client client);
  Future<Client> update(Client client);
  Future<void> delete(String id);
  Future<List<Client>> search(String query);
  Future<(List<Client>, int)> fetchList(ClientListQuery query);
  Future<List<String>> fetchDistinctTags();
}
