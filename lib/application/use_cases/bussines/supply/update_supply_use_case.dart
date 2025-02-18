import 'package:api_control_flow/domain/entities/bussines/supply/supply_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/supply_repository.dart';

class UpdateSupplyUseCase {
  final SupplyRepository supplyRepository;

  UpdateSupplyUseCase(this.supplyRepository);

  Future<int> execute(BuysDetailModel supply){
    return supplyRepository.updateSupply(supply);
  }
}