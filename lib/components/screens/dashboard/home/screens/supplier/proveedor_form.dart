import 'package:api_control_flow/db/database_helper.dart';
import 'package:api_control_flow/db/models/users/supplier/supplier_model.dart';
import 'package:api_control_flow/db/repository/supplier_repository.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class ProveedorFormScreen extends StatefulWidget {
  const ProveedorFormScreen({super.key});

  @override
  State<ProveedorFormScreen> createState() => _ProveedorFormScreenState();
}

class _ProveedorFormScreenState extends State<ProveedorFormScreen> {
  final dbHelper = DatabaseHelper();
  late SupplierRepository _supplierRepository;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  OverlayEntry? _bannerEntry;

  @override
  void initState() {
    super.initState();
    _initDatabaseAndRepository(); // Inicializa la base de datos y el repositorio
  }

  Future<void> _initDatabaseAndRepository() async {
    final db =
        await dbHelper.database; // Obtén la instancia de la base de datos
    _supplierRepository =
        SupplierRepository(db: db); // Inicializa el repositorio
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
                    final nuevoProveedor = SupplierModel(
                      id: null, // Asegúrate de que tu modelo maneje IDs nulos
                      name: _nameController.text,
                      phone: _phoneController.text,
                      email: _emailController.text,
                      address: _addressController.text,
                    );

                    await _supplierRepository.insertarProveedor(nuevoProveedor);

                    _nameController.clear();
                    _phoneController.clear();
                    _emailController.clear();
                    _addressController.clear();

                    _mostrarBanner(context);
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
