import 'package:api_control_flow/domain/entities/bussines/supply/supply_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/supply_repository.dart';

class GetSupplyUseCase {
  final SupplyRepository supplyRepository;

  GetSupplyUseCase(this.supplyRepository);

  Future<List<SupplyModel>> execute( ){
    return supplyRepository.getSupplies();
  }
}