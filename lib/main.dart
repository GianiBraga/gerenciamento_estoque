import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/features/auth/controller/login_controller.dart';
import 'package:gerenciamento_estoque/features/auth/view/login_page.dart';
import 'package:gerenciamento_estoque/features/employee/controller/employee_controller.dart';
import 'package:gerenciamento_estoque/features/menu/menu_page.dart';
import 'package:gerenciamento_estoque/features/movement/controller/movement_controller.dart';
import 'package:gerenciamento_estoque/features/movement/view/in_out_page.dart';
import 'package:gerenciamento_estoque/features/product/controller/product_controller.dart';
import 'package:gerenciamento_estoque/features/welcome/view/welcome_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

//Remover o usuario comum para acesso.
//Fazer testes offline
// Fazer teste na edição de produtos.
// Possiveis nomes: SENAI Controla+; SENAI SmartStock;
Future<void> main() async {
  // Initialize Supabase with project URL and anon key
  await Supabase.initialize(
    url: 'https://wivxkjaospkprnbswoob.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndpdnhramFvc3BrcHJuYnN3b29iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU2Njk5NDIsImV4cCI6MjA2MTI0NTk0Mn0.qKhnUuP5l2yLlLVqXSF_pzWwYqDRJSaqNQ3YnD5YiDI',
  );

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,

      // Bind global controllers before the app builds
      initialBinding: BindingsBuilder(() {
        Get.put(ProductController()); // Controls product data and operations
        Get.put(MovementController()); // Manages inventory movements
        Get.put(LoginController()); // Handles authentication logic
        Get.put(EmployeeController());
      }),

      // Use rota nomeada em vez de home:
      initialRoute: '/welcome',
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/in_out', page: () => const InOutPage()),
        GetPage(name: '/menu', page: () => const MenuPage()),
        GetPage(name: '/welcome', page: () => const WelcomePage()),
        // adicione outras páginas aqui se necessário
      ],
    ),
  );
}
