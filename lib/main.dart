import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/features/auth/controller/login_controller.dart';
import 'package:gerenciamento_estoque/features/auth/view/login_page.dart';
import 'package:gerenciamento_estoque/features/movement/controller/movement_controller.dart';
import 'package:gerenciamento_estoque/features/product/controller/product_controller.dart';
import 'package:gerenciamento_estoque/features/product/view/product_list_page.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://wivxkjaospkprnbswoob.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndpdnhramFvc3BrcHJuYnN3b29iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU2Njk5NDIsImV4cCI6MjA2MTI0NTk0Mn0.qKhnUuP5l2yLlLVqXSF_pzWwYqDRJSaqNQ3YnD5YiDI',
  );

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.put(ProductController());
        Get.put(MovementController());
        Get.put(LoginController());
      }),
      home: const LoginPage(),
    ),
  );
}
