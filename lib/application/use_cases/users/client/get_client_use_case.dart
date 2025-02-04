import 'package:api_control_flow/domain/entities/users/client/client_model.dart';
import 'package:api_control_flow/domain/repositories/users/client_repository.dart';

class GetClientUseCase {
  final ClientRepository clientRepository;

  GetClientUseCase(this.clientRepository);

  Future<List<ClientModel>> execute( ){
    return clientRepository.getClients();
  }
}