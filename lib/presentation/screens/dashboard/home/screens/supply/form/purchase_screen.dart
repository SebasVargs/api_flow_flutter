import 'package:flutter/material.dart';
import 'purchase_form.dart'; // Importa el formulario separado

class PurchaseScreen extends StatefulWidget {
  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  String _selectedCategory = 'Frutas';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Compra')),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _selectedCategory = 'Frutas'),
                    child: const Text("Frutas"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _selectedCategory = 'Empaques'),
                    child: const Text("Empaques"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _selectedCategory = 'Otros'),
                    child: const Text("Otros"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            PurchaseForm(selectedCategory: _selectedCategory),
          ],
        ),
      ),
    );
  }
}
