import 'package:api_control_flow/domain/entities/bussines/buys/buys_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/buys_repository.dart';

class InsertBuysUseCase {
  final BuysRepository buysRepository;

  InsertBuysUseCase(this.buysRepository);

  Future<int> execute(BuysModel buys){
    return buysRepository.insertBuys(buys);
  }
}