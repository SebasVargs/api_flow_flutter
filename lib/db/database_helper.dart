import 'dart:async';

import 'package:api_control_flow/db/scripts/insert_definitions.dart';
import 'package:api_control_flow/db/scripts/table_definitions.dart';
import 'package:api_control_flow/domain/entities/bussines/buys/buys_model.dart';
import 'package:api_control_flow/domain/entities/bussines/supply/supply_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_migration/sqflite_migration.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

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
        TableDefinitios.methOfPayment,
        TableDefinitios.documentType,
        TableDefinitios.city,
        TableDefinitios.department,
        TableDefinitios.statusBill,
        TableDefinitios.measure,
        TableDefinitios.categorySup,
        TableDefinitios.categoryPro,
        TableDefinitios.type,
        TableDefinitios.client,
        TableDefinitios.clienType,
        TableDefinitios.sale,
        TableDefinitios.paymentMeth,
        TableDefinitios.salePayment,
        TableDefinitios.product,
        TableDefinitios.supplier,
        TableDefinitios.buys,
        TableDefinitios.buysDetails,
        TableDefinitios.saleDetail,
        TableDefinitios.tpyeCash,
        TableDefinitios.conceptCash,
        TableDefinitios.cashFlow,
        TableDefinitios.user,
        TableDefinitios.transmitter,
        TableDefinitios.bill,
        TableDefinitios.detailBill,
        InsertDefinitions.methOfPayment,
        InsertDefinitions.documentType,
        InsertDefinitions.statusBill,
        InsertDefinitions.measure,
        InsertDefinitions.categorySup,
        InsertDefinitions.categoryPro,
        InsertDefinitions.type,
        InsertDefinitions.paymentMeth,
        InsertDefinitions.typeCash,
        InsertDefinitions.conceptCash,
        InsertDefinitions.user,
        InsertDefinitions.city,
        InsertDefinitions.department
      ],
      migrationScripts: [
        // Scripts de migración (para versiones futuras)
        // Ejemplo: Creación de la tabla "maps"
        // Agrega aquí más scripts de migración a medida que los necesites
      ],
    );
    return await openDatabaseWithMigration(path, config);
  }

  Future<List<Map<String, dynamic>>> obtenerTodosLosSupplies() async {
    final db = await database;
    return await db.query('supply');
  }

  Future<int> insertBuy(BuysModel buy) async {
    final db = await database;
    return await db.insert('buys', buy.toMap());
  }

  Future<int> insertBuyDetail(BuysDetailModel detail) async {
    final db = await database;
    return await db.insert('buys_details', detail.toMap());
  }
}
