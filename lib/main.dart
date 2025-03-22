import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/pages/login_page.dart';
import 'package:gerenciamento_estoque/pages/product_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // Defininido a tela inicial do aplicativo.
      home: LoginPage(),
    );
  }
}
