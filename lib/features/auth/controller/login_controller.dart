import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/widgets/snackbar_util.dart';
import '../../../core/widgets/user_session_util.dart';
import '../../../features/menu/menu_page.dart';

/// Controller responsible for user authentication using Supabase.
class LoginController extends GetxController {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  /// Attempts to sign in the user using Supabase credentials.
  Future<void> login() async {
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    // Basic validation for empty fields
    if (email.isEmpty || senha.isEmpty) {
      _showSnackbar(SnackbarUtil.warning(
        title: 'Atenção!',
        message: 'Preencha os campos de e-mail e senha.',
      ));
      return;
    }

    try {
      // Send login request to Supabase
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: senha,
      );

      // If login is successful, load user info and redirect
      if (response.user != null) {
        final userId = response.user!.id;

        // Fetch the user's name from the database
        final userResponse = await Supabase.instance.client
            .from('usuarios')
            .select('nome')
            .eq('id', userId)
            .single();

        final nome = userResponse['nome'];
        await UserSessionUtil.saveUserName(nome);

        // Show success snackbar and navigate to MenuPage
        _showSnackbar(SnackbarUtil.success(
          title: 'Sucesso!',
          message: 'Login realizado com sucesso.',
        )).closed.then((_) {
          Get.offAll(() => const MenuPage(),
              transition: Transition.fadeIn, duration: 800.milliseconds);
        });
      } else {
        // Show generic login failure
        _showSnackbar(SnackbarUtil.error(
          title: 'Erro!',
          message: 'Falha ao realizar o login.',
        ));
      }
    } on AuthException catch (_) {
      // Supabase-auth specific error (e.g., wrong password)
      _showSnackbar(SnackbarUtil.error(
        title: 'Falha ao realizar o login!',
        message: 'E-mail ou senha incorreto.',
      ));
    } catch (_) {
      // Fallback for unexpected errors
      _showSnackbar(SnackbarUtil.error(
        title: 'Erro inesperado',
        message: 'Não foi possível completar o login.',
      ));
    }
  }

  /// Utility to show a snackbar using the current Get context.
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _showSnackbar(
      SnackBar snackBar) {
    return ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }

  /// Dispose controllers when the LoginController is destroyed
  @override
  void onClose() {
    emailController.dispose();
    senhaController.dispose();
    super.onClose();
  }
}
