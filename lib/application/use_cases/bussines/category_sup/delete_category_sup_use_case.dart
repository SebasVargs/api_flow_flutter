import 'package:api_control_flow/domain/repositories/bussines/category_sup_repository.dart';

class DeleteCategorySupUseCase {
  final CategorySupRepository categorySupRepository;

  DeleteCategorySupUseCase(this.categorySupRepository);

  Future<int> execute(int id) {
    return categorySupRepository.deleteCategorySup(id);
  }
}