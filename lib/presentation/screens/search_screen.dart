import 'package:api_control_flow/db/database_helper.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final dbHelper = DatabaseHelper.instance;
  List<dynamic> _orders = []; // Simulación de lista de pedidos

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    // Simulación de carga de pedidos (deberías reemplazar con la consulta a tu base de datos)
    setState(() {
      _orders = [
        {'name': 'Pedido 1', 'quantity': 10},
        {'name': 'Pedido 2', 'quantity': 5},
      ]; // Simula que no hay pedidos
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
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
              child: _orders.isEmpty
                  ? const Center(
                      child: Text(
                        "Agregar pedido",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _orders.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                          child: ListTile(
                            title: Text(_orders[index]['name']),
                            subtitle: Text('Cantidad: ${_orders[index]['quantity']}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed: () {
              setState(() {
                _orders.add({'name': 'Nuevo pedido', 'quantity': 1});
              });
            },
            backgroundColor: Colors.blueGrey,
            child: const Icon(Icons.add, size: 40),
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
