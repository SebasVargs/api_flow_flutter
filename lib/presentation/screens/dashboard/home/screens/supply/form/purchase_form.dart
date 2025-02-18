import 'package:flutter/material.dart';

class PurchaseForm extends StatefulWidget {
  final String selectedCategory;

  const PurchaseForm({Key? key, required this.selectedCategory}) : super(key: key);

  @override
  _PurchaseFormState createState() => _PurchaseFormState();
}

class _PurchaseFormState extends State<PurchaseForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _unitCostController = TextEditingController();
  int? _selectedMeasureId;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Nombre',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            validator: (value) => value == null || value.isEmpty ? 'Por favor, ingresa el nombre' : null,
          ),
          const SizedBox(height: 16.0),
          if (widget.selectedCategory != 'Otros')
            TextFormField(
              controller: _weightController,
              decoration: InputDecoration(
                labelText: widget.selectedCategory == 'Frutas' ? 'Peso' : 'Tamaño',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value == null || value.isEmpty ? 'Por favor, ingresa el valor' : null,
            ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _stockController,
            decoration: InputDecoration(
              labelText: 'Cantidad',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            keyboardType: TextInputType.number,
            validator: (value) => value == null || value.isEmpty ? 'Por favor, ingresa la cantidad' : null,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _unitCostController,
            decoration: InputDecoration(
              labelText: 'Precio total',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            keyboardType: TextInputType.number,
            validator: (value) => value == null || value.isEmpty ? 'Por favor, ingresa el precio' : null,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                print("Guardando datos...");
                // Aquí puedes llamar a un servicio para guardar los datos
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
