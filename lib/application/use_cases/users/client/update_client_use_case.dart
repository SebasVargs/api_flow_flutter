import 'package:api_control_flow/domain/entities/users/client/client_model.dart';
import 'package:api_control_flow/domain/repositories/users/client_repository.dart';

class UpdateClientUseCase {
  final ClientRepository clientRepository;

  UpdateClientUseCase(this.clientRepository);

  Future<int> execute(ClientModel client){
    return clientRepository.updateClient(client);
  }
}