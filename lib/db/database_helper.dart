import 'dart:async';

import 'package:api_control_flow/db/scripts/insert_definitions.dart';
import 'package:api_control_flow/db/scripts/table_definitions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_migration/sqflite_migration.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _open();
    return _database!;
  }

  Future<Database> _open() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'control_flow.db');

    final config = MigrationConfig(
      initializationScript: [
        TableDefinitios.status,
        TableDefinitios.measure,
        TableDefinitios.category,
        TableDefinitios.type,
        TableDefinitios.client,
        TableDefinitios.clienType,
        TableDefinitios.sale,
        TableDefinitios.paymentMeth,
        TableDefinitios.salePayment,
        TableDefinitios.product,
        TableDefinitios.supplier,
        TableDefinitios.buys,
        TableDefinitios.supply,
        TableDefinitios.buysDetail,
        TableDefinitios.saleDetail,
        TableDefinitios.tpyeCash,
        TableDefinitios.conceptCash,
        TableDefinitios.cashFlow,
        TableDefinitios.user,
        InsertDefinitions.category,
        InsertDefinitions.measure,
        InsertDefinitions.status,
        InsertDefinitions.type,
        InsertDefinitions.paymentMeth,
        InsertDefinitions.typeCash,
        InsertDefinitions.conceptCash
      ],
      migrationScripts: [ // Scripts de migración (para versiones futuras)
         // Ejemplo: Creación de la tabla "maps"
        // Agrega aquí más scripts de migración a medida que los necesites
      ],
    );
    return await openDatabaseWithMigration(path, config);
  }

    Future<List<Map<String, dynamic>>> obtenerTodosLosSupplies() async {
    final db = await database;
    return await db.query('supply'); // Consulta simple a la tabla supply
  }
}