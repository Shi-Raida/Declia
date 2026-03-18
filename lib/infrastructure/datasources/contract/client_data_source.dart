import '../../../domain/entities/client.dart';

abstract interface class ClientDataSource {
  Future<List<Client>> fetchAll();
  Future<Client> fetchById(String id);
  Future<Client> create(Client client);
  Future<Client> update(Client client);
  Future<void> delete(String id);
  Future<List<Client>> search(String query);
}
