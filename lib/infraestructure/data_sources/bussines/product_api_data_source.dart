import 'package:api_control_flow/domain/entities/bussines/product/product_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/product_repository.dart';
import 'package:sqflite/sqflite.dart';

class ProductApiDataSource implements ProductRepository {
  final Database db;

  ProductApiDataSource({required this.db});

  @override
  Future<int> insertProduct(ProductModel product) async {
    try {
      return await db.insert('product', product.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (err) {
      throw Exception('Error al insertar un producto: $err');
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final List<Map<String, dynamic>> maps = await db.query('product');
      return List.generate(maps.length, (i) {
        return ProductModel.fromMap(maps[i]);
      });
    } catch (err) {
      throw Exception('Error al obtener los productos: $err');
    }
  }

  @override
  Future<int> updateProduct(ProductModel product) async {
    try {
      return await db.update(
        'product',
        product.toMap(),
        where: 'id = ?',
        whereArgs: [product.id],
      );
    } catch (err) {
      throw Exception('Error al actualizar el producto: $err');
    }
  }

  @override
  Future<int> deleteProduct(int id) async {
    try {
      return await db.delete(
        'product',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (err) {
      throw Exception('Error al borrar un producto: $err');
    }
  }

  @override
  Future<ProductModel?> getProductById(int id) async {
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'product',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return ProductModel.fromMap(maps[0]);
      } else {
        return null;
      }
    } catch (err) {
      throw Exception('Error al obtener el producto por id: $err');
    }
  }
}
