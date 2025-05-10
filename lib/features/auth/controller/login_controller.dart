import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/widgets/snackbar_util.dart';
import '../../../core/widgets/user_session_util.dart';
import '../../../core/widgets/page_transition_util.dart';
import '../../../features/menu/menu_page.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  /// Executa o login com Supabase
  Future<void> login() async {
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      _showSnackbar(SnackbarUtil.warning(
        title: 'Atenção!',
        message: 'Preencha os campos de e-mail e senha.',
      ));
      return;
    }

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: senha,
      );

      if (response.user != null) {
        final userId = response.user!.id;

        final userResponse = await Supabase.instance.client
            .from('usuarios')
            .select('nome')
            .eq('id', userId)
            .single();

        final nome = userResponse['nome'];
        await UserSessionUtil.saveUserName(nome);

        _showSnackbar(SnackbarUtil.success(
          title: 'Sucesso!',
          message: 'Login realizado com sucesso.',
        )).closed.then((_) {
          Get.offAll(() => const MenuPage(),
              transition: Transition.fadeIn, duration: 800.milliseconds);
        });
      } else {
        _showSnackbar(SnackbarUtil.error(
          title: 'Erro!',
          message: 'Falha ao realizar o login.',
        ));
      }
    } on AuthException catch (_) {
      _showSnackbar(SnackbarUtil.error(
        title: 'Falha ao realizar o login!',
        message: 'E-mail ou senha incorreto.',
      ));
    } catch (_) {
      _showSnackbar(SnackbarUtil.error(
        title: 'Erro inesperado',
        message: 'Não foi possível completar o login.',
      ));
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _showSnackbar(
      SnackBar snackBar) {
    return ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }

  @override
  void onClose() {
    emailController.dispose();
    senhaController.dispose();
    super.onClose();
  }
}
