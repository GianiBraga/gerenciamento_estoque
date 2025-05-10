import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/movement_service.dart';
import '../model/movement_model.dart';

class MovementController extends GetxController {
  // Form controllers
  final codigoController = TextEditingController();
  final quantidadeController = TextEditingController();
  final RxString tipoMovimentacao = 'Entrada'.obs;

  final MovementService _service = MovementService();

  /// Salva a movimentação no Supabase
  Future<void> saveMovement() async {
    final codigo = codigoController.text.trim();
    final qtdText = quantidadeController.text.trim();

    if (codigo.isEmpty || qtdText.isEmpty) {
      Get.snackbar('Atenção', 'Preencha todos os campos obrigatórios.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final quantidade = int.tryParse(qtdText);
    if (quantidade == null || quantidade <= 0) {
      Get.snackbar('Erro', 'Quantidade inválida.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;

      final movement = MovementModel(
        codigoProduto: codigo,
        quantidade: quantidade,
        tipo: tipoMovimentacao.value,
        data: DateTime.now(),
        usuarioId: userId,
      );

      await _service.insertMovement(movement);
      clearForm();

      Get.snackbar('Sucesso', 'Movimentação registrada com sucesso.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao registrar movimentação: $e',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  /// Limpa o formulário
  void clearForm() {
    codigoController.clear();
    quantidadeController.clear();
    tipoMovimentacao.value = 'Entrada';
  }

  @override
  void onClose() {
    codigoController.dispose();
    quantidadeController.dispose();
    super.onClose();
  }
}
