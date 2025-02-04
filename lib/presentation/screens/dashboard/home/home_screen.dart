import 'package:api_control_flow/presentation/screens/dashboard/home/screens/cash_flow/flujo_screen.dart';
import 'package:api_control_flow/presentation/screens/dashboard/home/screens/client/cliente_screen.dart';
import 'package:api_control_flow/presentation/screens/dashboard/home/screens/product/producto_screen.dart';
import 'package:api_control_flow/presentation/screens/dashboard/home/screens/supplier/proveedor_screen.dart';
import 'package:api_control_flow/presentation/screens/dashboard/home/screens/supply/insumo_screen.dart';
import 'package:flutter/material.dart';
import 'components/menu_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: MenuCard(
                title: 'Flujo de Caja',
                icon: Icons.monetization_on,
                color: Colors.lightGreenAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CashFlowScreen())
                  );
                },
              ),
            ),
            const SizedBox(height: 10), // Espacio entre elementos
            Row(
              children: [
                Expanded(
                  child: MenuCard(
                    title: 'Productos',
                    icon: Icons.inventory,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProductoScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10), // Espacio entre elementos
                Expanded(
                  child: MenuCard(
                    title: 'Proveedores',
                    icon: Icons.business,
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProveedorScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10), // Espacio entre elementos
            Row(
              children: [
                Expanded(
                  child: MenuCard(
                    title: 'Clientes',
                    icon: Icons.people,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ClienteScreen())
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10), // Espacio entre elementos
                Expanded(
                  child: MenuCard(
                    title: 'Insumos',
                    icon: Icons.business_center_outlined,
                    color: Colors.cyanAccent.shade700,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InsumoScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}