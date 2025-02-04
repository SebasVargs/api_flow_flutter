import 'package:api_control_flow/db/database_helper.dart';
import 'package:api_control_flow/domain/repositories/users/supplier_repository.dart';
import 'package:api_control_flow/infraestructure/data_sources/users/supplier_api_data_source.dart';
import 'package:flutter/material.dart';
import 'package:api_control_flow/domain/entities/users/supplier/supplier_model.dart';
import 'proveedor_form.dart'; // Importa el formulario

class ProveedorScreen extends StatefulWidget {
  const ProveedorScreen({super.key});

  @override
  State<ProveedorScreen> createState() => _ProveedorScreenState();
}

class _ProveedorScreenState extends State<ProveedorScreen> {
  final TextEditingController _searchController = TextEditingController();
  final dbHelper = DatabaseHelper();
  late SupplierRepository _supplierRepository;

  List<SupplierModel> _suppliers = [];
  List<SupplierModel> _filteredSuppliers = [];

  @override
  void initState() {
    super.initState();
    _initDatabaseAndLoadSuppliers();
    _searchController.addListener(_filterSuppliers); // Escuchar cambios
  }

    @override
  void dispose() {
    _searchController.removeListener(_filterSuppliers); // Importante: remover el listener
    _searchController.dispose();
    super.dispose();
  }


  Future<void> _initDatabaseAndLoadSuppliers() async {
    final db = await dbHelper.database;
    _supplierRepository = SupplierApiDataSource(db: db);
    await _loadSuppliers();
  }

  Future<void> _loadSuppliers() async {
    final proveedores = await _supplierRepository.getSuppliers();
    setState(() {
      _suppliers = proveedores;
      _filteredSuppliers = List.from(proveedores);
    });
  }

  void _filterSuppliers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSuppliers = _suppliers
        .where((h) => h.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _eliminarProveedor(BuildContext context, SupplierModel proveedor) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Eliminación"),
          content:
              const Text("¿Está seguro de que desea eliminar este proveedor?"),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(false), // Cerrar el diálogo
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await _supplierRepository
                    .deleteSupplier(proveedor.id!); // Eliminar el proveedor
                Navigator.of(context).pop(true); // Cerrar el diálogo
                _loadSuppliers(); // Recargar la lista
              },
              child:
                  const Text("Eliminar", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

@override
  Widget build(BuildContext context) {
    return Scaffold( // El Scaffold es el widget raíz
      appBar: AppBar(title: const Text('Proveedores')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column( // El Column va *dentro* del body del Scaffold
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProveedorFormScreen(),
                  ),
                ).then((value) {
                  if (value == true) {
                    _loadSuppliers();
                  }
                });
              },
              child: const Text('Agregar Proveedor'),
            ),
            const SizedBox(height: 20),
            Padding( // Widget de búsqueda (va dentro del Column)
              padding: const EdgeInsets.only(bottom: 16),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Buscar...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded( // El Expanded también va dentro del Column
              child: _filteredSuppliers.isEmpty
                  ? const Center(child: Text('No se encontraron proveedores'))
                  : ListView.builder(
                      itemCount: _filteredSuppliers.length,
                      itemBuilder: (context, index) {
                        final proveedor = _filteredSuppliers[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              proveedor.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(proveedor.phone),
                                Text(proveedor.email),
                                Text(proveedor.address),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => (context, proveedor),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      _eliminarProveedor(context, proveedor),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
