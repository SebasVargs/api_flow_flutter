import 'package:api_control_flow/domain/repositories/bussines/category_pro_repository.dart';

class DeleteCategoryProUseCase {
  final CategoryProRepository categoryProRepository;

  DeleteCategoryProUseCase(this.categoryProRepository);

  Future<int> execute(int id) {
    return categoryProRepository.deleteCategoryPro(id);
  }
}