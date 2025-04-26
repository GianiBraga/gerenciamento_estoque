import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/pages/in_out_page.dart';
import 'package:gerenciamento_estoque/pages/login_page.dart';
import 'package:gerenciamento_estoque/pages/menu_page.dart';
import 'package:gerenciamento_estoque/pages/product_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://wivxkjaospkprnbswoob.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndpdnhramFvc3BrcHJuYnN3b29iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU2Njk5NDIsImV4cCI6MjA2MTI0NTk0Mn0.qKhnUuP5l2yLlLVqXSF_pzWwYqDRJSaqNQ3YnD5YiDI',
  );
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
