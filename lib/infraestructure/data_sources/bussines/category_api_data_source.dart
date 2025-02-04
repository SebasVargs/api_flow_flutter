import 'package:api_control_flow/domain/entities/bussines/category/category_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/category_repository.dart';
import 'package:sqflite/sqflite.dart';

class CategoryApiDataSource implements CategoryRepository{
  final Database db;

  CategoryApiDataSource({required this.db});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final List<Map<String, dynamic>> maps = await db.query('category');
    return List.generate(maps.length, (i) {
      return CategoryModel.fromMap(maps[i]);
    });
  }

}