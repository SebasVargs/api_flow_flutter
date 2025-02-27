import 'package:api_control_flow/domain/entities/bussines/supply/supply_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/supply_repository.dart';
import 'package:sqflite/sqflite.dart';

class SupplyApiDateSource implements SupplyRepository {
  final Database db;

  SupplyApiDateSource({required this.db});

  @override
  Future<int> insertSupply(BuysDetailModel supply) async {
    try {
      return await db.insert('buys_details', supply.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (err) {
      throw Exception('Error al insertar el insumo: $err');
    }
  }

  @override
  Future<List<BuysDetailModel>> getSupplies() async {
    try {
      final List<Map<String, dynamic>> maps = await db.query('buys_details');
      return List.generate(maps.length, (i) {
        return BuysDetailModel.fromMap(maps[i]);
      });
    } catch (err) {
      throw Exception('Error al obtener los insumos: $err');
    }
  }

  @override
  Future<int> updateSupply(BuysDetailModel supply) async {
    try {
      return await db.update(
        'buys_details',
        supply.toMap(),
        where: 'id = ?',
        whereArgs: [supply.id],
      );
    } catch (err) {
      throw Exception('Error al actualizar el insumo: $err');
    }
  }

  @override
  Future<int> deleteSupply(int id) async {
    try {
      return await db.delete(
        'buys_details',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (err) {
      throw Exception('Error al eliminar un insumo: $err');
    }
  }

  @override
  Future<BuysDetailModel?> getSupplyById(int id) async {
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'buys_details',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (maps.isNotEmpty) {
        return BuysDetailModel.fromMap(maps[0]);
      } else {
        return null;
      }
    } catch (err) {
      throw Exception('Error al obtener el insumo por id: $err');
    }
  }
}
