import 'package:api_control_flow/db/database_helper.dart';
import 'package:api_control_flow/db/models/bussines/supply/supply_model.dart';
import 'package:api_control_flow/models/schedule/hability_model.dart';
import 'package:api_control_flow/services/schedule/hability_service.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final HabilityService _habilityService = HabilityService();

  List<HabilityModel> _habilities = [];
  List<HabilityModel> _filteredHabilities = [];
  List<Map<String, dynamic>> _supplies = [];
  final dbHelper = DatabaseHelper();

  Future<void> _loadSupplies() async {
    try {
      final suppliesData = await dbHelper.obtenerTodosLosSupplies();
      setState(() {
        _supplies = suppliesData;
        print('Todos los supplies: $_supplies'); // Imprime los supplies
      });
    } catch (e) {
      print('Error al cargar los supplies: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadHabilities();
    _loadSupplies();
    _searchController.addListener(_filterHabilities);
  }

  void _loadHabilities() async {
    try {
      final habil = await _habilityService.fetchHabilities();
      setState(() {
        _habilities = habil;
        _filteredHabilities = habil;
      });
    } catch (e) {
      print('Error al cargar las habilidades $e');
    }
  }

  void _filterHabilities() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredHabilities = _habilities
          .where((h) => h.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
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
          child: _filteredHabilities.isEmpty
              ? const Center(child: Text('No se encontraron pedidos'))
              : ListView.builder(
                  itemCount: _filteredHabilities.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8), // Espaciado entre tarjetas
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12)), // Bordes redondeados
                      elevation: 4, // Sombra para resaltar
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          _filteredHabilities[index].name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('ID: ${_filteredHabilities[index].id}'),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
