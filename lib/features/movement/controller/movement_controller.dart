import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../product/controller/product_controller.dart';
import '../../product/model/product_model.dart';
import '../data/movement_service.dart';
import '../model/movement_model.dart';

/// Controller that handles stock entry and exit operations (movimentações).
/// Responsible for validating input, interacting with Supabase,
/// and updating the product list after each transaction.
class MovementController extends GetxController {
  // Form input controllers
  final codigoController = TextEditingController();
  final quantidadeController = TextEditingController();

  // Reactive variable for movement type ("Entrada" or "Saída")
  final RxString tipoMovimentacao = 'Entrada'.obs;

  // Loading state during save operation
  final RxBool isLoading = false.obs;

  // Service layer responsible for database access
  final MovementService _service = MovementService();

  /// Validates and registers a new inventory movement in Supabase.
  Future<void> saveMovement() async {
    isLoading.value = true;

    final codigo = codigoController.text.trim();
    final qtdText = quantidadeController.text.trim();
    final tipo = tipoMovimentacao.value;

    // Validate required fields
    if (codigo.isEmpty || qtdText.isEmpty) {
      Get.snackbar('Atenção', 'Preencha todos os campos.',
          snackPosition: SnackPosition.BOTTOM);
      isLoading.value = false;
      return;
    }

    // Validate quantity
    final quantidade = int.tryParse(qtdText);
    if (quantidade == null || quantidade <= 0) {
      Get.snackbar('Erro', 'Quantidade inválida.',
          snackPosition: SnackPosition.BOTTOM);
      isLoading.value = false;
      return;
    }

    try {
      // Fetch the product by its code
      final produtoResponse = await Supabase.instance.client
          .from('produtos')
          .select()
          .eq('codigo', codigo)
          .single();

      final produto = ProductModel.fromMap(produtoResponse);
      final userId = Supabase.instance.client.auth.currentUser?.id;

      // Create movement object to be sent to the service
      final movement = MovementModel(
        produtoId: produto.id!,
        quantidade: quantidade,
        tipo: _formatarTipoParaSupabase(tipo),
        usuarioId: userId,
        data: DateTime.now(),
      );

      // Register movement and update product quantity
      await _service.insertMovement(movement);

      // Refresh the product list after movement
      final productController = Get.find<ProductController>();
      await productController.loadProducts();

      clearForm();
      Get.snackbar('Sucesso', 'Movimentação registrada com sucesso.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      // Show error if something goes wrong
      Get.snackbar('Erro', 'Erro ao registrar movimentação: $e',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  /// Converts movement type text into lowercase and removes accents
  /// for compatibility with Supabase enum values.
  String _formatarTipoParaSupabase(String tipo) {
    return tipo.toLowerCase().replaceAll('í', 'i');
  }

  /// Resets the form fields after a movement is saved.
  void clearForm() {
    codigoController.clear();
    quantidadeController.clear();
    tipoMovimentacao.value = 'Entrada';
  }

  /// Dispose text controllers when the controller is destroyed.
  @override
  void onClose() {
    codigoController.dispose();
    quantidadeController.dispose();
    super.onClose();
  }
}
