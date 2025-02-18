import 'package:api_control_flow/domain/entities/bussines/supply/supply_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/supply_repository.dart';

class GetSupplyByIdUseCase {
  final SupplyRepository supplyRepository;

  GetSupplyByIdUseCase(this.supplyRepository);

  Future<BuysDetailModel?> execute(int id){
    return supplyRepository.getSupplyById(id);
  }
}