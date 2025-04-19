import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/pages/home_page.dart';
import 'package:gerenciamento_estoque/pages/menu_page.dart';
import 'package:gerenciamento_estoque/widgets/decoration.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                        decoration: decorationTheme('Usuário',
                            'Informe seu usuário', Icon(Icons.person_outline)),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        decoration: decorationTheme('Senha', 'Digite sua senha',
                            Icon(Icons.password_outlined)),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenuPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Acessar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return const Color(0xFF1C4C9C);
                              }
                              return const Color(0xFF1C4C9C);
                            },
                          ),
                          minimumSize: MaterialStateProperty.all<Size>(
                            Size(225, 40),
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
    ));
  }
}
