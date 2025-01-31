import 'package:api_control_flow/db/models/bussines/category/category_model.dart';
import 'package:sqflite/sqflite.dart';

class CategoryRepository {
  final Database db; // Recibe la instancia de la base de datos

  CategoryRepository({required this.db});

  Future<List<CategoryModel>> obtenerCategorias() async {
    final List<Map<String, dynamic>> maps = await db.query('category');
    return List.generate(maps.length, (i) {
      return CategoryModel.fromMap(maps[i]);
    });
  }

}