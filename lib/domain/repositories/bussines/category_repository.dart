import 'package:api_control_flow/domain/entities/bussines/category/category_model.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> getCategories();

}