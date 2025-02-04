import 'package:api_control_flow/db/database_helper.dart';
import 'package:api_control_flow/domain/entities/bussines/category/category_model.dart';
import 'package:api_control_flow/domain/entities/bussines/measure/measure_model.dart';
import 'package:api_control_flow/domain/entities/bussines/supply/supply_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/category_repository.dart';
import 'package:api_control_flow/domain/repositories/bussines/measure_repository.dart';
import 'package:api_control_flow/domain/repositories/bussines/supply_repository.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/category_api_data_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/measure_api_data_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/supply_api_date_source.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class InsumoFormScreen extends StatefulWidget {
  const InsumoFormScreen({super.key});

  @override
  State<InsumoFormScreen> createState() => _InsumoFormScreenState();
}

class _InsumoFormScreenState extends State<InsumoFormScreen> {
  final dbHelper = DatabaseHelper();
  late SupplyRepository _supplyRepository;
  late CategoryRepository _categoryApiDataSource;
  late MeasureRepository _measureRepository;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _unit_priceController = TextEditingController();
  final _unit_costController = TextEditingController();
  final _stockController = TextEditingController();
  final _weightController = TextEditingController();
  final _id_measureController = TextEditingController();
  final _id_categoryController = TextEditingController();

  int? _selectedMeasureId;
  int? _selectedCategoryId;

  OverlayEntry? _bannerEntry;

  List<CategoryModel> _categories = [];
  List<MeasureModel> _measures = [];

  @override
  void initState() {
    super.initState();
    _initDatabaseAndRepository(); // Inicializa la base de datos y el repositorio
  }

  Future<void> _loadMeasures() async {
    final medidas = await _measureRepository.getMeasures();
    setState(() {
      _measures = medidas;
    });
  }

  Future<void> _loadCategories() async {
    final categorias = await _categoryApiDataSource.getCategories();
    setState(() {
      _categories = categorias;
    });
  }


  Future<void> _initDatabaseAndRepository() async {
    final db =
        await dbHelper.database; // Obtén la instancia de la base de datos
    _supplyRepository = SupplyApiDateSource(db: db); // Inicializa el repositorio
    _categoryApiDataSource = CategoryApiDataSource(db: db);
    _measureRepository = MeasureApiDataSource(db: db);
    await _loadCategories();
    await _loadMeasures();
  }

  void _mostrarBanner(BuildContext context) {
    if (_bannerEntry != null) {
      _bannerEntry!.remove();
      _bannerEntry = null;
    }

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
            message: 'Proveedor creado',
            contentType: ContentType.success,
            inMaterialBanner: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _bannerEntry!.remove();
                _bannerEntry = null;
              },
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_bannerEntry!);

    Future.delayed(const Duration(seconds: 2), () {
      if (_bannerEntry != null) {
        _bannerEntry!.remove();
        _bannerEntry = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Insumo')),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
          // Envuelve los widgets en un Form
          key: _formKey, // Asigna la clave del formulario
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el nombre';
                  }
                  return null;
                },
                autofocus: true,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      decoration: InputDecoration(
                        labelText: 'Cantidad',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red)), // Estilo para el error
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa la cantidad';
                        }

                        if (int.tryParse(value) == null) {
                          return 'Precio inválido. Debe ser un número entero.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Medida',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    value: _selectedMeasureId,
                    items: _measures.map((measure) => DropdownMenuItem<int>(
                      value: measure.id,
                      child: Text(measure.name),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMeasureId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, ingresa la medida';
                      }
                      return null;
                    },
                  ))
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'Peso',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el precio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _unit_costController,
                decoration: InputDecoration(
                  labelText: 'Precio unidad',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el precio';
                  }
                  return null;
                },
              ),
              const Padding(padding: EdgeInsets.all(16.0)),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      int stock = int.parse(_stockController.text);
                      double unitCost =
                          double.parse(_unit_costController.text);
                      double weight = double.parse(_unit_costController.text);
                      int idMeasure = int.parse(_id_measureController.text);
                      int idCategory = int.parse(_id_measureController.text);

                      final nuevoCliente = SupplyModel(
                        id: null, // Asegúrate de que tu modelo maneje IDs nulos
                        name: _nameController.text,
                        stock: stock,
                        weight: weight,
                        unit_cost: unitCost,
                        id_measure: idMeasure,
                      );
                      await _supplyRepository.insertSupply(nuevoCliente);

                      _nameController.clear();
                      _stockController.clear();
                      _unit_costController.clear();
                      _id_measureController.clear();
                      _id_categoryController.clear();

                      _mostrarBanner(context);
                    } catch (err) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Error al convertir los valores. Asegúrate de que sean números válidos.')),
                      );
                      print('Error de conversión: $err');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 60, vertical: 18), // Padding interno
                  textStyle: const TextStyle(fontSize: 16), // Tamaño de texto
                  elevation: 5,
                ),
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
