import 'package:api_control_flow/db/database_helper.dart';
import 'package:api_control_flow/db/models/bussines/supply/supply_model.dart';
import 'package:api_control_flow/db/repository/supply_repository.dart';
import 'package:flutter/material.dart';
import './insumo_form.dart'; // Importa el formulario

class InsumoScreen extends StatefulWidget {
  const InsumoScreen({super.key});

  @override
  State<InsumoScreen> createState() => _InsumoScreenState();
}

class _InsumoScreenState extends State<InsumoScreen> {
  final TextEditingController _searchController = TextEditingController();
  final dbHelper = DatabaseHelper();
  late SupplyRepository _supplyRepository;

  List<SupplyModel> _supplies = [];
  List<SupplyModel> _filteredSupplies = [];

  @override
  void initState() {
    super.initState();
    _initDatabaseAndLoadSupplies();
    _searchController.addListener(_filterSupplies); // Escuchar cambios
  }

    @override
  void dispose() {
    _searchController.removeListener(_filterSupplies); // Importante: remover el listener
    _searchController.dispose();
    super.dispose();
  }


  Future<void> _initDatabaseAndLoadSupplies() async {
    final db = await dbHelper.database;
    _supplyRepository = SupplyRepository(db: db);
    await _loadSupplies();
  }

  Future<void> _loadSupplies() async {
    final insumos = await _supplyRepository.obtenerInsumos();
    setState(() {
      _supplies = insumos;
      _filteredSupplies = List.from(insumos);
    });
  }

  void _filterSupplies() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSupplies = _supplies
        .where((h) => h.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _eliminarInsumo(BuildContext context, SupplyModel cliente) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Eliminación"),
          content:
              const Text("¿Está seguro de que desea eliminar este insumo?"),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(false), // Cerrar el diálogo
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await _supplyRepository
                    .eliminarInsumo(cliente.id!); // Eliminar el proveedor
                Navigator.of(context).pop(true); // Cerrar el diálogo
                _loadSupplies(); // Recargar la lista
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
                    _loadSupplies();
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
              child: _filteredSupplies.isEmpty
                  ? const Center(child: Text('No se encontraron insumos'))
                  : ListView.builder(
                      itemCount: _filteredSupplies.length,
                      itemBuilder: (context, index) {
                        final insumo = _filteredSupplies[index];
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
                                Text('Precio compra: ${insumo.unit_cost.toString()}'),
                                Text('Cantidad: ${insumo.stock.toString()}'),
                                Text('Peso unidad: ${insumo.weight} ${insumo.id_measure}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => ()
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      _eliminarInsumo(context, insumo),
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
