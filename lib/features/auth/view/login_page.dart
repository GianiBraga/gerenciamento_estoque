import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/decoration.dart';
import '../controller/login_controller.dart';

/// Login page where the user enters email and password to access the system.
/// Uses GetX for controller binding and navigation.
class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo image (header)
              ClipRect(
                child: Image.asset(
                  'assets/images/SISTEMA FIERGS.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),

              // Login form
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 32, 0, 32),
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        // Email input
                        TextFormField(
                          controller: controller.emailController,
                          decoration: decorationTheme(
                            'E-mail',
                            'Informe seu e-mail',
                            const Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Password input (obscured)
                        TextFormField(
                          controller: controller.senhaController,
                          obscureText: true,
                          decoration: decorationTheme(
                            'Senha',
                            'Digite sua senha',
                            const Icon(Icons.password_outlined),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Login button
                        ElevatedButton(
                          onPressed: controller.login,
                          child: const Text(
                            'Acessar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) =>
                                  const Color(0xFF1C4C9C),
                            ),
                            minimumSize: MaterialStateProperty.all<Size>(
                              const Size(225, 40),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // SENAI footer image
              ClipRect(
                child: Image.asset(
                  'assets/images/SENAI_Descritivo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
