import 'package:api_control_flow/domain/entities/bussines/supply/supply_model.dart';

abstract class SupplyRepository {
  Future<List<SupplyModel>> getSupplies();
  Future<int> insertSupply(SupplyModel supply);
  Future<int> updateSupply(SupplyModel supply);
  Future<int> deleteSupply(int id);
  Future<SupplyModel?> getSupplyById(int id);
}