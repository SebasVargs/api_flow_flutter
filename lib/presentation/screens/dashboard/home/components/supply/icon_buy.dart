import 'package:flutter/material.dart';

class IconBuy extends StatelessWidget {
  final Color iconColor;
  final Color backColor;
  const IconBuy({super.key, this.iconColor = Colors.white, this.backColor = const Color.fromARGB(255, 107, 120, 113)});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: 40, // Tamaño del icono
        height: 40,
        decoration: BoxDecoration(
          color: backColor, // Color de fondo
          shape: BoxShape.circle, // Forma circular
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: Icon(
          Icons.inventory_2, // Icono de inventario
          size: 25,
          color: iconColor, // Color del icono
        ),
      ),
    );
  }
}
