import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class FloatingMenuButton extends StatelessWidget {
  final Function(String) onOptionSelected;

  FloatingMenuButton({required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add, // Ícono del botón principal
      activeIcon: Icons.close,
      backgroundColor: Colors.blue,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      spacing: 10,
      children: [
        SpeedDialChild(
          child: Icon(Icons.share),
          label: "Compartir",
          backgroundColor: Colors.green,
          onTap: () => onOptionSelected("Compartir"),
        ),
        SpeedDialChild(
          child: Icon(Icons.edit),
          label: "Editar",
          backgroundColor: Colors.orange,
          onTap: () => onOptionSelected("Editar"),
        ),
        SpeedDialChild(
          child: Icon(Icons.delete),
          label: "Eliminar",
          backgroundColor: Colors.red,
          onTap: () => onOptionSelected("Eliminar"),
        ),
      ],
    );
  }
}
