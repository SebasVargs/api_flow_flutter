import 'package:api_control_flow/domain/entities/bussines/category_pro/category_pro_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/category_pro_repository.dart';

class GetCategeoriesProUseCase {
  final CategoryProRepository categoryProRepository;

  GetCategeoriesProUseCase(this.categoryProRepository);

  Future<List<CategoryProModel>> execute(){
    return categoryProRepository.getCategoriesPro();
  }
}