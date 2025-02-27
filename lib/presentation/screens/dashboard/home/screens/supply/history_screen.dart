import 'package:api_control_flow/db/database_helper.dart';
import 'package:api_control_flow/domain/entities/bussines/buys/buys_model.dart';
import 'package:api_control_flow/domain/entities/bussines/supply/supply_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/buys_repository.dart';
import 'package:api_control_flow/domain/repositories/bussines/status_repository.dart';
import 'package:api_control_flow/domain/repositories/bussines/supply_repository.dart';
import 'package:api_control_flow/domain/repositories/users/client_repository.dart';
import 'package:api_control_flow/domain/repositories/users/supplier_repository.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/buys_api_data_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/status_api_data_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/supply_api_date_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/users/client_api_data_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/users/supplier_api_data_source.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Color para elementos con cliente
  static const Color amberColor = Color(0xFFFFC107);

  final dbHelper = DatabaseHelper.instance;
  late BuysRepository _buysRepository;
  late SupplyRepository _supplyRepository;
  late SupplierRepository _supplierRepository;
  late ClientRepository _clientRepository;
  late StatusRepository _statusRepository;

  final TextEditingController _searchController = TextEditingController();

  List<BuysModel> _buys = [];
  List<int?> _buysWithClient = [];
  List<BuysModel> _filteredBuys = [];
  Map<int, List<BuysDetailModel>> _detailsByBuy = {};
  Map<int, String> _supplierNames = {};
  Map<int, String> _clientNames = {};
  Map<int, String> _statusName = {};

  final numberFormat = NumberFormat("#,##0", "es_ES");

  @override
  void initState() {
    super.initState();
    _initDatabaseAndLoadRepositories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initDatabaseAndLoadRepositories() async {
    final db = await dbHelper.database;
    _buysRepository = BuysApiDataSource(db: db);
    _supplyRepository = SupplyApiDateSource(db: db);
    _supplierRepository = SupplierApiDataSource(db: db);
    _clientRepository = ClientApiDataSource(db: db);
    _statusRepository = StatusApiDataSource(db: db);
    await _loadBuysSuppliersAndClients();
  }

  Future<void> _loadBuysSuppliersAndClients() async {
    final compras = await _buysRepository.getBuys();
    final detalles = await _supplyRepository.getSupplies();
    final proveedores = await _supplierRepository.getSuppliers();
    final clientes = await _clientRepository.getClients();
    final estados = await _statusRepository.getStatues();

    setState(() {
      _buys = compras;
      _filteredBuys = List.from(_buys);
      _buysWithClient = _buys
          .where((buy) => buy.id_client != null)
          .map((buy) => buy.id)
          .toList();

      _supplierNames = {
        for (var supplier in proveedores) supplier.id!: supplier.company_name
      };

      _clientNames = {
        for (var client in clientes) client.id!: client.company_name
      };

      _statusName = {for (var status in estados) status.id!: status.name};

      _detailsByBuy = {};
      for (var detail in detalles) {
        _detailsByBuy.putIfAbsent(detail.id_buys!, () => []).add(detail);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Compras"),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _filteredBuys.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.all(12),
                      children: _buys.asMap().entries.map((entry) {
                        int index = entry.key + 1;
                        BuysModel buy = entry.value;
                        bool hasClient = _buysWithClient.contains(buy.id);
                        String supplierName =
                            _supplierNames[buy.id_supplier] ?? "Desconocido";
                        String status =
                            _statusName[buy.id_status_bill] ?? "Desconocido";
                        bool isPending = status == "Pendiente";

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          color: isPending
                              ? Colors.red
                                  .shade50 // Color de fondo rojo claro si es "Pendiente"
                              : hasClient
                                  ? Colors.blue.shade50 // Azul si tiene cliente
                                  : Colors.white, // Blanco en otros casos
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: isPending
                                  ? Colors.red
                                      .shade700 // Borde rojo si es "Pendiente"
                                  : hasClient
                                      ? Colors.blue
                                          .shade700 // Azul si tiene cliente
                                      : Colors
                                          .grey.shade500, // Gris en otros casos
                              width: isPending
                                  ? 2
                                  : (hasClient
                                      ? 1.5
                                      : 1), // Borde más grueso si está pendiente
                            ),
                          ),
                          elevation: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              iconColor: isPending
                                  ? Colors.red.shade700
                                  : hasClient
                                      ? Colors.blue.shade700
                                      : Colors.grey.shade700,
                              collapsedIconColor: isPending
                                  ? Colors.red.shade700
                                  : hasClient
                                      ? Colors.blue.shade700
                                      : Colors.grey.shade700,
                              title: Text(
                                '#$index $supplierName',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isPending
                                      ? Colors.red.shade700
                                      : hasClient
                                          ? Colors.blue.shade700
                                          : Colors.black87,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    "Total: \$${numberFormat.format(buy.total)}",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  Text(
                                    "Estado: $status",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isPending
                                          ? Colors.red.shade700
                                          : Colors.black87,
                                      fontWeight: isPending
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    "Fecha: ${DateFormat('dd-MM-yyyy hh:mm a').format(buy.date_buy)}",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  if (buy.id_client != null &&
                                      _clientNames.containsKey(buy.id_client))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        "Cliente: ${_clientNames[buy.id_client]}",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: hasClient
                                              ? Colors.blue.shade700
                                              : Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Column(
                                    children: _detailsByBuy[buy.id]
                                            ?.map((detail) {
                                          return ListTile(
                                            dense: true,
                                            leading: Icon(
                                              Icons.shopping_cart,
                                              color: isPending
                                                  ? Colors.red.shade700
                                                  : hasClient
                                                      ? Colors.blue.shade700
                                                      : Colors.grey.shade600,
                                            ),
                                            title: Text(
                                              '${detail.description} - \$${numberFormat.format(detail.unit_cost)}',
                                            ),
                                            trailing: Text(
                                              "${detail.stock}x",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: isPending
                                                    ? Colors.red.shade700
                                                    : hasClient
                                                        ? Colors.blue.shade700
                                                        : Colors.black,
                                              ),
                                            ),
                                          );
                                        }).toList() ??
                                        [
                                          const Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text(
                                              "No hay detalles disponibles.",
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          )
                                        ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
