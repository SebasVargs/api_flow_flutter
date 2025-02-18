import 'package:api_control_flow/domain/entities/bussines/buys/buys_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/buys_repository.dart';
import 'package:sqflite/sqflite.dart';

class BuysApiDataSource implements BuysRepository{
  final Database db;

  BuysApiDataSource({required this.db});

  @override
  Future<List<BuysModel>> getBuys() async {
    final List<Map<String, dynamic>> maps = await db.query('buys');
    return List.generate(maps.length, (i) {
      return BuysModel.fromMap(maps[i]);
    });
  }

  @override
  Future<int> insertBuys(BuysModel buys) async {
    try {
      return await db.insert('buys', buys.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
      );
    } catch (err) {
      throw Exception('Error al insertar la compra: $err');
    }
  }

  @override
  Future<int> updateBuys(BuysModel buys) async {
    try {
      return await db.update(
        'buys',
        buys.toMap(),
        where: 'id = ?',
        whereArgs: [buys.id]
      );
    } catch (err) {
      throw Exception('Error al actualizar la compra');
    }
  }

  @override
  Future<int> deleteBuys(int id) async {
    try {
      return await db.delete(
        'buys',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (err) {
      throw Exception('Error al borrar una compra: $err');
    }
  }
}