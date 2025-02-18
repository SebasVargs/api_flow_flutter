import 'package:api_control_flow/db/database_helper.dart';
import 'package:api_control_flow/domain/entities/bussines/category_sup/category_sup_model.dart';
import 'package:api_control_flow/domain/entities/bussines/measure/measure_model.dart';
import 'package:api_control_flow/domain/entities/bussines/supply/supply_model.dart';
import 'package:api_control_flow/domain/entities/users/supplier/supplier_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/category_sup_repository.dart';
import 'package:api_control_flow/domain/repositories/bussines/measure_repository.dart';
import 'package:api_control_flow/domain/repositories/bussines/supply_repository.dart';
import 'package:api_control_flow/domain/repositories/users/supplier_repository.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/category_sup_api_data_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/measure_api_data_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/supply_api_date_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/users/supplier_api_data_source.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

class InsumoFormScreen extends StatefulWidget {
  const InsumoFormScreen({super.key});

  @override
  State<InsumoFormScreen> createState() => _InsumoFormScreenState();
}

class _InsumoFormScreenState extends State<InsumoFormScreen> {
  final dbHelper = DatabaseHelper();
  late SupplyRepository _supplyRepository;
  late MeasureRepository _measureRepository;
  late CategorySupRepository _categorySupRepository;
  late SupplierRepository _supplierRepository;

  DateTime? _selectedDateTime;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _stockController = TextEditingController();
  final _weightController = TextEditingController();
  final _sizeController = TextEditingController();
  final _unit_costController = TextEditingController();
  final _idMeasureController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  double _total = 0.0;
  String? _selectedCategoryName;
  String? _selectedMeasureName;
  int? _selectedSupplierId;
  String _selectedCategory = 'Frutas';
  int? _selectedCategoryId;
  int? _selectedMeasureId;
  OverlayEntry? _bannerEntry;
  List<BuysDetailModel> _arrayToPush = [];
  List<MeasureModel> _measures = [];
  List<CategorySupModel> _categories = [];
  List<SupplierModel> _suppliers = [];

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
    await _loadSuppliers();
    await _loadCategories();
    await _loadMeasures();
  }

  mostrarArray() {
    print(_arrayToPush);
  }

  void _removeItem(int index) {
    setState(() {
      _arrayToPush.removeAt(index);
      _calcularYGuardarTotal();
    });
  }

  double _calcularTotal() {
    return _arrayToPush.fold(
        0, (total, item) => total + (item.stock * item.unit_cost));
  }

  void _calcularYGuardarTotal(){
    setState(() {
      _total = _calcularTotal();
    });
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
          backgroundColor: Colors.white.withOpacity(0.8),
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
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                    labelText: 'Fecha y Hora',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDateTime(context),
                    )),
                controller: TextEditingController(
                  text: _selectedDateTime != null
                      ? DateFormat('dd/MM/yyyy HH:mm')
                          .format(_selectedDateTime!)
                      : '',
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Proveedor',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                value: _selectedSupplierId,
                items: _suppliers.map((supplier) {
                  return DropdownMenuItem<int>(
                    value: supplier.id,
                    child: Text(supplier.company_name),
                  );
                }).toList(),
                onChanged: (value) {
                  _selectedSupplierId = value;
                },
                validator: (value) =>
                    value == null ? 'Por favor, selecciona un proveedor' : null,
              ),
              const SizedBox(height: 10.0),
              Expanded(
                  child: _arrayToPush.isEmpty
                      ? const Center(
                          child: Text('No hay insumos agregados'),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 14.0),
                          child: ListView.builder(
                            itemCount: _arrayToPush.length,
                            itemBuilder: (context, index) {
                              final toPush = _arrayToPush[index];

                              // Crear una lista dinámica con los valores no nulos
                              List<Widget> details = [];

                              if (toPush.stock != null) {
                                details.add(Text(
                                    'Cantidad: ${toPush.stock.toStringAsFixed(0)}'));
                              }
                              if (toPush.weight != null && toPush.weight != 0) {
                                details.add(Text(
                                    'Peso: ${toPush.weight?.toStringAsFixed(0)} $_selectedMeasureName'));
                              }
                              if (toPush.size != null && toPush.size != 0) {
                                details.add(Text(
                                    'Tamaño: \$${toPush.size?.toStringAsFixed(0)} $_selectedCategoryName'));
                              }

                              if (toPush.weight == null &&
                                  toPush.size == null) {
                                details.add(const Text(''));
                              }

                              if (toPush.unit_cost != null) {
                                details.add(
                                  Text(
                                      'Precio unitario: \$${toPush.unit_cost.toStringAsFixed(0)}'),
                                );
                              }
                              return Card(
                                  color: Colors.white,
                                  elevation: 3,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent,
                                    ),
                                    child: ExpansionTile(
                                      tilePadding: const EdgeInsets.only(
                                          right: 20.0, left: 8.0),
                                      childrenPadding:
                                          const EdgeInsets.fromLTRB(
                                              16.0, 8.0, 16.0, 16.0),
                                      title: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                                Icons.dangerous_outlined,
                                                color: Color.fromARGB(
                                                    255, 198, 131, 131)),
                                            onPressed: () {
                                              _showConfirmationDialog(
                                                  context, index);                                            },
                                          ),
                                          Expanded(
                                            child: Text(
                                              toPush.description,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      children: details.isNotEmpty
                                          ? [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: details,
                                                ),
                                              ),
                                            ]
                                          : [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                    'No hay información adicional disponible'),
                                              )
                                            ],
                                    ),
                                  ));
                            },
                          ),
                        )),
              Center(
                child: _arrayToPush.isNotEmpty
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
                            onPressed: () {
                              if (_arrayToPush.isNotEmpty) {
                                print("Comprar presionado");
                                _arrayToPush.forEach((toPush) {
                                  print('Descripción: ${toPush.description}');
                                  print('Peso: ${toPush.weight}');
                                  print('Cantidad: ${toPush.stock}');
                                  print(
                                      'Precio unitario: \$${toPush.unit_cost.toStringAsFixed(0)}');
                                  print('Factura: ${toPush.id_buys}');
                                  print('Categoría: ${toPush.id_category}');
                                  print('Medida: ${toPush.id_measure}');
                                  print('---');
                                });
                              } else {
                                print('No hay productos en el carrito.');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              textStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                            ),
                            child: Text("Comprar"),
                          ),
                        ],
                      )
                    : SizedBox(), // Si el array está vacío, no muestra nada
              ),
            ])),
        floatingActionButton: _buildSpeedDial());
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
        backgroundColor: Colors.blue[50],
        overlayOpacity: 0.4,
        spaceBetweenChildren: 10,
        buttonSize: const Size(65, 65),
        childrenButtonSize: const Size(60, 60),
        spacing: 5,
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // Establecemos el color de fondo blanco
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: Text(
                category,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: _buildForm(category),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(String category) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10.0),
          DropdownButtonFormField<int>(
            decoration: InputDecoration(
              labelText: 'Nombre',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            value: _selectedCategoryId,
            items: _categories.map((category) {
              return DropdownMenuItem<int>(
                value: category.id,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (value) {
              _selectedCategoryId = value;
              _selectedCategoryName =
                  _categories.firstWhere((cat) => cat.id == value).name;
            },
            validator: (value) =>
                value == null ? 'Por favor, selecciona un insumo' : null,
          ),
          const SizedBox(height: 16.0),
          if (category == 'Frutas')
            TextFormField(
              controller: _weightController,
              decoration: InputDecoration(
                labelText: 'Peso',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value!.isEmpty ? 'Por favor, ingresa el peso' : null,
            ),
          if (category != 'Frutas' && category != 'Otros')
            TextFormField(
              controller: _sizeController,
              decoration: InputDecoration(
                labelText: 'Tamaño',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value!.isEmpty ? 'Por favor, ingresa el tamaño' : null,
            ),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<int>(
            decoration: InputDecoration(
              labelText: 'Medida',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            value: _selectedMeasureId,
            items: _measures.map((measure) {
              return DropdownMenuItem<int>(
                value: measure.id,
                child: Text(measure.name),
              );
            }).toList(),
            onChanged: (value) {
              _selectedMeasureId = value;
              _selectedMeasureName =
                  _measures.firstWhere((mea) => mea.id == value).name;
            },
            validator: (value) =>
                value == null ? 'Por favor, selecciona una medida' : null,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _stockController,
            decoration: InputDecoration(
              labelText: 'Cantidad',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            keyboardType: TextInputType.number,
            validator: (value) =>
                value!.isEmpty ? 'Por favor, ingresa la cantidad' : null,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _unit_costController,
            decoration: InputDecoration(
              labelText: 'Precio Unitario',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            keyboardType: TextInputType.number,
            validator: (value) =>
                value!.isEmpty ? 'Por favor, ingresa el precio' : null,
          ),
          const SizedBox(height: 30.0),
          ElevatedButton(
            onPressed: _saveForm,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18),
              textStyle: const TextStyle(fontSize: 16),
              elevation: 5,
            ),
            child: const Text('Agregar'),
          ),
        ],
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
            id_category: idCategory);

        setState(() {
          _arrayToPush.add(newSupply);
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

        for (var supply in _arrayToPush) {
          print(
              "Nombre: ${supply.description}, Stock: ${supply.stock}, Precio: ${supply.unit_cost}, Name: ${supply.id_measure}");
        }

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
