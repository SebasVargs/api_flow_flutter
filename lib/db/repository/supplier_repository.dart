import 'package:sqflite/sqflite.dart';
import 'package:api_control_flow/db/models/users/supplier/supplier_model.dart';

class SupplierRepository {
  final Database db;

  SupplierRepository({required this.db});

  Future<int> insertarProveedor(SupplierModel supplier) async {
    return await db.insert('supplier', supplier.toMap());
  }

  Future<List<SupplierModel>> obtenerProveedores() async {
    final List<Map<String, dynamic>> maps = await db.query('supplier');
    return List.generate(maps.length, (i) {
      return SupplierModel.fromMap(maps[i]);
    });
  }

  Future<int> actualizarProveedor(SupplierModel supplier) async {
    return await db.update(
      'supplier',
      supplier.toMap(),
      where: 'id = ?', // Cláusula WHERE para identificar el proveedor
      whereArgs: [supplier.id], // Argumentos para la cláusula WHERE
    );
  }

  Future<int> eliminarProveedor(int id) async {
    return await db.delete(
      'supplier',
      where: 'id = ?', // Cláusula WHERE para identificar el proveedor
      whereArgs: [id], // Argumentos para la cláusula WHERE
    );
  }

    Future<SupplierModel?> obtenerProveedorPorId(int id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'supplier',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1, // Limitar a un solo resultado (debería ser único)
    );

    if (maps.isNotEmpty) {
      return SupplierModel.fromMap(maps[0]);
    } else {
      return null; // Retorna null si no se encuentra el proveedor
    }
  }
}