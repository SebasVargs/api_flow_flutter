
import 'package:api_control_flow/db/models/bussines/product/product_model.dart';
import 'package:sqflite/sqflite.dart';

class ProductRepository {
  final Database db;

  ProductRepository({required this.db});

  Future<int> insertarInsumo(ProductModel product) async {
    return await db.insert('product', product.toMap());
  }

  Future<List<ProductModel>> obtenerProductos() async {
    final List<Map<String, dynamic>> maps = await db.query('product');
    return List.generate(maps.length, (i) {
      return ProductModel.fromMap(maps[i]);
    });
  }

  Future<int> actualizarProducto(ProductModel product) async {
    return await db.update(
      'supplier',
      product.toMap(),
      where: 'id = ?', // Cláusula WHERE para identificar el proveedor
      whereArgs: [product.id], // Argumentos para la cláusula WHERE
    );
  }

  Future<int> eliminarProducto(int id) async {
    return await db.delete(
      'product',
      where: 'id = ?', // Cláusula WHERE para identificar el proveedor
      whereArgs: [id], // Argumentos para la cláusula WHERE
    );
  }

    Future<ProductModel?> obtenerProductoPorId(int id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'product',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1, // Limitar a un solo resultado (debería ser único)
    );

    if (maps.isNotEmpty) {
      return ProductModel.fromMap(maps[0]);
    } else {
      return null; // Retorna null si no se encuentra el proveedor
    }
  }
}