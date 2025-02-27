import 'package:api_control_flow/db/database_helper.dart';
import 'package:api_control_flow/domain/entities/bussines/category_sup/category_sup_model.dart';
import 'package:api_control_flow/domain/repositories/bussines/category_sup_repository.dart';
import 'package:api_control_flow/infraestructure/data_sources/bussines/category_sup_api_data_source.dart';
import 'package:flutter/material.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final dbHelper = DatabaseHelper.instance;
  late CategorySupRepository _categorySupRepository;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initDatabaseAndRepository();
  }

  _initDatabaseAndRepository() async {
    final db = await dbHelper.database;
    _categorySupRepository = CategorySupApiDataSource(db: db);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Insumo')),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
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
                      }),
                  const Padding(padding: EdgeInsets.all(16.0)),
                  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final nuevaCategoria =
                                CategorySupModel(id: null, name: _nameController.text);
                            await _categorySupRepository
                                .insertCategorySup(nuevaCategoria);

                            _nameController.clear();
                          } catch (err) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Error al convertir los valores. Asegúrate de que sean números válidos.')));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 18),
                        textStyle: const TextStyle(fontSize: 16),
                        elevation: 5,
                      ),
                      child: const Text('Guardar'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
