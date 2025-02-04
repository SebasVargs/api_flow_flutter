import 'package:api_control_flow/domain/entities/users/client/client_model.dart';
import 'package:api_control_flow/domain/repositories/users/client_repository.dart';

class GetClientByIdUseCase {
  final ClientRepository clientRepository;

  GetClientByIdUseCase(this.clientRepository);

  Future<ClientModel?> execute(int id){
    return clientRepository.getClientById(id);
  }
}