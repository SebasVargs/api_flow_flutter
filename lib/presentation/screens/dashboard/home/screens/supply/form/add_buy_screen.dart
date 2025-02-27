import 'package:api_control_flow/db/database_helper.dart';
import 'package:api_control_flow/domain/entities/bussines/buys/buys_model.dart';
import 'package:api_control_flow/domain/entities/bussines/category_sup/category_sup_model.dart';
import 'package:api_control_flow/domain/entities/bussines/measure/measure_model.dart';
import 'package:api_control_flow/domain/entities/bussines/status/status_model.dart';
import 'package:api_control_flow/domain/entities/bussines/supply/supply_model.dart';
import 'package:api_control_flow/domain/entities/users/client/client_model.dart';
import 'package:api_control_flow/domain/entities/users/supplier/supplier_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/category_sup_repository.dart';
import 'package:api_control_flow/domain/repositories/bussines/measure_repository.dart';
import 'package:api_control_flow/domain/repositories/bussines/status_repository.dart';
import 'package:api_control_flow/domain/repositories/bussines/supply_repository.dart';
import 'package:api_control_flow/domain/repositories/users/client_repository.dart';
import 'package:api_control_flow/domain/repositories/users/supplier_repository.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/category_sup_api_data_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/measure_api_data_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/status_api_data_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/supply_api_date_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/users/client_api_data_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/users/supplier_api_data_source.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class InsumoFormScreen extends StatefulWidget {
  const InsumoFormScreen({super.key});

  @override
  State<InsumoFormScreen> createState() => _InsumoFormScreenState();
}

class _InsumoFormScreenState extends State<InsumoFormScreen> {
  final dbHelper = DatabaseHelper.instance;
  late SupplyRepository _supplyRepository;
  late MeasureRepository _measureRepository;
  late CategorySupRepository _categorySupRepository;
  late SupplierRepository _supplierRepository;
  late StatusRepository _statusRepository;
  late ClientRepository _clientRepository;

  DateTime _selectedDateTime = DateTime.now();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _stockController = TextEditingController();
  final _weightController = TextEditingController();
  final _sizeController = TextEditingController();
  final _unit_costController = TextEditingController();
  final _idMeasureController = TextEditingController();

  double _total = 0.0;
  String? _selectedCategoryName;
  String? _selectedMeasureName;
  int? _selectedSupplierId;
  int? _selectedClientId;
  int? _selectedCategoryId;
  int? _selectedMeasureId;
  int? _selectedStatusId;
  OverlayEntry? _bannerEntry;
  List<BuysDetailModel> arrayToPush = [];
  List<MeasureModel> _measures = [];
  List<CategorySupModel> _categories = [];
  List<SupplierModel> _suppliers = [];
  List<StatusModel> _statues = [];
  List<ClientModel> _clients = [];

  bool _enableSupplierSelection = false;
  bool _enableClientSelection = false;

  final NumberFormat currencyFormat = NumberFormat("#,##0", "es_ES");

  @override
  void initState() {
    super.initState();
    _initDatabaseAndRepository();
  }

  Future<void> _initDatabaseAndRepository() async {
    final db = await dbHelper.database;
    _supplyRepository = SupplyApiDateSource(db: db);
    _measureRepository = MeasureApiDataSource(db: db);
    _categorySupRepository = CategorySupApiDataSource(db: db);
    _supplierRepository = SupplierApiDataSource(db: db);
    _statusRepository = StatusApiDataSource(db: db);
    _clientRepository = ClientApiDataSource(db: db);
    await _loadSuppliers();
    await _loadCategories();
    await _loadMeasures();
    await _loadStatus();
    await _loadClients();
  }

  void _removeItem(int index) {
    setState(() {
      arrayToPush.removeAt(index);
      _calcularYGuardarTotal();
    });
  }

  double _calcularTotal() {
    return arrayToPush.fold(
        0, (total, item) => total + (item.stock * item.unit_cost));
  }

  void _calcularYGuardarTotal() {
    setState(() {
      _total = _calcularTotal();
    });
  }

  Future<void> _loadStatus() async {
    final estados = await _statusRepository.getStatues();
    setState(() => _statues = estados);
  }

  Future<void> _loadClients() async {
    final clientes = await _clientRepository.getClients();
    setState(() => _clients = clientes);
  }

  Future<void> _loadSuppliers() async {
    final proveedores = await _supplierRepository.getSuppliers();
    setState(() => _suppliers = proveedores);
  }

  Future<void> _loadCategories() async {
    final categories = await _categorySupRepository.getCategoriesSup();
    setState(() => _categories = categories);
  }

  Future<void> _loadMeasures() async {
    final measures = await _measureRepository.getMeasures();
    setState(() => _measures = measures);
  }

  void _mostrarBanner(BuildContext context) {
    _bannerEntry?.remove();
    _bannerEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top,
        left: 0,
        right: 0,
        child: MaterialBanner(
          backgroundColor: Colors.white.withValues(),
          forceActionsBelow: true,
          content: const AwesomeSnackbarContent(
            title: 'Creado!',
            message: 'Insumo creado',
            contentType: ContentType.success,
            inMaterialBanner: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _bannerEntry?.remove();
                _bannerEntry = null;
              },
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
    Overlay.of(context).insert(_bannerEntry!);
    Future.delayed(const Duration(seconds: 2), () => _bannerEntry?.remove());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Agregar Compra')),
        body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(children: [
              const SizedBox(height: 20),
              _buildDateTimePicker(),
              const SizedBox(height: 20),
              _buildStatusDropdown(),
              const SizedBox(height: 20),
              _buildSupplierDropdown(),
              const SizedBox(height: 20),
              _buildClientDropdown(),
              const SizedBox(height: 10.0),
              _buildItemsList(),
              _buildTotalAndPurchaseButton(),
            ])),
        floatingActionButton: _buildSpeedDial());
  }

  Widget _buildDateTimePicker() {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
          labelText: 'Fecha y Hora',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDateTime(context),
          )),
      controller: TextEditingController(
        text: _selectedDateTime != null
            ? DateFormat('dd/MM/yyyy HH:mm').format(_selectedDateTime)
            : '',
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: 'Estado',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      value: _selectedStatusId,
      items: _statues.map((status) {
        return DropdownMenuItem<int>(
          value: status.id,
          child: Text(status.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedStatusId = value;
        });
      },
      validator: (value) =>
          value == null ? 'Por favor, selecciona un proveedor' : null,
    );
  }

  Widget _buildSupplierDropdown() {
    return Row(
      children: [
        // Checkbox para habilitar/deshabilitar la selección del proveedor
        Checkbox(
          value: _enableSupplierSelection,
          onChanged: (bool? value) {
            setState(() {
              _enableSupplierSelection = value ?? false;
              if (!_enableSupplierSelection) {
                _selectedSupplierId =
                    null; // Resetear selección si se desactiva
              }
            });
          },
        ),
        const SizedBox(width: 10), // Espaciado entre el checkbox y el dropdown

        // Dropdown para seleccionar proveedor
        Expanded(
          child: DropdownButtonFormField<int>(
            decoration: InputDecoration(
              labelText: 'Proveedor',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            value: _selectedSupplierId,
            items: _suppliers.map((supplier) {
              return DropdownMenuItem<int>(
                value: supplier.id,
                child: Text(supplier.company_name),
              );
            }).toList(),
            onChanged: _enableSupplierSelection
                ? (value) {
                    setState(() {
                      _selectedSupplierId = value;
                    });
                  }
                : null, // Deshabilita cambios si el checkbox está desactivado
            validator: (value) => (_enableSupplierSelection && value == null)
                ? 'Por favor, selecciona un proveedor'
                : null,
            disabledHint: const Text("Proveedor?"),
          ),
        ),
      ],
    );
  }

  Widget _buildClientDropdown() {
    return Row(
      children: [
        // Checkbox para habilitar/deshabilitar la selección del proveedor
        Checkbox(
          value: _enableClientSelection,
          onChanged: (bool? value) {
            setState(() {
              _enableClientSelection = value ?? false;
              if (!_enableClientSelection) {
                _selectedClientId =
                    null; // Resetear selección si se desactiva
              }
            });
          },
        ),
        const SizedBox(width: 10), // Espaciado entre el checkbox y el dropdown
        // Dropdown para seleccionar proveedor
        Expanded(
          child: DropdownButtonFormField<int>(
            decoration: InputDecoration(
              labelText: 'Cliente',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            value: _selectedClientId,
            items: _clients.map((client) {
              return DropdownMenuItem<int>(
                value: client.id,
                child: Text(client.company_name),
              );
            }).toList(),
            onChanged: _enableClientSelection
                ? (value) {
                    setState(() {
                      _selectedClientId = value;
                    });
                  }
                : null, // Deshabilita cambios si el checkbox está desactivado
            validator: (value) => (_enableClientSelection && value == null)
                ? 'Por favor, selecciona un proveedor'
                : null,
            disabledHint: const Text("Cliente?"),
          ),
        ),
      ],
    );
  }

  Widget _buildItemsList() {
    return Expanded(
      child: arrayToPush.isEmpty
          ? const Center(child: Text('No hay insumos agregados'))
          : Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: ListView.builder(
                itemCount: arrayToPush.length,
                itemBuilder: (context, index) => _buildItemCard(index),
              ),
            ),
    );
  }

  Widget _buildItemCard(int index) {
    final toPush = arrayToPush[index];
    final details = _buildItemDetails(toPush);

    return Card(
        color: Colors.white,
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.only(right: 20.0, left: 8.0),
            childrenPadding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
            title: _buildItemTitle(toPush, index),
            children: _buildItemChildren(details),
          ),
        ));
  }

  Widget _buildItemTitle(dynamic toPush, int index) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.dangerous_outlined,
              color: Color.fromARGB(255, 198, 131, 131)),
          onPressed: () => _showConfirmationDialog(context, index),
        ),
        Expanded(
          child: Text(
            toPush.description,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildItemDetails(dynamic toPush) {
    List<Widget> details = [];

    if (toPush.stock != null) {
      details.add(Text('Cantidad: ${toPush.stock.toStringAsFixed(0)}'));
    }
    if (toPush.weight != null && toPush.weight != 0) {
      details.add(Text(
          'Peso: ${toPush.weight?.toStringAsFixed(0)} $_selectedMeasureName'));
    }
    if (toPush.size != null && toPush.size != 0) {
      details.add(Text(
          'Tamaño: \$${toPush.size?.toStringAsFixed(0)} $_selectedCategoryName'));
    }
    if (toPush.weight == null && toPush.size == null) {
      details.add(const Text(''));
    }
    if (toPush.unit_cost != null) {
      details.add(
          Text('Precio unitario: \$${toPush.unit_cost.toStringAsFixed(0)}'));
    }

    return details;
  }

  List<Widget> _buildItemChildren(List<Widget> details) {
    return details.isNotEmpty
        ? [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: details,
              ),
            ),
          ]
        : [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No hay información adicional disponible'),
            )
          ];
  }

  Widget _buildTotalAndPurchaseButton() {
    return Center(
      child: arrayToPush.isNotEmpty
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Total: \$${currencyFormat.format(_total)}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _processPurchase,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text("Comprar"),
                ),
              ],
            )
          : const SizedBox(),
    );
  }

  Future<void> _processPurchase() async {
    if (arrayToPush.isEmpty) return;

    try {
      if (_selectedDateTime == null) {
        throw Exception('Debe seleccionar una fecha.');
      }

      if (_selectedStatusId == null) {
        throw Exception('Debe seleccionar un estado');
      }

      final newBuy = BuysModel(
          id: null,
          date_buy: _selectedDateTime,
          total: _total,
          id_status_bill: _selectedStatusId!,
          id_supplier: _selectedSupplierId,
          id_client: _selectedClientId
      );

      int newBuyId = await DatabaseHelper.instance.insertBuy(newBuy);

      if (newBuyId == 0) {
        throw Exception('Error al insertar la compra en la base de datos');
      }

      for (var detail in arrayToPush) {
        final newDetail = BuysDetailModel(
            id: null,
            description: detail.description,
            stock: detail.stock,
            weight: detail.weight,
            size: detail.size,
            unit_cost: detail.unit_cost,
            id_measure: detail.id_measure,
            id_buys: newBuyId,
            id_category_sup: detail.id_category_sup);

        await DatabaseHelper.instance.insertBuyDetail(newDetail);
      }

      setState(() {
        arrayToPush.clear();
        _total = 0.0;
        _selectedSupplierId = null;
        _selectedStatusId = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compra realizada con éxito!')));
      Navigator.pop(context);
    } catch (err) {
      print('Este es el error: $err');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al procesar la compra!')));
    }
  }

  void _selectDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDateTime ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime:
              TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()));

      if (pickedTime != null) {
        setState(() {
          // Combinar fecha y hora en un solo DateTime
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Widget _buildSpeedDial() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, right: 5),
      child: SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        overlayOpacity: 0.4,
        spaceBetweenChildren: 10,
        buttonSize: const Size(65, 65),
        childrenButtonSize: const Size(60, 60),
        spacing: 5,
        elevation: 8,
        shape: RoundedRectangleBorder( // Aplica radio al botón principal
          borderRadius: BorderRadius.circular(20), // Ajusta el radio aquí
        ),
        children: [
          _buildSpeedDialChild(Icons.add_shopping_cart, 'Frutas'),
          _buildSpeedDialChild(Icons.category, 'Empaques'),
          _buildSpeedDialChild(Icons.more_horiz, 'Otros'),
        ],
      ),
    );
  }

  SpeedDialChild _buildSpeedDialChild(IconData icon, String label) {
    return SpeedDialChild(
      child: Icon(icon),
      label: label,
      onTap: () => _showFormDialog(context, label),
    );
  }

  void _showFormDialog(BuildContext context, String category) {
    // Restablecer controladores y selecciones al abrir el formulario
    _resetForm();

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 8,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth:
                600, // Ancho máximo fijo para evitar que se estire demasiado
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header estilo Classroom
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      Icon(
                        _getCategoryIcon(category),
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Nuevo $category",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 22),
                        splashRadius: 20,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),

                // Contenido con scroll
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Campo Nombre
                          _buildFormFieldLabel("Nombre del Insumo"),
                          DropdownButtonFormField<int>(
                            decoration:
                                _getInputDecoration('Selecciona un insumo'),
                            value: _selectedCategoryId,
                            items: _categories.map((category) {
                              return DropdownMenuItem<int>(
                                value: category.id,
                                child: Text(category.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategoryId = value;
                                _selectedCategoryName = _categories
                                    .firstWhere((cat) => cat.id == value)
                                    .name;
                              });
                            },
                            validator: (value) => value == null
                                ? 'Por favor, selecciona un insumo'
                                : null,
                          ),
                          const SizedBox(height: 24.0),
                          if (category == 'Frutas')
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFormFieldLabel("Peso"),
                                TextFormField(
                                  controller: _weightController,
                                  decoration:
                                      _getInputDecoration('Ingresa el peso'),
                                  keyboardType: const TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d*$'))
                                  ],
                                  validator: (value) => value!.isEmpty
                                      ? 'Por favor, ingresa el peso'
                                      : null,
                                ),
                                const SizedBox(height: 24.0),
                              ],
                            ),

                          if (category != 'Frutas' && category != 'Otros')
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFormFieldLabel("Tamaño"),
                                TextFormField(
                                  controller: _sizeController,
                                  decoration:
                                      _getInputDecoration('Ingresa el tamaño'),
                                  keyboardType: const TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d*$'))
                                  ],
                                  validator: (value) => value!.isEmpty
                                      ? 'Por favor, ingresa el tamaño'
                                      : null,
                                ),
                                const SizedBox(height: 24.0),
                              ],
                            ),

                          // Campo Medida
                          _buildFormFieldLabel("Unidad de Medida"),
                          DropdownButtonFormField<int>(
                            decoration:
                                _getInputDecoration('Selecciona una medida'),
                            value: _selectedMeasureId,
                            items: _measures.map((measure) {
                              return DropdownMenuItem<int>(
                                value: measure.id,
                                child: Text(measure.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedMeasureId = value;
                                _selectedMeasureName = _measures
                                    .firstWhere((mea) => mea.id == value)
                                    .name;
                              });
                            },
                            validator: (value) => value == null
                                ? 'Por favor, selecciona una medida'
                                : null,
                          ),
                          const SizedBox(height: 24.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Campo Cantidad
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFormFieldLabel("Cantidad"),
                                    TextFormField(
                                      controller: _stockController,
                                      decoration:
                                          _getInputDecoration('Cantidad'),
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d*$'))
                                      ],
                                      validator: (value) => value!.isEmpty
                                          ? 'Ingresa la cantidad'
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Campo Precio Unitario
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFormFieldLabel("Precio Unitario"),
                                    TextFormField(
                                      controller: _unit_costController,
                                      decoration: _getInputDecoration(
                                          'Precio por unidad'),
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d*$'))
                                      ],
                                      validator: (value) => value!.isEmpty
                                          ? 'Ingresa el precio'
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Footer con separador
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
                          textStyle: const TextStyle(fontWeight: FontWeight.w500),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        child: const Text("Cancelar"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _saveForm();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontWeight: FontWeight.w500),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 8),
                            Text("Guardar"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Función para restablecer el formulario
  void _resetForm() {
    _weightController.clear();
    _sizeController.clear();
    _stockController.clear();
    _unit_costController.clear();
    _selectedCategoryId = null;
    _selectedMeasureId = null;
    _selectedCategoryName = '';
    _selectedMeasureName = '';
  }

// Función helper para elegir el icono según la categoría
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'frutas':
        return Icons.shopping_basket; // Cambiado de Icons.apple que no existe
      case 'verduras':
        return Icons.eco;
      case 'carnes':
        return Icons.restaurant;
      case 'lácteos':
        return Icons.egg_alt; // Cambiado de Icons.egg que podría no existir
      case 'bebidas':
        return Icons.local_cafe;
      default:
        return Icons.inventory_2; // Icono alternativo que existe en Flutter
    }
  }

// Helper para construir etiquetas de campo
  Widget _buildFormFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

// Helper para crear decoración consistente para inputs
  InputDecoration _getInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.red.shade300),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.red.shade400, width: 2),
      ),
    );
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        String name = _selectedCategoryName!;
        int stock = int.parse(_stockController.text);
        double unitCost = double.parse(_unit_costController.text);
        double weight = _weightController.text.isNotEmpty
            ? double.parse(_weightController.text)
            : 0.0;
        double size = _sizeController.text.isNotEmpty
            ? double.parse(_sizeController.text)
            : 0.0;
        int idMeasure = _selectedMeasureId!;
        int idCategory = _selectedCategoryId!;

        final newSupply = BuysDetailModel(
            id: null,
            description: name,
            stock: stock,
            weight: weight,
            size: size,
            unit_cost: unitCost,
            id_measure: idMeasure,
            id_buys: null,
            id_category_sup: idCategory);

        setState(() {
          arrayToPush.add(newSupply);
          _calcularYGuardarTotal();

          _nameController.clear();
          _stockController.clear();
          _weightController.clear();
          _sizeController.clear();
          _unit_costController.clear();
          _idMeasureController.clear();

          _selectedMeasureId = null;
          _selectedCategoryId = null;
        });

        Navigator.pop(context);
        _mostrarBanner(context);
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Error al guardar. Revisa los valores ingresados.')),
        );
      }
    }
  }

  void _showConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este insumo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el modal sin hacer nada
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _removeItem(index); // Eliminar el item
                Navigator.of(context).pop(); // Cerrar el modal
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
