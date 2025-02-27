import 'package:api_control_flow/domain/entities/bussines/status/status_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/status_repository.dart';
import 'package:sqflite/sqflite.dart';

class StatusApiDataSource implements StatusRepository{
  final Database db;

  StatusApiDataSource({required this.db});

  @override
  Future<List<StatusModel>> getStatues() async {
    final List<Map<String, dynamic>> maps = await db.query('status_bill');
    return List.generate(maps.length, (i) {
      return StatusModel.fromMap(maps[i]);
    });
  }

  @override
  Future<int> insertStatus(StatusModel category) async {
    try {
      return await db.insert('status_bill', category.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace
      );
    } catch (err) {
      throw Exception('Error al insertar un estado: $err');
    } 
  }

  @override
  Future<int> updateStatus(StatusModel category) async {
    try {
      return await db.update(
        'status_bill',
        category.toMap(),
        where: 'id = ?',
        whereArgs: [category.id],
      );
    } catch (err) {
      throw Exception('Error al actualizar el estado: $err');
    }
  }

  @override
  Future<int> deleteStatus(int id) async {
    try {
      return await db.delete(
        'status_bill',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (err) {
      throw Exception('Error al borrar un estado: $err');
    }
  }

}