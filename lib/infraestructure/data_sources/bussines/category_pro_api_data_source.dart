import 'package:api_control_flow/domain/entities/bussines/category_pro/category_pro_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/category_pro_repository.dart';
import 'package:sqflite/sqflite.dart';

class CategoryProApiDataSource implements CategoryProRepository{
  final Database db;

  CategoryProApiDataSource({required this.db});

  @override
  Future<List<CategoryProModel>> getCategoriesPro() async {
    final List<Map<String, dynamic>> maps = await db.query('category_pro');
    return List.generate(maps.length, (i) {
      return CategoryProModel.fromMap(maps[i]);
    });
  }

  @override
  Future<int> insertCategoryPro(CategoryProModel category) async {
    try {
      return await db.insert('category_pro', category.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace
      );
    } catch (err) {
      throw Exception('Error al insertar una categoria: $err');
    } 
  }

  @override
  Future<int> updateCategoryPro(CategoryProModel category) async {
    try {
      return await db.update(
        'category_pro',
        category.toMap(),
        where: 'id = ?',
        whereArgs: [category.id],
      );
    } catch (err) {
      throw Exception('Error al actualizar el producto: $err');
    }
  }

  @override
  Future<int> deleteCategoryPro(int id) async {
    try {
      return await db.delete(
        'category_pro',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (err) {
      throw Exception('Error al borrar una categoria: $err');
    }
  }

}