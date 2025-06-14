import 'package:flutter/foundation.dart'; // para debugPrint
import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/features/movement/view/in_out_page.dart';
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
        final nome = userResponse['nome'] as String;
        await UserSessionUtil.saveUserName(nome);

        // Fetch the user's role from the database
        final roleResponse = await Supabase.instance.client
            .from('usuarios')
            .select('role')
            .eq('id', userId)
            .single();
        final role = roleResponse['role'] as String;
        // Salva o nível de acesso (role) na sessão
        await UserSessionUtil.saveUserRole(role);

        // Clear input fields after successful login
        _clearFields();

        // Show success snackbar and navigate to the appropriate page
        _showSnackbar(SnackbarUtil.success(
          title: 'Sucesso!',
          message: 'Login realizado com sucesso.',
        )).closed.then((_) {
          if (role == 'admin') {
            // Admin vê todas as telas
            Get.offAll(
              () => const MenuPage(),
              transition: Transition.fadeIn,
              duration: 800.milliseconds,
            );
          } else {
            // Usuário comum só vê Movimentações
            Get.offAll(
              () => const InOutPage(),
              transition: Transition.fadeIn,
              duration: 800.milliseconds,
            );
          }
        });
      } else {
        // Show generic login failure
        _showSnackbar(SnackbarUtil.error(
          title: 'Erro!',
          message: 'Falha ao realizar o login.',
        ));
      }
    } on AuthException catch (e) {
      // Supabase-auth specific error (e.g., wrong password)
      debugPrint('AuthException in login(): $e');
      _showSnackbar(SnackbarUtil.error(
        title: 'Falha ao realizar o login!',
        message: e.message,
      ));
    } catch (e, stack) {
      // Fallback for unexpected errors: log completo e mostra mensagem
      debugPrint('Erro inesperado em LoginController.login(): $e\n$stack');
      _showSnackbar(SnackbarUtil.error(
        title: 'Erro inesperado',
        message: e.toString(),
      ));
    }
  }

  /// Clears the email and password input fields.
  void _clearFields() {
    emailController.clear();
    senhaController.clear();
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
