import 'package:api_control_flow/domain/entities/bussines/category_sup/category_sup_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/category_sup_repository.dart';
import 'package:sqflite/sqflite.dart';

class CategorySupApiDataSource implements CategorySupRepository{
  final Database db;

  CategorySupApiDataSource({required this.db});

  @override
  Future<List<CategorySupModel>> getCategoriesSup() async {
    final List<Map<String, dynamic>> maps = await db.query('category');
    return List.generate(maps.length, (i) {
      return CategorySupModel.fromMap(maps[i]);
    });
  }

  @override
  Future<int> insertCategorySup(CategorySupModel category) async {
    try {
      return await db.insert('category', category.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace
      );
    } catch (err) {
      throw Exception('Error al insertar una categoria: $err');
    } 
  }

  @override
  Future<int> updateCategorySup(CategorySupModel category) async {
    try {
      return await db.update(
        'category',
        category.toMap(),
        where: 'id = ?',
        whereArgs: [category.id],
      );
    } catch (err) {
      throw Exception('Error al actualizar el producto: $err');
    }
  }

  @override
  Future<int> deleteCategorySup(int id) async {
    try {
      return await db.delete(
        'category',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (err) {
      throw Exception('Error al borrar una categoria: $err');
    }
  }

}