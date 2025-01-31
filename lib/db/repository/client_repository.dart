import 'package:api_control_flow/db/models/users/client/client_model.dart';
import 'package:sqflite/sqflite.dart';

class ClientRepository {
  final Database db; // Recibe la instancia de la base de datos

  ClientRepository({required this.db});

  Future<int> insertClient(ClientModel client) async {
    return await db.insert('client', client.toMap()); // Usa 'supplier' directamente
  }

  Future<List<ClientModel>> obtenerClientes() async {
    final List<Map<String, dynamic>> maps = await db.query('client');
    return List.generate(maps.length, (i) {
      return ClientModel.fromMap(maps[i]);
    });
  }

  Future<int> actualizarCliente(ClientModel client) async {
    return await db.update(
      'supplier',
      client.toMap(),
      where: 'id = ?', // Cláusula WHERE para identificar el proveedor
      whereArgs: [client.id], // Argumentos para la cláusula WHERE
    );
  }

  Future<int> eliminarCliente(int id) async {
    return await db.delete(
      'client',
      where: 'id = ?', // Cláusula WHERE para identificar el proveedor
      whereArgs: [id], // Argumentos para la cláusula WHERE
    );
  }

    Future<ClientModel?> obtenerClientePorId(int id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'cliente',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1, // Limitar a un solo resultado (debería ser único)
    );

    if (maps.isNotEmpty) {
      return ClientModel.fromMap(maps[0]);
    } else {
      return null; // Retorna null si no se encuentra el proveedor
    }
  }

}