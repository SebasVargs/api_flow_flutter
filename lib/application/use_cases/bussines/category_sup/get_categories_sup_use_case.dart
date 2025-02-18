import 'package:api_control_flow/domain/entities/bussines/category_sup/category_sup_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/category_sup_repository.dart';

class GetCategeoriesSupUseCase {
  final CategorySupRepository categorySupRepository;

  GetCategeoriesSupUseCase(this.categorySupRepository);

  Future<List<CategorySupModel>> execute(){
    return categorySupRepository.getCategoriesSup();
  }
}