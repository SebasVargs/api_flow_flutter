import 'package:api_control_flow/domain/repositories/bussines/supply_repository.dart';

class DeleteSupplyUseCase {
  final SupplyRepository supplyRepository;

  DeleteSupplyUseCase(this.supplyRepository);

  Future<int> execute(int id){
    return supplyRepository.deleteSupply(id);
  }
}