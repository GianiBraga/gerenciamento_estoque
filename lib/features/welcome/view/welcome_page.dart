import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/core/widgets/user_session_util.dart';
import 'package:gerenciamento_estoque/features/movement/view/in_out_page.dart';
import 'package:get/get.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context)
                .size
                .height, // Garante centralização vertical
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Só ocupa o espaço necessário
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  const SizedBox(height: 24),
                  const Text(
                    "SENAI SmartStock",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Para testes: força papel de usuário comum
                      await UserSessionUtil.saveUserRole('user');
                      Get.offAll(
                        () => const InOutPage(),
                        transition: Transition.fadeIn,
                        duration: 800.milliseconds,
                      );
                    },
                    child: const Text(
                      'Vamos lá!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) => const Color(0xFF1C4C9C),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                        const Size(225, 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
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
        ),
      ),
    );
  }
}
