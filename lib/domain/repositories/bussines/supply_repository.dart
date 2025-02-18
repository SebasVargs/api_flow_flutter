import 'package:api_control_flow/domain/entities/bussines/supply/supply_model.dart';

abstract class SupplyRepository {
  Future<List<BuysDetailModel>> getSupplies();
  Future<int> insertSupply(BuysDetailModel supply);
  Future<int> updateSupply(BuysDetailModel supply);
  Future<int> deleteSupply(int id);
  Future<BuysDetailModel?> getSupplyById(int id);
}