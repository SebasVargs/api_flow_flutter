import 'package:api_control_flow/domain/entities/bussines/category_sup/category_sup_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/category_sup_repository.dart';

class InsertCategorySupUseCase {
  final CategorySupRepository categorySupRepository;

  InsertCategorySupUseCase(this.categorySupRepository);

  Future<int> execute(CategorySupModel supply) {
    return categorySupRepository.insertCategorySup(supply);
  }
}