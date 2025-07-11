import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/core/utils/db_helper.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/local_product_service.dart';
import '../data/product_service.dart';
import '../../product/model/product_model.dart';

/// Controller responsável por gerenciar produtos, com persistência local
/// (SQLite) e sincronização com Supabase quando online.
class ProductController extends GetxController {
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxString filtro = ''.obs;

  final codigoController = TextEditingController();
  final nomeController = TextEditingController();
  final valorController = TextEditingController();
  final segmentoController = TextEditingController();
  final validadeController = TextEditingController();
  final quantidadeController = TextEditingController();
  final descricaoController = TextEditingController();
  final unidadeController = TextEditingController();
  final estoqueMinimoController = TextEditingController();

  final LocalProductService _localService = LocalProductService();
  final ProductService _remoteService = ProductService();
  final supabase = Supabase.instance.client;

  @override
  Future<void> onInit() async {
    super.onInit();
    await DBHelper.initDB();
    await loadProducts();
    _listenConnectivity();
  }

  @override
  void onClose() {
    codigoController.dispose();
    nomeController.dispose();
    valorController.dispose();
    segmentoController.dispose();
    validadeController.dispose();
    quantidadeController.dispose();
    descricaoController.dispose();
    unidadeController.dispose();
    estoqueMinimoController.dispose();
    super.onClose();
  }

  Future<void> loadProducts() async {
    await syncPending();
    final data = await _remoteService.getAllProducts();
    products.assignAll(data);
  }

  /// Salva produto localmente e tenta sincronização remota
  Future<void> saveProduct() async {
    try {
      final product = ProductModel(
        id: null,
        nome: nomeController.text,
        descricao: descricaoController.text,
        codigo: codigoController.text,
        quantidade: int.tryParse(quantidadeController.text) ?? 0,
        imagemUrl: null,
        usuarioId: supabase.auth.currentUser?.id,
        createdAt: DateTime.now(),
        valor:
            double.tryParse(valorController.text.replaceAll(',', '.')) ?? 0.0,
        segmento: segmentoController.text,
        validade: _parseDate(validadeController.text),
        unidade: unidadeController.text,
        estoqueMinimo: int.tryParse(estoqueMinimoController.text) ?? 0,
      );

      // Persistência local
      await _localService.insert(product);

      // Tenta sincronizar se online
      final conn = await Connectivity().checkConnectivity();
      if (conn != ConnectivityResult.none) {
        final res = await supabase
            .from('produtos')
            .upsert(product.toMap())
            .eq('id', product.id ?? '');
        if (res.error == null) {
          await _localService.markSynced(product.id!);
          Get.snackbar(
            'Sucesso',
            'Produto sincronizado com sucesso.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.withOpacity(0.4),
          );
        }
      } else {
        Get.snackbar(
          'Offline',
          'Sem conexão: produto salvo localmente e será sincronizado depois.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange.withOpacity(0.4),
        );
      }

      await loadProducts();
      clearForm();
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao salvar produto: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.4),
      );
    }
  }

  /// Atualiza produto localmente e tenta sincronização remota
  Future<void> updateProduct(ProductModel original) async {
    try {
      final updated = ProductModel(
        id: original.id,
        nome: nomeController.text,
        descricao: descricaoController.text,
        codigo: codigoController.text,
        quantidade: int.tryParse(quantidadeController.text) ?? 0,
        imagemUrl: original.imagemUrl,
        usuarioId: original.usuarioId,
        createdAt: original.createdAt,
        valor:
            double.tryParse(valorController.text.replaceAll(',', '.')) ?? 0.0,
        segmento: segmentoController.text,
        validade: _parseDate(validadeController.text),
        unidade: unidadeController.text,
        estoqueMinimo: int.tryParse(estoqueMinimoController.text) ?? 0,
      );

      await _localService.insert(updated);

      final conn = await Connectivity().checkConnectivity();
      if (conn != ConnectivityResult.none) {
        final res = await supabase
            .from('produtos')
            .upsert(updated.toMap())
            .eq('id', updated.id ?? '');
        if (res.error == null) {
          await _localService.markSynced(updated.id!);
          Get.snackbar(
            'Sucesso',
            'Produto sincronizado com sucesso.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.withOpacity(0.4),
          );
        }
      } else {
        Get.snackbar(
          'Offline',
          'Sem conexão: alterações salvas localmente e serão sincronizadas depois.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange.withOpacity(0.4),
        );
      }

      final idx = products.indexWhere((p) => p.id == updated.id);
      if (idx != -1) {
        products[idx] = updated;
        products.refresh();
      }
      clearForm();
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao atualizar produto: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.4),
      );
    }
  }

  /// Deleta produto remotamente
  Future<void> deleteProduct(String id) async {
    try {
      await _remoteService.deleteProduct(id);
      products.removeWhere((p) => p.id == id);
      products.refresh();
      if (Get.key.currentState?.canPop() == true) Get.back();
      Get.snackbar(
        'Sucesso',
        'Produto excluído com sucesso.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.4),
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao excluir produto: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.4),
      );
    }
  }

  /// Sincroniza pendentes no SQLite com Supabase
  Future<void> syncPending() async {
    final pendentes = await _localService.getPending();
    for (final p in pendentes) {
      final res = await supabase
          .from('produtos')
          .upsert(p.toMap())
          .eq('id', p.id ?? '');
      if (res.error == null) {
        await _localService.markSynced(p.id!);
      }
    }
  }

  void _listenConnectivity() {
    Connectivity().onConnectivityChanged.listen((status) {
      if (status != ConnectivityResult.none) syncPending();
    });
  }

  /// Limpa os campos do formulário
  void clearForm() {
    codigoController.clear();
    nomeController.clear();
    valorController.clear();
    segmentoController.clear();
    validadeController.clear();
    quantidadeController.clear();
    descricaoController.clear();
    unidadeController.clear();
    estoqueMinimoController.clear();
  }

  /// Converte dd/MM/yyyy para DateTime?
  DateTime? _parseDate(String input) {
    if (input.isEmpty) return null;
    try {
      final parts = input.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
      return DateTime.tryParse(input);
    } catch (_) {
      return null;
    }
  }
}
