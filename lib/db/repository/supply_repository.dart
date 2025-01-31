import 'package:api_control_flow/db/models/bussines/supply/supply_model.dart';
import 'package:sqflite/sqflite.dart';

class SupplyRepository {
  final Database db;

  SupplyRepository({required this.db});

  Future<int> insertarInsumo(SupplyModel supply) async {
    return await db.insert('supply', supply.toMap());
  }

  Future<List<SupplyModel>> obtenerInsumos() async {
    final List<Map<String, dynamic>> maps = await db.query('supply');
    return List.generate(maps.length, (i) {
      return SupplyModel.fromMap(maps[i]);
    });
  }

  Future<int> actualizarInsumo(SupplyModel supply) async {
    return await db.update(
      'supply',
      supply.toMap(),
      where: 'id = ?', // Cláusula WHERE para identificar el proveedor
      whereArgs: [supply.id], // Argumentos para la cláusula WHERE
    );
  }

  Future<int> eliminarInsumo(int id) async {
    return await db.delete(
      'supply',
      where: 'id = ?', // Cláusula WHERE para identificar el proveedor
      whereArgs: [id], // Argumentos para la cláusula WHERE
    );
  }

    Future<SupplyModel?> obtenerInsumoPorId(int id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'supply',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1, // Limitar a un solo resultado (debería ser único)
    );

    if (maps.isNotEmpty) {
      return SupplyModel.fromMap(maps[0]);
    } else {
      return null; // Retorna null si no se encuentra el proveedor
    }
  }
}