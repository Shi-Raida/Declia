import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../entities/client.dart';

abstract interface class ClientRepository {
  Future<Result<List<Client>, Failure>> fetchAll();
  Future<Result<Client, Failure>> fetchById(String id);
  Future<Result<Client, Failure>> create(Client client);
  Future<Result<Client, Failure>> update(Client client);
  Future<Result<void, Failure>> delete(String id);
  Future<Result<List<Client>, Failure>> search(String query);
}
