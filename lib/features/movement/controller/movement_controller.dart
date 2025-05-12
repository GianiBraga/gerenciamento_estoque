import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../product/controller/product_controller.dart';
import '../../product/model/product_model.dart';
import '../data/movement_service.dart';
import '../model/movement_model.dart';

class MovementController extends GetxController {
  final codigoController = TextEditingController();
  final quantidadeController = TextEditingController();
  final RxString tipoMovimentacao = 'Entrada'.obs;
  final RxBool isLoading = false.obs;

  final MovementService _service = MovementService();

  Future<void> saveMovement() async {
    isLoading.value = true;

    final codigo = codigoController.text.trim();
    final qtdText = quantidadeController.text.trim();
    final tipo = tipoMovimentacao.value;

    if (codigo.isEmpty || qtdText.isEmpty) {
      Get.snackbar('Atenção', 'Preencha todos os campos.',
          snackPosition: SnackPosition.BOTTOM);
      isLoading.value = false;
      return;
    }

    final quantidade = int.tryParse(qtdText);
    if (quantidade == null || quantidade <= 0) {
      Get.snackbar('Erro', 'Quantidade inválida.',
          snackPosition: SnackPosition.BOTTOM);
      isLoading.value = false;
      return;
    }

    try {
      // Buscar produto pelo código
      final produtoResponse = await Supabase.instance.client
          .from('produtos')
          .select()
          .eq('codigo', codigo)
          .single();

      final produto = ProductModel.fromMap(produtoResponse);
      final userId = Supabase.instance.client.auth.currentUser?.id;

      final movement = MovementModel(
        produtoId: produto.id!,
        quantidade: quantidade,
        tipo: _formatarTipoParaSupabase(tipo),
        usuarioId: userId,
        data: DateTime.now(),
      );

      await _service.insertMovement(movement);

      // 🔄 Atualiza a lista de produtos após movimentação
      final productController = Get.find<ProductController>();
      await productController.loadProducts();

      clearForm();
      Get.snackbar('Sucesso', 'Movimentação registrada com sucesso.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao registrar movimentação: $e',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  String _formatarTipoParaSupabase(String tipo) {
    return tipo.toLowerCase().replaceAll('í', 'i');
  }

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
