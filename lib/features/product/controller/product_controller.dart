import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/product_service.dart';
import '../../product/model/product_model.dart';

/// Controller for managing product form and product list using GetX.
class ProductController extends GetxController {
  /// Reactive list of products
  final RxList<ProductModel> products = <ProductModel>[].obs;

  /// Search filter for product list
  final RxString filtro = ''.obs;

  /// Form field controllers
  final codigoController = TextEditingController();
  final nomeController = TextEditingController();
  final valorController = TextEditingController();
  final categoriaController = TextEditingController();
  final validadeController = TextEditingController();
  final quantidadeController = TextEditingController();
  final descricaoController = TextEditingController();

  /// Service layer for Supabase operations
  final ProductService _productService = ProductService();

  /// Load all products from Supabase
  Future<void> loadProducts() async {
    final data = await _productService.getAllProducts();
    print('Produtos carregados: ${data.length}');
    products.assignAll(data);
  }

  /// Save a new product to Supabase
  Future<void> saveProduct({File? imageFile}) async {
    try {
      String? imageUrl;
      if (imageFile != null) {
        final fileName = 'produto_${DateTime.now().millisecondsSinceEpoch}.jpg';
        await Supabase.instance.client.storage
            .from('produtosimagens')
            .upload(fileName, imageFile);
        imageUrl = Supabase.instance.client.storage
            .from('produtosimagens')
            .getPublicUrl(fileName);
      }

      final product = ProductModel(
        codigo: codigoController.text,
        nome: nomeController.text,
        valor:
            double.tryParse(valorController.text.replaceAll(',', '.')) ?? 0.0,
        categoria: categoriaController.text,
        validade: _formatarDataParaSQL(validadeController.text),
        quantidade: int.tryParse(quantidadeController.text) ?? 0,
        descricao: descricaoController.text,
        imagemUrl: imageUrl,
      );

      await _productService.insertProduct(product);

      await loadProducts();

      clearForm();
      Get.back();
      Get.snackbar('Sucesso', 'Produto salvo com sucesso.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao salvar produto: $e',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  /// Update an existing product
  Future<void> updateProduct(ProductModel original, {File? imageFile}) async {
    try {
      String? imageUrl = original.imagemUrl;

      if (imageFile != null) {
        final fileName = 'produto_${DateTime.now().millisecondsSinceEpoch}.jpg';
        await Supabase.instance.client.storage
            .from('produtosimagens')
            .upload(fileName, imageFile);
        imageUrl = Supabase.instance.client.storage
            .from('produtosimagens')
            .getPublicUrl(fileName);
      }

      final updated = ProductModel(
        id: original.id,
        codigo: codigoController.text,
        nome: nomeController.text,
        valor:
            double.tryParse(valorController.text.replaceAll(',', '.')) ?? 0.0,
        categoria: categoriaController.text,
        validade: _formatarDataParaSQL(validadeController.text),
        quantidade: int.tryParse(quantidadeController.text) ?? 0,
        descricao: descricaoController.text,
        imagemUrl: imageUrl,
      );

      await _productService.updateProduct(updated);

      // Atualiza na lista local reativa
      final index = products.indexWhere((p) => p.id == updated.id);
      if (index != -1) {
        products[index] = updated;
        products.refresh(); // força rebuild
      }

      clearForm();
      Get.back();
      Get.snackbar('Sucesso', 'Produto atualizado com sucesso.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao atualizar produto: $e',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  /// Delete a product by ID
  Future<void> deleteProduct(String id) async {
    try {
      await _productService.deleteProduct(id);

      // Remove localmente da lista observável
      products.removeWhere((p) => p.id == id);
      products.refresh(); // garante rebuild se necessário

      // Fecha o dialog (caso esteja dentro de um)
      if (Get.key.currentState?.canPop() == true) {
        Get.back();
      }

      Get.snackbar(
        'Sucesso',
        'Produto excluído com sucesso.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao excluir produto: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  /// Clears all form fields
  void clearForm() {
    codigoController.clear();
    nomeController.clear();
    valorController.clear();
    categoriaController.clear();
    validadeController.clear();
    quantidadeController.clear();
    descricaoController.clear();
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
    super.onClose();
  }

  /// Converts date from dd/MM/yyyy to yyyy-MM-dd (for Supabase)
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
