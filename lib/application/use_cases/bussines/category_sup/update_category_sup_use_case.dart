import 'package:api_control_flow/domain/entities/bussines/category_sup/category_sup_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/category_sup_repository.dart';

class UpdateCategorySupUseCase {
  final CategorySupRepository categorySupRepository;

  UpdateCategorySupUseCase(this.categorySupRepository);

  Future<int> execute(CategorySupModel supply) {
    return categorySupRepository.updateCategorySup(supply);
  }
}