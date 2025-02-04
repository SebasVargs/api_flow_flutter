import 'package:api_control_flow/domain/entities/users/supplier/supplier_model.dart';
import 'package:api_control_flow/domain/repositories/users/supplier_repository.dart';
import 'package:sqflite/sqflite.dart';

class SupplierApiDataSource implements SupplierRepository {
  final Database db;

  SupplierApiDataSource({required this.db});

  @override
  Future<int> insertSupplier(SupplierModel supplier) async {
    try {
      return await db.insert('supplier', supplier.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (err) {
      throw Exception('Error al insertar un proveedor: $err');
    }
  }

  @override
  Future<List<SupplierModel>> getSuppliers() async {
    try {
      final List<Map<String, dynamic>> maps = await db.query('supplier');
      return List.generate(maps.length, (i) {
        return SupplierModel.fromMap(maps[i]);
      });
    } catch (err) {
      throw Exception('Error al obtener los proveedores: $err');
    }
  }

  @override
  Future<int> updateSupplier(SupplierModel supplier) async {
    try {
      return await db.update(
        'supplier',
        supplier.toMap(),
        where: 'id = ?',
        whereArgs: [supplier.id],
      );
    } catch (err) {
      throw Exception('Error al actualizar los proveedores: $err');
    }
  }

  @override
  Future<int> deleteSupplier(int id) async {
    try {
      return await db.delete(
        'supplier',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (err) {
      throw Exception('Error al eliminar el proveedor: $err');
    }
  }

  @override
  Future<SupplierModel?> getSupplierById(int id) async {
    try {
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
    } catch (err) {
      throw Exception('Error al obtener al proveedor por id: $err');
    }
  }
}
