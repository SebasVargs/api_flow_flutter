import 'package:api_control_flow/domain/entities/users/client/client_model.dart';
import 'package:api_control_flow/domain/repositories/users/client_repository.dart';

class InsertClientUseCase {
  final ClientRepository clientRepository;

  InsertClientUseCase(this.clientRepository);

  Future<int> execute(ClientModel client){
    return clientRepository.insertClient(client);
  }
}