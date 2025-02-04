import 'package:api_control_flow/domain/entities/users/client/client_model.dart';

abstract class ClientRepository {
  Future<List<ClientModel>> getClients();
  Future<int> insertClient(ClientModel client);
  Future<int> updateClient(ClientModel client);
  Future<int> deleteClient(int id);
  Future<ClientModel?> getClientById(int id);
}