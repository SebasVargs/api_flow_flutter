import 'package:api_control_flow/domain/entities/bussines/category/category_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/category_repository.dart';

class GetCategeoriesUseCase {
  final CategoryRepository categoryRepository;

  GetCategeoriesUseCase(this.categoryRepository);

  Future<List<CategoryModel>> execute(){
    return categoryRepository.getCategories();
  }
}