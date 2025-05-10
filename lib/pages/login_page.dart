import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/pages/menu_page.dart';
import 'package:gerenciamento_estoque/core/widgets/decoration.dart';
import 'package:gerenciamento_estoque/core/widgets/page_transition_util.dart';
import 'package:gerenciamento_estoque/core/widgets/snackbar_util.dart';
import 'package:gerenciamento_estoque/core/widgets/user_session_util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  Future<void> login() async {
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      final snackBar = SnackbarUtil.warning(
        title: 'Atenção!',
        message: 'Preencha os campos de e-mail e senha.',
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: senha,
      );

      if (response.user != null) {
        // Consulta o nome do usuário na tabela 'usuarios'
        final userId = response.user!.id;
        final userResponse = await Supabase.instance.client
            .from('usuarios')
            .select('nome')
            .eq('id', userId)
            .single();

        final nome = userResponse['nome'];
        await UserSessionUtil.saveUserName(nome);

        final snackBar = SnackbarUtil.success(
          title: 'Sucesso!',
          message: 'Login realizado com sucesso.',
        );

        ScaffoldMessenger.of(context)
            .showSnackBar(snackBar)
            .closed
            .then((reason) {
          Navigator.of(context).pushReplacement(
            PageTransitionUtil.createRoute(
              page: const MenuPage(),
              transitionType: TransitionType.scale,
            ),
          );
        });
      } else {
        final snackBar = SnackbarUtil.error(
          title: 'Erro!',
          message: 'Falha ao realizar o login.',
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } on AuthException catch (error) {
      final snackBar = SnackbarUtil.error(
        title: 'Falha ao realizar o login!',
        message: 'E-mail ou senha incorreto.',
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro inesperado. ')),
      );
    }
  }

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
                          controller: emailController, // Ligado no controller
                          decoration: decorationTheme(
                            'E-mail',
                            'Informe seu e-mail',
                            const Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: senhaController, // Ligado no controller
                          obscureText: true, // Esconde a senha
                          decoration: decorationTheme(
                            'Senha',
                            'Digite sua senha',
                            const Icon(Icons.password_outlined),
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: login, // Agora chama a função login
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
                              (Set<MaterialState> states) {
                                return const Color(0xFF1C4C9C);
                              },
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
