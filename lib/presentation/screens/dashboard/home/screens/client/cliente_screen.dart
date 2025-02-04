import 'package:api_control_flow/db/database_helper.dart';
import 'package:api_control_flow/domain/entities/users/client/client_model.dart';
import 'package:api_control_flow/domain/repositories/users/client_repository.dart';
import 'package:api_control_flow/infraestructure/data_sources/users/client_api_data_source.dart';
import 'package:flutter/material.dart';
import 'cliente_form.dart'; // Importa el formulario

class ClienteScreen extends StatefulWidget {
  const ClienteScreen({super.key});

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final TextEditingController _searchController = TextEditingController();
  final dbHelper = DatabaseHelper();
  late ClientRepository _clientRepository;

  List<ClientModel> _clients = [];
  List<ClientModel> _filteredClients = [];

  @override
  void initState() {
    super.initState();
    _initDatabaseAndLoadClients();
    _searchController.addListener(_filterClients); // Escuchar cambios
  }

    @override
  void dispose() {
    _searchController.removeListener(_filterClients); // Importante: remover el listener
    _searchController.dispose();
    super.dispose();
  }


  Future<void> _initDatabaseAndLoadClients() async {
    final db = await dbHelper.database;
    _clientRepository = ClientApiDataSource(db: db);
    await _loadClients();
  }

  Future<void> _loadClients() async {
    final proveedores = await _clientRepository.getClients();
    setState(() {
      _clients = proveedores;
      _filteredClients = List.from(proveedores);
    });
  }

  void _filterClients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredClients = _clients
        .where((h) => h.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _eliminarCliente(BuildContext context, ClientModel cliente) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Eliminación"),
          content:
              const Text("¿Está seguro de que desea eliminar este cliente?"),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(false), // Cerrar el diálogo
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await _clientRepository
                    .deleteClient(cliente.id!); // Eliminar el proveedor
                Navigator.of(context).pop(true); // Cerrar el diálogo
                _loadClients(); // Recargar la lista
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
      appBar: AppBar(title: const Text('Clientes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column( // El Column va *dentro* del body del Scaffold
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ClienteFormScreen(),
                  ),
                ).then((value) {
                  if (value == true) {
                    _loadClients();
                  }
                });
              },
              child: const Text('Agregar Cliente'),
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
              child: _filteredClients.isEmpty
                  ? const Center(child: Text('No se encontraron clientes'))
                  : ListView.builder(
                      itemCount: _filteredClients.length,
                      itemBuilder: (context, index) {
                        final cliente = _filteredClients[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              cliente.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cliente.phone),
                                Text(cliente.email),
                                Text(cliente.address),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => (context, cliente),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      _eliminarCliente(context, cliente),
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
