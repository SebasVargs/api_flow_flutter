import 'package:api_control_flow/domain/repositories/users/client_repository.dart';

class DeleteClientUseCase {
  final ClientRepository clientRepository;

  DeleteClientUseCase(this.clientRepository);

  Future<int> execute(int id){
    return clientRepository.deleteClient(id);
  }
}