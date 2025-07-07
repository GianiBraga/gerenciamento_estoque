import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/core/widgets/user_session_util.dart';
import 'package:gerenciamento_estoque/features/movement/view/in_out_page.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Split background: top blue with rounded bottom, bottom white
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
              Expanded(
                child: Container(color: Colors.white),
              ),
            ],
          ),
          // Content overlay
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Hero logo
                  Hero(
                    tag: 'logo-hero',
                    child: Image.asset(
                      'assets/images/SISTEMA FIERGS.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Lottie animation
                  Lottie.asset(
                    'assets/animations/stock.json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  // Title
                  const Text(
                    'SENAI SmartStock',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C4C9C),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Button with icon
                  ElevatedButton.icon(
                    onPressed: () async {
                      await UserSessionUtil.saveUserRole('user');
                      Get.offAll(
                        () => const InOutPage(),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 800),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Vamos lá!'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C4C9C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(200, 48),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Hero footer logo
                  Hero(
                    tag: 'footer-logo-hero',
                    child: Image.asset(
                      'assets/images/SENAI_Descritivo.png',
                      width: 80,
                      height: 80,
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
