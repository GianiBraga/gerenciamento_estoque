import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/product_service.dart';
import '../../product/model/product_model.dart';

/// Controller responsible for managing product data and operations using GetX.
/// Handles form input, state management, and Supabase integration.
class ProductController extends GetxController {
  /// Reactive list of all products for listing and search
  final RxList<ProductModel> products = <ProductModel>[].obs;

  /// Search filter text used for filtering product list
  final RxString filtro = ''.obs;

  // Text field controllers for the product form
  final codigoController = TextEditingController();
  final nomeController = TextEditingController();
  final valorController = TextEditingController();
  final categoriaController = TextEditingController();
  final validadeController = TextEditingController();
  final quantidadeController = TextEditingController();
  final descricaoController = TextEditingController();
  final unidadeController = TextEditingController();

  /// Service layer to perform CRUD operations with Supabase
  final ProductService _productService = ProductService();

  /// Loads all products from Supabase and updates the observable list
  Future<void> loadProducts() async {
    final data = await _productService.getAllProducts();
    products.assignAll(data);
  }

  /// Saves a new product to Supabase, including optional image upload
  Future<void> saveProduct(
      {File? imageFile, String unidade = 'unidade'}) async {
    try {
      String? imageUrl;

      // Upload image if provided
      if (imageFile != null) {
        final fileName = 'produto_${DateTime.now().millisecondsSinceEpoch}.jpg';
        await Supabase.instance.client.storage
            .from('produtosimagens')
            .upload(fileName, imageFile);
        imageUrl = Supabase.instance.client.storage
            .from('produtosimagens')
            .getPublicUrl(fileName);
      }

      // Create product model from form input
      final product = ProductModel(
        codigo: codigoController.text,
        nome: nomeController.text,
        valor:
            double.tryParse(valorController.text.replaceAll(',', '.')) ?? 0.0,
        categoria: categoriaController.text,
        validade: _formatarDataParaSQL(validadeController.text),
        unidade: unidade,
        quantidade: int.tryParse(quantidadeController.text) ?? 0,
        descricao: descricaoController.text,
        imagemUrl: imageUrl,
      );

      await _productService.insertProduct(product);
      await loadProducts();

      clearForm();
      Get.back();

      Get.snackbar('Sucesso', 'Produto salvo com sucesso.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.40));
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao salvar produto: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.40));
    }
  }

  /// Updates an existing product on Supabase and refreshes the local list
  Future<void> updateProduct(ProductModel original,
      {File? imageFile, required String unidade}) async {
    try {
      String? imageUrl = original.imagemUrl;

      // Upload new image if provided
      if (imageFile != null) {
        final fileName = 'produto_${DateTime.now().millisecondsSinceEpoch}.jpg';
        await Supabase.instance.client.storage
            .from('produtosimagens')
            .upload(fileName, imageFile);
        imageUrl = Supabase.instance.client.storage
            .from('produtosimagens')
            .getPublicUrl(fileName);
      }

      // Build updated product object
      final updated = ProductModel(
        id: original.id,
        codigo: codigoController.text,
        nome: nomeController.text,
        valor:
            double.tryParse(valorController.text.replaceAll(',', '.')) ?? 0.0,
        categoria: categoriaController.text,
        validade: _formatarDataParaSQL(validadeController.text),
        unidade: unidade,
        quantidade: int.tryParse(quantidadeController.text) ?? 0,
        descricao: descricaoController.text,
        imagemUrl: imageUrl,
      );

      await _productService.updateProduct(updated);

      final index = products.indexWhere((p) => p.id == updated.id);
      if (index != -1) {
        products[index] = updated;
        products.refresh();
      }

      clearForm();
      Get.back();
      Get.snackbar('Sucesso', 'Produto atualizado com sucesso.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.40));
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao atualizar produto: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.40));
    }
  }

  /// Deletes a product from Supabase and removes it from the local list
  Future<void> deleteProduct(String id) async {
    try {
      await _productService.deleteProduct(id);

      products.removeWhere((p) => p.id == id);
      products.refresh();

      if (Get.key.currentState?.canPop() == true) {
        Get.back();
      }

      Get.snackbar('Sucesso', 'Produto excluído com sucesso.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.40));
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao excluir produto: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.40));
    }
  }

  /// Clears all text fields in the product form
  void clearForm() {
    codigoController.clear();
    nomeController.clear();
    valorController.clear();
    categoriaController.clear();
    validadeController.clear();
    quantidadeController.clear();
    descricaoController.clear();
    unidadeController.clear();
  }

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  @override
  void onClose() {
    codigoController.dispose();
    nomeController.dispose();
    valorController.dispose();
    categoriaController.dispose();
    validadeController.dispose();
    quantidadeController.dispose();
    descricaoController.dispose();
    unidadeController.dispose();
    super.onClose();
  }

  /// Converts date string from dd/MM/yyyy to yyyy-MM-dd (used in Supabase)
  String _formatarDataParaSQL(String dataInput) {
    if (dataInput.isEmpty) return '';
    try {
      final partes = dataInput.split('/');
      if (partes.length == 3) {
        return '${partes[2]}-${partes[1]}-${partes[0]}';
      }
      return dataInput;
    } catch (e) {
      return dataInput;
    }
  }
}
