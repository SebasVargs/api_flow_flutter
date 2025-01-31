import 'package:api_control_flow/db/database_helper.dart';
import 'package:api_control_flow/db/models/bussines/product/product_model.dart';
import 'package:api_control_flow/db/repository/product_repository.dart';
import 'package:flutter/material.dart';
import './producto_form.dart';

class ProductoScreen extends StatefulWidget {
  const ProductoScreen({super.key});

  @override
  State<ProductoScreen> createState() => _ProductoScreenState();
}

class _ProductoScreenState extends State<ProductoScreen> {
  final TextEditingController _searchController = TextEditingController();
  final dbHelper = DatabaseHelper();
  late ProductRepository _productRepository;

  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _initDatabaseAndLoadRepositories();
    _searchController.addListener(_filterProducts); // Escuchar cambios
  }

    @override
  void dispose() {
    _searchController.removeListener(_filterProducts); // Importante: remover el listener
    _searchController.dispose();
    super.dispose();
  }


  Future<void> _initDatabaseAndLoadRepositories() async {
    final db = await dbHelper.database;
    _productRepository = ProductRepository(db: db);
    await _loadProducts();
  }

  Future<void> _loadProducts() async {
    final productos = await _productRepository.obtenerProductos();
    setState(() {
      _products = productos;
      _filteredProducts = List.from(productos);
    });
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _products
        .where((h) => h.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _eliminarProducto(BuildContext context, ProductModel product) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Eliminación"),
          content:
              const Text("¿Está seguro de que desea eliminar este producto?"),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(false), // Cerrar el diálogo
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await _productRepository
                    .eliminarProducto(product.id!); // Eliminar el proveedor
                Navigator.of(context).pop(true); // Cerrar el diálogo
                _loadProducts(); // Recargar la lista
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
      appBar: AppBar(title: const Text('Insumos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column( // El Column va *dentro* del body del Scaffold
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InsumoFormScreen(),
                  ),
                ).then((value) {
                  if (value == true) {
                    _loadProducts();
                  }
                });
              },
              child: const Text('Agregar Insumo'),
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
              child: _filteredProducts.isEmpty
                  ? const Center(child: Text('No se encontraron insumos'))
                  : ListView.builder(
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final insumo = _filteredProducts[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              insumo.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(insumo.unit_cost.toString()),
                                Text(insumo.stock.toString()),
                                Text(insumo.id_measure.toString()),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => (context, insumo),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      _eliminarProducto(context, insumo),
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
