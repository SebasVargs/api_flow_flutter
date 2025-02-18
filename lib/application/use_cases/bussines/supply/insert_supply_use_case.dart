import 'package:api_control_flow/domain/entities/bussines/supply/supply_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/supply_repository.dart';

class InsertSupplyUseCase {
  final SupplyRepository supplyRepository;

  InsertSupplyUseCase(this.supplyRepository);

  Future<int> execute(BuysDetailModel supply){
    return supplyRepository.insertSupply(supply);
  }
}