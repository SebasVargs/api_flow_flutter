import 'package:api_control_flow/db/database_helper.dart';
import 'package:api_control_flow/domain/entities/bussines/documentType/document_type_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/document_type_repository.dart';
import 'package:api_control_flow/domain/repositories/users/supplier_repository.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/document_type_api_data_source.dart';
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
  final dbHelper = DatabaseHelper.instance;
  late SupplierRepository _supplierRepository;
  late DocumentTypeRepository _documentTypeRepository;

  List<SupplierModel> _suppliers = [];
  List<SupplierModel> _filteredSuppliers = [];
  List<DocumentTypeModel> _documentTypes = [];

  @override
  void initState() {
    super.initState();
    _initDatabaseAndLoadSuppliers();
    _searchController.addListener(_filterSuppliers); // Escuchar cambios
  }

  @override
  void dispose() {
    _searchController
        .removeListener(_filterSuppliers); // Importante: remover el listener
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initDatabaseAndLoadSuppliers() async {
    final db = await dbHelper.database;
    _supplierRepository = SupplierApiDataSource(db: db);
    _documentTypeRepository = DocumentTypeApiDataSource(db: db);
    await _loadSuppliers();
    await _loadDocumentType();
  }

  Future<void> _loadDocumentType() async {
    final type_documents = await _documentTypeRepository.getDocumentsType();
    setState(() {
      _documentTypes = type_documents;
    });
  }

  String _getDocumentTypeName(int? documentTypeId) {
    if (documentTypeId == null) return '';

    var nameDoc = '';

    try {
      final documentType =
          _documentTypes.firstWhere((dt) => dt.id == documentTypeId);
      if (documentType.name == 'Cédula de Ciudadanía') {
        nameDoc = 'C.C';
        return nameDoc;
      } else if (documentType.name == 'Tarjeta de Identidad') {
        nameDoc = 'T.I';
        return nameDoc;
      }
      return documentType.name;
    } catch (e) {
      return 'Tipo desconocido';
    }
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
          .where((h) => h.company_name.toLowerCase().contains(query))
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
    return Scaffold(
      appBar: AppBar(title: const Text('Proveedores')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // El Column va *dentro* del body del Scaffold
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
                  fillColor: Colors.grey.shade100,
                ),
              ),
            ),
            Expanded(
              // El Expanded también va dentro del Column
              child: _filteredSuppliers.isEmpty
                  ? const Center(child: Text('No se encontraron proveedores'))
                  : ListView.builder(
                      itemCount: _filteredSuppliers.length,
                      itemBuilder: (context, index) {
                        final proveedor = _filteredSuppliers[index];
                        final cardColors = [
                          Colors.blue.shade700,
                          Colors.green.shade700,
                          Colors.purple.shade700,
                          Colors.indigo.shade700,
                          Colors.teal.shade700,
                        ];
                        final headerColor =
                            cardColors[index % cardColors.length];

                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                                color: Colors.grey.shade300, width: 1),
                          ),
                          elevation: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: headerColor,
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
                                    Expanded(
                                      child: Text(
                                        proveedor.company_name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(height: 12),
                                        SizedBox(
                                          width: 38,
                                          height: 38,
                                          child: FloatingActionButton(
                                            heroTag: "accionesRapidasTag",
                                            mini: true,
                                            backgroundColor: Colors.white,
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              side: BorderSide(
                                                  color: Colors.blue.shade100,
                                                  width: 1),
                                            ),
                                            onPressed: () {
                                              // Acción rápida, por ejemplo mostrar un menú de opciones
                                              showModalBottomSheet(
                                                context: context,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              16)),
                                                ),
                                                builder: (context) => Container(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  height: 195,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                bottom: 16,
                                                                top: 5),
                                                        child: Text(
                                                          "Acciones rápidas",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      ListTile(
                                                        leading: Icon(
                                                            Icons.history,
                                                            color: Colors
                                                                .blue.shade700),
                                                        title: const Text(
                                                            "Actualizar Proveedor"),
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                      ListTile(
                                                        leading: Icon(
                                                            Icons.delete,
                                                            color: Colors
                                                                .blue.shade700),
                                                        title: const Text(
                                                            "Eliminar Proveedor"),
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                          _eliminarProveedor(
                                                              context,
                                                              proveedor);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Icon(Icons.more_vert,
                                                size: 24),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.badge,
                                        color: headerColor, size: 20),
                                        const SizedBox(width: 8),
                                        RichText(
                                          text: TextSpan(
                                            style: DefaultTextStyle.of(context).style,
                                            children: [
                                              TextSpan(
                                                text: '${_getDocumentTypeName(proveedor.id_document_type)}. ',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold)
                                              ),
                                              TextSpan(
                                                text: proveedor.document_number),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.phone,
                                            color: headerColor, size: 20),
                                        const SizedBox(width: 8),
                                        RichText(
                                          text: TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style,
                                            children: [
                                              const TextSpan(
                                                text: 'Teléfono: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(text: proveedor.phone),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.email,
                                            color: headerColor, size: 20),
                                        const SizedBox(width: 8),
                                        Text(proveedor.email),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on,
                                            color: headerColor, size: 20),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,
                                              children: [
                                                const TextSpan(
                                                  text: 'Dirección: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(text: proveedor.address),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
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
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
