import 'package:api_control_flow/domain/entities/bussines/category_sup/category_sup_model.dart';

abstract class CategorySupRepository {
  Future<List<CategorySupModel>> getCategoriesSup();
  Future<int> insertCategorySup(CategorySupModel supply);
  Future<int> updateCategorySup(CategorySupModel supply);
  Future<int> deleteCategorySup(int id);
}