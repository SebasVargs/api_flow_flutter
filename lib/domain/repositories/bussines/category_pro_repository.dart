import 'package:api_control_flow/domain/entities/bussines/category_pro/category_pro_model.dart';

abstract class CategoryProRepository {
  Future<List<CategoryProModel>> getCategoriesPro();
  Future<int> insertCategoryPro(CategoryProModel category);
  Future<int> updateCategoryPro(CategoryProModel category);
  Future<int> deleteCategoryPro(int id);
}