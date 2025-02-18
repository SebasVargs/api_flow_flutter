import 'package:api_control_flow/domain/entities/bussines/buys/buys_model.dart';

abstract class BuysRepository{
  Future<List<BuysModel>> getBuys();
  Future<int> insertBuys(BuysModel buys);
  Future<int> updateBuys(BuysModel buys);
  Future<int> deleteBuys(int id);
}