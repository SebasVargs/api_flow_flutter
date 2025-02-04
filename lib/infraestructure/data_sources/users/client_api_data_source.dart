import 'package:api_control_flow/domain/entities/users/client/client_model.dart';
import 'package:api_control_flow/domain/repositories/users/client_repository.dart';
import 'package:sqflite/sqflite.dart';

class ClientApiDataSource implements ClientRepository {
  final Database db;

  ClientApiDataSource({required this.db});

  @override
  Future<int> insertClient(ClientModel client) async {
    try {
      return await db.insert('client', client.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (err) {
      throw Exception('Error al insertar el client: $err');
    }
  }

  @override
  Future<List<ClientModel>> getClients() async {
    try {
      final List<Map<String, dynamic>> maps = await db.query('client');
      return List.generate(maps.length, (i) {
        return ClientModel.fromMap(maps[i]);
      });
    } catch (err) {
      throw Exception('Error al obtener los clientes: $err');
    }
  }

  @override
  Future<int> updateClient(ClientModel client) async {
    try {
      return await db.update(
        'client',
        client.toMap(),
        where: 'id = ?',
        whereArgs: [client.id],
      );
    } catch (err) {
      throw Exception('Error al actualizar el client: $err');
    }
  }

  @override
  Future<int> deleteClient(int id) async {
    try {
      return await db.delete(
        'client',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (err) {
      throw Exception('Error al eliminar el cliente: $err');
    }
  }

  @override
  Future<ClientModel?> getClientById(int id) async {
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'client',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (maps.isNotEmpty) {
        return ClientModel.fromMap(maps[0]);
      } else {
        return null;
      }
    } catch (err) {
      throw Exception('Error al obtener el cliente por id: $err');
    }
  }
}
