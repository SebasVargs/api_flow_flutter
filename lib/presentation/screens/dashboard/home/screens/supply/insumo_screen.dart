import 'package:api_control_flow/db/database_helper.dart';
import 'package:api_control_flow/domain/entities/bussines/category_sup/category_sup_model.dart';
import 'package:api_control_flow/domain/entities/bussines/supply/supply_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/category_sup_repository.dart';
import 'package:api_control_flow/domain/repositories/bussines/supply_repository.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/category_sup_api_data_source.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/supply_api_date_source.dart';
import 'package:api_control_flow/presentation/screens/dashboard/home/components/supply/icon_buy.dart';
import 'package:api_control_flow/presentation/screens/dashboard/home/screens/supply/form/add_category_screen.dart';
import 'package:flutter/material.dart';
import 'form/add_buy_screen.dart'; // Importa el formulario

class InsumoScreen extends StatefulWidget {
  const InsumoScreen({super.key});

  @override
  State<InsumoScreen> createState() => _InsumoScreenState();
}

class _InsumoScreenState extends State<InsumoScreen> {
  final TextEditingController _searchController = TextEditingController();
  final dbHelper = DatabaseHelper();
  late SupplyRepository _supplyRepository;
  late CategorySupRepository _categorySupRepository;

  List<BuysDetailModel> _supplies = [];
  List<CategorySupModel> _categoriesSup = [];
  List<CategorySupModel> _filteredCategoriesSup = [];

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
    await _loadSupplies();
    await _loadCategories();
  }

  Future<void> _loadSupplies() async {
    final insumos = await _supplyRepository.getSupplies();
    setState(() {
      _supplies = insumos;
      _filteredCategoriesSup = List.from(insumos);
    });
  }

  Future<void> _loadCategories() async {
    final categorias = await _categorySupRepository.getCategoriesSup();
    print('Somos las categorias $categorias');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // El Scaffold es el widget raíz
        appBar: AppBar(title: const Text('Insumos')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // El Column va *dentro* del body del Scaffold
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddCategoryScreen(),
                    ),
                  ).then((value) {
                    if (value == true) {
                      _loadCategories();
                    }
                  });
                },
                child: const Text('Agregar Insumo'),
              ),
              const SizedBox(height: 20),
              Padding(
                // Widget de búsqueda (va dentro del Column)
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
              Expanded(
                // El Expanded también va dentro del Column
                child: _filteredCategoriesSup.isEmpty
                    ? const Center(child: Text('No se encontraron insumos'))
                    : ListView.builder(
                        itemCount: _filteredCategoriesSup.length,
                        itemBuilder: (context, index) {
                          final category = _filteredCategoriesSup[index];
                          return Card(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 4,
                            child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: Text(
                                  category.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                subtitle: const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        spacing: 2.0,
                                        runSpacing: 3.0,
                                        children: [
                                          IconBuy(),
                                          IconBuy(),
                                          IconBuy(),
                                          IconBuy(),
                                          IconBuy(),
                                          IconBuy(),
                                          IconBuy(),
                                          IconBuy(),
                                          IconBuy(),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 5, right: 5),
            child: SizedBox(
              width: 125,
              height: 65,
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                onPressed: () {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InsumoFormScreen(),
                      ),
                    );
                  });
                },
                backgroundColor: Colors.blue[50],
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 30),
                    SizedBox(width: 8), // Espacio entre icono y texto
                    Text(
                      "Comprar",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )));
  }
}
