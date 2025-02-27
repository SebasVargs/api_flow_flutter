import 'package:api_control_flow/db/database_helper.dart';
import 'package:api_control_flow/domain/entities/bussines/city/city_model.dart';
import 'package:api_control_flow/domain/entities/bussines/department/department_model.dart';
import 'package:api_control_flow/domain/entities/bussines/documentType/document_type_model.dart';
import 'package:api_control_flow/domain/entities/users/supplier/supplier_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/city_repository.dart';
import 'package:api_control_flow/domain/repositories/bussines/department_repository.dart';
import 'package:api_control_flow/domain/repositories/bussines/document_type_repository.dart';
import 'package:api_control_flow/domain/repositories/users/supplier_repository.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/city_api_data_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/department_api_data_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/document_type_api_data_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/users/supplier_api_data_source.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class ProveedorFormScreen extends StatefulWidget {
  const ProveedorFormScreen({super.key});

  @override
  State<ProveedorFormScreen> createState() => _ProveedorFormScreenState();
}

class _ProveedorFormScreenState extends State<ProveedorFormScreen> {
  final dbHelper = DatabaseHelper.instance;
  late SupplierRepository _supplierRepository;
  late CityRepository _cityRepository;
  late DepartmentRepository _departmentRepository;
  late DocumentTypeRepository _documentTypeRepository;

  int? _selectedCityId;
  int? _selectedDepartmentId;
  int? _selectedDocumentTypeId;

  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _documentNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  List<CityModel> _cities = [];
  List<DepartmentModel> _departments = [];
  List<DocumentTypeModel> _document_type = [];

  OverlayEntry? _bannerEntry;

  @override
  void initState() {
    super.initState();
    _initDatabaseAndRepository(); // Inicializa la base de datos y el repositorio
  }

  Future<void> _initDatabaseAndRepository() async {
    final db =
        await dbHelper.database; // Obtén la instancia de la base de datos
    _supplierRepository = SupplierApiDataSource(db: db);
    _cityRepository = CityApiDataSource(db: db);
    _departmentRepository = DepartmentApiDataSource(db: db);
    _documentTypeRepository = DocumentTypeApiDataSource(db: db);
    await _loadCities();
    await _loadDeparments();
    await _loadDocumentType();
  }

  Future<void> _loadDocumentType() async {
    final tDocument = await _documentTypeRepository.getDocumentsType();
    setState(() => _document_type = tDocument);
  }

  Future<void> _loadCities() async {
    final ciudades = await _cityRepository.getCities();
    setState(() => _cities = ciudades);
  }

  Future<void> _loadDeparments() async {
    final departamentos = await _departmentRepository.getDepartments();
    setState(() => _departments = departamentos);
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
      appBar: AppBar(title: const Text('Crear Proveedor')),
      body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: SingleChildScrollView(
              child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Form(
                // Envuelve los widgets en un Form
                key: _formKey, // Asigna la clave del formulario
                child: Column(
                  children: [
                    TextFormField(
                      controller: _companyNameController,
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
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: 'Tipo de documento',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      value: _selectedDocumentTypeId,
                      items: _document_type.map((docT) {
                        return DropdownMenuItem<int>(
                          value: docT.id,
                          child: Text(docT.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _selectedDocumentTypeId = value;
                      },
                      validator: (value) => value == null
                          ? 'Por favor, selecciona un proveedor'
                          : null,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _documentNumberController,
                      decoration: InputDecoration(
                        labelText: 'Numero de documento',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa el nombre';
                        }
                        return null;
                      },
                      autofocus: true,
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: 'Departamento',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      value: _selectedDepartmentId,
                      items: _departments.map((department) {
                        return DropdownMenuItem<int>(
                          value: department.id,
                          child: Text(department.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _selectedDepartmentId = value;
                      },
                      validator: (value) => value == null
                          ? 'Por favor, selecciona un proveedor'
                          : null,
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: 'Ciudad',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      value: _selectedCityId,
                      items: _cities.map((city) {
                        return DropdownMenuItem<int>(
                          value: city.id,
                          child: Text(city.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _selectedCityId = value;
                      },
                      validator: (value) => value == null
                          ? 'Por favor, selecciona un proveedor'
                          : null,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Teléfono',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red)), // Estilo para el error
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa el teléfono';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa el email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Dirección',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa la dirección';
                        }
                        return null;
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(16.0)),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final newSupplier = SupplierModel(
                                id: null,
                                company_name: _companyNameController.text,
                                document_number: _documentNumberController.text,
                                phone: _phoneController.text,
                                email: _emailController.text,
                                address: _addressController.text,
                                id_document_type: _selectedDocumentTypeId!,
                                id_city: _selectedCityId!,
                                id_department: _selectedDepartmentId!);

                            await _supplierRepository
                                .insertSupplier(newSupplier);

                            _companyNameController.clear();
                            _documentNumberController.clear();
                            _phoneController.clear();
                            _emailController.clear();
                            _addressController.clear();

                            setState(() {
                              _selectedDocumentTypeId = null;
                              _selectedCityId = null;
                              _selectedDepartmentId = null;
                            });

                            _mostrarBanner(context);
                          } catch (err) {
                            print('Error al guardar el proveedor: $err');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Error al guardar el proveedor: $err')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 18), // Padding interno
                        textStyle:
                            const TextStyle(fontSize: 16), // Tamaño de texto
                        elevation: 5,
                      ),
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
              ),
            ),
      ))),
    );
  }
}
