import 'package:api_control_flow/db/database_helper.dart';
import 'package:api_control_flow/domain/entities/bussines/buys/buys_model.dart';
import 'package:api_control_flow/domain/entities/bussines/category_sup/category_sup_model.dart';
import 'package:api_control_flow/domain/entities/bussines/measure/measure_model.dart';
import 'package:api_control_flow/domain/entities/bussines/status/status_model.dart';
import 'package:api_control_flow/domain/entities/bussines/supply/supply_model.dart';
import 'package:api_control_flow/domain/entities/users/client/client_model.dart';
import 'package:api_control_flow/domain/entities/users/supplier/supplier_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/buys_repository.dart';
import 'package:api_control_flow/domain/repositories/bussines/category_sup_repository.dart';
import 'package:api_control_flow/domain/repositories/bussines/measure_repository.dart';
import 'package:api_control_flow/domain/repositories/bussines/status_repository.dart';
import 'package:api_control_flow/domain/repositories/bussines/supply_repository.dart';
import 'package:api_control_flow/domain/repositories/users/client_repository.dart';
import 'package:api_control_flow/domain/repositories/users/supplier_repository.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/buys_api_data_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/category_sup_api_data_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/measure_api_data_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/status_api_data_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/supply_api_date_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/users/client_api_data_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/users/supplier_api_data_source.dart';
import 'package:api_control_flow/presentation/screens/dashboard/home/components/supply/icon_buy.dart';
import 'package:api_control_flow/presentation/screens/dashboard/home/screens/supply/form/add_category_screen.dart';
import 'package:api_control_flow/presentation/screens/dashboard/home/screens/supply/history_screen.dart';
import 'package:flutter/material.dart';
import 'form/add_buy_screen.dart';
import 'package:intl/intl.dart';

class InsumoScreen extends StatefulWidget {
  const InsumoScreen({super.key});

  @override
  State<InsumoScreen> createState() => _InsumoScreenState();
}

class _InsumoScreenState extends State<InsumoScreen> {
  final TextEditingController _searchController = TextEditingController();
  final dbHelper = DatabaseHelper.instance;
  late SupplyRepository _supplyRepository;
  late CategorySupRepository _categorySupRepository;
  late BuysRepository _buysRepository;
  late SupplierRepository _supplierRepository;
  late MeasureRepository _measureRepository;
  late ClientRepository _clientRepository;
  late StatusRepository _statusRepository;

  Map<int, List<BuysDetailModel>> _buysDetailsByCategory = {};

  List<BuysDetailModel> _supplies = [];
  List<CategorySupModel> _categoriesSup = [];
  List<CategorySupModel> _filteredCategoriesSup = [];
  List<BuysModel> _buys = [];
  List<SupplierModel> _suppliers = [];
  List<MeasureModel> _measures = [];
  List<ClientModel> _clients = [];
  List<StatusModel> _statues = [];

  bool _isEditingStatus = false;

  String supplierName = 'Desconocido';
  int? supplierId;
  String? measureName;
  int? clientId;
  int? statusId;
  String clientName = '';
  String statusName = '';

  final numberFormat = NumberFormat("#,##0.00", "es_ES"); // Español

  @override
  void initState() {
    super.initState();
    _initDatabaseAndLoadRepositories();
    _searchController.addListener(_filterCategories); // Escuchar cambios
  }

  @override
  void dispose() {
    _searchController
        .removeListener(_filterCategories); // Importante: remover el listener
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initDatabaseAndLoadRepositories() async {
    final db = await dbHelper.database;
    _supplyRepository = SupplyApiDateSource(db: db);
    _categorySupRepository = CategorySupApiDataSource(db: db);
    _buysRepository = BuysApiDataSource(db: db);
    _supplierRepository = SupplierApiDataSource(db: db);
    _measureRepository = MeasureApiDataSource(db: db);
    _clientRepository = ClientApiDataSource(db: db);
    _statusRepository = StatusApiDataSource(db: db);
    await _loadSupplies();
    await _loadCategories();
    await _loadBuys();
    await _loadDetailsBuys();
    await _loadSuppliers();
    await _loadMeasures();
    await _loadClients();
    await _loadStatues();
  }

  void _actualizarEstadoCompra(
      int idCompra, int nuevoEstado, List<StatusModel> statusList) async {
    try {
      int result = await _buysRepository.updateBuyStatus(idCompra, nuevoEstado);

      if (result > 0) {
        setState(() {
          statusId = nuevoEstado;
          statusName = statusList.firstWhere((s) => s.id == nuevoEstado).name;
          _isEditingStatus = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Estado de la compra actualizado con éxito")),
        );
      } else {
        throw Exception("No se pudo actualizar el estado de la compra");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al actualizar: $e")),
      );
    }
  }

  List<int?> _buysWithClient = [];

  void _filterBuysWithClient() {
    setState(() {
      _buysWithClient = _buys
          .where((buy) => buy.id_client != null)
          .map((buy) => buy.id)
          .toList();
    });
  }

  Future<void> _loadBuys() async {
    final compras = await _buysRepository.getBuys();
    setState(() {
      _buys = compras;
    });
    _filterBuysWithClient();
  }

  Future<void> _loadSupplies() async {
    final insumos = await _categorySupRepository.getCategoriesSup();
    setState(() {
      _categoriesSup = insumos;
      _filteredCategoriesSup = List.from(insumos);
    });
  }

  Future<void> _loadClients() async {
    final clientes = await _clientRepository.getClients();
    setState(() {
      _clients = clientes;
    });
  }

  Future<void> _loadStatues() async {
    final estados = await _statusRepository.getStatues();
    setState(() {
      _statues = estados;
    });
  }

  Future<void> _loadSuppliers() async {
    final proveedores = await _supplierRepository.getSuppliers();
    setState(() {
      _suppliers = proveedores;
    });
  }

  Future<void> _loadMeasures() async {
    final medidas = await _measureRepository.getMeasures();
    setState(() {
      _measures = medidas;
    });
  }

  Future<void> _loadDetailsBuys() async {
    final detallesCompras = await _supplyRepository.getSupplies();

    // Agrupar detalles de compra por id_category_sup
    Map<int, List<BuysDetailModel>> groupedDetails = {};
    for (var detail in detallesCompras) {
      groupedDetails.putIfAbsent(detail.id_category_sup, () => []).add(detail);
    }

    setState(() {
      _supplies = detallesCompras;
      _buysDetailsByCategory = groupedDetails;
    });
  }

  Future<void> _loadCategories() async {
    final categorias = await _categorySupRepository.getCategoriesSup();
    setState(() {
      _categoriesSup = categorias;
      _filteredCategoriesSup = List.from(categorias);
    });
  }

  void _filterCategories() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCategoriesSup = _categoriesSup
          .where((h) => h.name.toLowerCase().contains(query))
          .toList();
    });
  }

  String _getEstadoCompra(int? idBuys) {
    if (idBuys == null) return '';

    // Filtrar las compras por ID
    final buysFiltered = _buys.where((b) => b.id == idBuys).toList();
    if (buysFiltered.isEmpty || buysFiltered.first.id_status_bill == null)
      return '';

    // Filtrar los estados por ID
    final statusId = buysFiltered.first.id_status_bill;
    final statusFiltered = _statues.where((s) => s.id == statusId).toList();
    if (statusFiltered.isEmpty) return '';

    return statusFiltered.first.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El Scaffold es el widget raíz
      appBar: AppBar(title: const Text('Insumos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100
                ),
              ),
            ),
            Expanded(
              // El Expanded también va dentro del Column
              child: _filteredCategoriesSup.isEmpty
                  ? const Center(child: Text('No se encontraron insumos'))
                  : ListView.builder(
                      itemCount: _filteredCategoriesSup.length,
                      itemBuilder: (context, index) {
                        final category = _filteredCategoriesSup[index];
                        final details =
                            _buysDetailsByCategory[category.id] ?? [];
                        return Card(
                          color: const Color(
                              0xFFF5F5F5), // Color de fondo tipo Classroom
                          margin: const EdgeInsets.symmetric(
                              vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                                color: Colors.grey.shade300, width: 1),
                          ),
                          elevation: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header con estilo Classroom
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade700,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      category.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Contenido
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 12),
                                    // Grid de elementos con contador
                                    details.isEmpty
                                        ? Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16),
                                              child: Text(
                                                "No hay elementos en esta categoría",
                                                style: TextStyle(
                                                    color:
                                                        Colors.grey.shade600),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey.shade300),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 8,
                                                      horizontal: 12),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade100,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(4),
                                                      topRight:
                                                          Radius.circular(4),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${details.length} elementos",
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Toca para ver detalles",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .grey.shade700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: Wrap(
                                                    spacing: 10.0,
                                                    runSpacing: 10.0,
                                                    children:
                                                        details.map((detail) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          _mostrarDetallesCompra(
                                                              detail,
                                                              _buys,
                                                              _suppliers,
                                                              _measures,
                                                              _clients,
                                                              _statues);
                                                        },
                                                        child: Container(
                                                          width: 60,
                                                          height: 70,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              IconBuy(
                                                                iconColor: _buysWithClient
                                                                        .contains(detail
                                                                            .id_buys)
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .white,
                                                                backColor: _buysWithClient
                                                                        .contains(
                                                                            detail
                                                                                .id_buys)
                                                                    ? Colors
                                                                        .blue
                                                                        .shade600
                                                                    : const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        107,
                                                                        120,
                                                                        113),
                                                              ),
                                                              const SizedBox(
                                                                  height: 4),
                                                              Text(
                                                                "${detail.stock}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: _getEstadoCompra(detail
                                                                              .id_buys) ==
                                                                          'Pendiente'
                                                                      ? Colors
                                                                          .red // Rojo si está pendiente
                                                                      : _buysWithClient.contains(detail
                                                                              .id_buys)
                                                                          ? Colors
                                                                              .blue
                                                                              .shade600 // Azul si tiene cliente
                                                                          : Colors
                                                                              .black, // Negro para los demás casos
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            SizedBox(
              width: 48,
              height: 48,
              child: FloatingActionButton(
                heroTag: "accionesRapidasTag",
                mini: true,
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue.shade700,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.blue.shade100, width: 1),
                ),
                onPressed: () {
                  // Acción rápida, por ejemplo mostrar un menú de opciones
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (context) => Container(
                      padding: const EdgeInsets.all(16),
                      height: 255,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 10, bottom: 16, top: 5),
                            child: Text(
                              "Acciones rápidas",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.add_circle,
                                color: Colors.blue.shade700),
                            title: const Text("Nueva compra"),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const InsumoFormScreen(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.history,
                                color: Colors.blue.shade700),
                            title: const Text("Ver historial"),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HistoryScreen()));
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.add_business_outlined,
                                color: Colors.blue.shade700),
                            title: const Text("Agregar Insumo"),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AddCategoryScreen()));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.more_vert, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDetallesCompra(
      BuysDetailModel detail,
      List<BuysModel> buysList,
      List<SupplierModel> suppliersList,
      List<MeasureModel> measuresList,
      List<ClientModel> clientsList,
      List<StatusModel> statusList) {
    DateTime? makeDate;
    clientName = '';
    supplierName = '';
    measureName = '';
    int? nuevoEstado; // Variable para el nuevo estado seleccionado

    for (var buy in buysList) {
      if (buy.id == detail.id_buys) {
        supplierId = buy.id_supplier;
        clientId = buy.id_client;
        makeDate = buy.date_buy;
        statusId = buy.id_status_bill;
        break;
      }
    }

    if (statusId != null) {
      for (var sta in statusList) {
        if (sta.id == statusId) {
          statusName = sta.name;
        }
      }
    }

    for (var mea in measuresList) {
      if (mea.id == detail.id_measure) {
        measureName = mea.name;
      }
    }

    if (clientId != null) {
      for (var client in clientsList) {
        if (client.id == clientId) {
          clientName = client.company_name;
        }
      }
    }

    if (supplierId != null) {
      for (var supplier in suppliersList) {
        if (supplier.id == supplierId) {
          supplierName = supplier.company_name;
          break;
        }
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final total = detail.stock * detail.unit_cost;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                width: 1000,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: IconBuy(
                              iconColor: Colors.white,
                              backColor: statusName == 'Pendiente'
                                  ? Colors.red
                                  : clientId != null
                                      ? Colors.amber
                                      : const Color.fromARGB(
                                          255, 107, 120, 113),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Detalles de la compra",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            statusName,
                            style: TextStyle(
                              color: statusName == 'Pagado'
                                  ? Colors.blue
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              setStateDialog(() {
                                _isEditingStatus = !_isEditingStatus;
                                nuevoEstado =
                                    statusId; // Inicializar con el valor actual
                              });
                            },
                          ),
                        ],
                      ),
                      if (_isEditingStatus)
                        DropdownButtonFormField<int>(
                          value: nuevoEstado,
                          items: statusList.map((status) {
                            return DropdownMenuItem<int>(
                              value: status.id,
                              child: Text(status.name),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              setStateDialog(() {
                                nuevoEstado = newValue;
                              });
                            }
                          },
                        ),
                      const Divider(),
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (clientName.isNotEmpty) ...[
                              _infoTile("Cliente", clientName),
                              const Divider(),
                            ],
                            _infoTile(
                                "Fecha",
                                makeDate != null
                                    ? DateFormat('dd-MM-yyyy \n hh:mm a')
                                        .format(makeDate!)
                                    : "Fecha desconocida"),
                            const Divider(),
                            _infoTile("Proveedor", supplierName),
                            const Divider(),
                            _infoTile("Descripción", detail.description),
                            const Divider(),
                            if (detail.weight != null &&
                                detail.weight != 0) ...[
                              _infoTile(
                                  "Peso", "${detail.weight} $measureName"),
                              const Divider(),
                            ],
                            if (detail.size != null && detail.size != 0) ...[
                              _infoTile(
                                  "Tamaño", "${detail.size} $measureName"),
                              const Divider(),
                            ],
                            _infoTile('Cantidad', '${detail.stock}'),
                            const Divider(),
                            _infoTile("Precio unitario",
                                "\$${numberFormat.format(detail.unit_cost)}"),
                            const Divider(),
                            _infoTile(
                                "Total", "\$${numberFormat.format(total)}",
                                isTotal: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey.shade700,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cerrar"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: _isEditingStatus
                                ? () {
                                    if (nuevoEstado != null &&
                                        nuevoEstado != statusId) {
                                      _actualizarEstadoCompra(detail.id_buys!,
                                          nuevoEstado!, statusList);
                                      setStateDialog(() {
                                        statusId = nuevoEstado!;
                                        statusName = statusList
                                            .firstWhere(
                                                (s) => s.id == nuevoEstado)
                                            .name;
                                        _isEditingStatus = false;
                                      });
                                    } else {
                                      setStateDialog(() {
                                        _isEditingStatus = false;
                                      });
                                    }
                                    Navigator.of(context).pop();
                                  }
                                : () {
                                    Navigator.of(context).pop();
                                  },
                            child:
                                Text(_isEditingStatus ? "Guardar" : "Aceptar"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _infoTile(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? Colors.blue.shade700 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
