import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/decoration.dart';
import '../../../core/widgets/snackbar_util.dart';
import '../../../core/widgets/user_session_util.dart';
import '../../../core/widgets/page_transition_util.dart';
import '../../menu/menu_page.dart';
import '../controller/login_controller.dart';

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
              ClipRect(
                child: Image.asset(
                  'assets/images/SISTEMA FIERGS.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 32, 0, 32),
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controller.emailController,
                          decoration: decorationTheme(
                            'E-mail',
                            'Informe seu e-mail',
                            const Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),
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
