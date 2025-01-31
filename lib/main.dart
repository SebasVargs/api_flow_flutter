import 'package:flutter/material.dart';
import 'package:api_control_flow/components/navbar/nav_navigation.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Esto quita el banner de debug
      title: 'Tu App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainNavigation(), // Aquí usamos tu navegación en lugar de MyHomePage
    );
  }
}