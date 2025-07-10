import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/core/widgets/user_session_util.dart';
import 'package:gerenciamento_estoque/features/movement/view/in_out_page.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
// ajuste o caminho conforme onde colocou

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Fundo dividido: parte superior azul arredondada, parte inferior branca
          Column(
            children: [
              Container(
                height: size.height * 0.5,
                decoration: const BoxDecoration(
                  color: Color(0xFF1C4C9C),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(150),
                    bottomRight: Radius.circular(150),
                  ),
                ),
              ),
              Expanded(child: Container(color: Colors.white)),
            ],
          ),

          // Conteúdo principal
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo com Hero
                  Hero(
                    tag: 'logo-hero',
                    child: Image.asset(
                      'assets/images/SISTEMA FIERGS.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Animação Lottie com cantos arredondados
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Lottie.asset(
                      'assets/animations/stock.json',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Título
                  const Text(
                    'SENAI SmartStock',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C4C9C),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Botão principal com ícone
                  ElevatedButton.icon(
                    onPressed: () async {
                      await UserSessionUtil.saveUserRole('user');
                      Get.offAll(
                        () => const InOutPage(),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 800),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    label: const Text('Vamos lá!',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C4C9C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size(200, 48),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Logo de rodapé com Hero
                  Hero(
                    tag: 'footer-logo-hero',
                    child: Image.asset(
                      'assets/images/SENAI_Descritivo.png',
                      width: 80,
                      height: 80,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botão de acesso restrito
                  TextButton(
                    onPressed: () {
                      Get.offAllNamed('/login');
                    },
                    child: const Text(
                      'Acesso Restrito',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Color(0xFF1C4C9C),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
