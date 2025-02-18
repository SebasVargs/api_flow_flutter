import 'package:api_control_flow/domain/entities/bussines/category_pro/category_pro_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/category_pro_repository.dart';

class InsertCategoryProUseCase {
  final CategoryProRepository categoryProRepository;

  InsertCategoryProUseCase(this.categoryProRepository);

  Future<int> execute(CategoryProModel category) {
    return categoryProRepository.insertCategoryPro(category);
  }
}