import 'package:api_control_flow/db/database_helper.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
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
    _loadSupplies();
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
          child: 
              ListView.builder(
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
