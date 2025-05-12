import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/product_controller.dart';
import '../model/product_model.dart';
import 'widgets/product_form.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ProductController controller = Get.find();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller.loadProducts(); // ← Atualiza sempre que a tela for focada
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Image.asset(
            'assets/images/SISTEMA FIERGS.png',
            width: 40,
            height: 40,
            fit: BoxFit.contain,
          ),
        ),
        title: const Text(
          'Produtos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF1C4C9C)),
            onPressed: () {
              showSearch(
                context: context,
                delegate:
                    ProdutoSearchDelegate(controller.products, controller),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        final produtos = controller.products
            .where((p) => p.nome
                .toLowerCase()
                .contains(controller.filtro.value.toLowerCase()))
            .toList();

        if (produtos.isEmpty) {
          return const Center(
            child: Text('Nenhum produto encontrado.'),
          );
        }

        return ListView.builder(
          itemCount: produtos.length,
          itemBuilder: (context, index) {
            final produto = produtos[index];

            return TweenAnimationBuilder(
              duration: Duration(milliseconds: 400 + index * 100),
              tween:
                  Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero),
              builder: (context, offset, child) {
                return Opacity(
                  opacity: 1 - offset.dy * 10,
                  child:
                      Transform.translate(offset: offset * 100, child: child),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1C4C9C)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        produto.imagemUrl?.isNotEmpty == true
                            ? produto.imagemUrl!
                            : 'https://not.a.valid.url/image.png',
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 56,
                          height: 56,
                          color: Colors.grey[200],
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.broken_image_outlined,
                            size: 28,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(produto.nome,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 4),
                          Text(
                            'Estoque: ${produto.quantidade} | Código: ${produto.codigo}',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      color: const Color(0xFF1C4C9C),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: ProductForm(
                              onSaved: controller.loadProducts,
                              produto: produto,
                            ),
                          ),
                        );
                      },
                    ),
                    if (produto.id != null)
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        color: Colors.red[400],
                        onPressed: () =>
                            _confirmarExclusao(context, produto.id!),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ProductForm(
                onSaved: controller.loadProducts,
                produto: null,
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFF1C4C9C),
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  void _confirmarExclusao(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF1C4C9C),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.warning_amber_rounded, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    'Confirmar Exclusão',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Deseja excluir este produto?",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Color(0xFF1C4C9C)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await controller.deleteProduct(id);
                      //Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Excluir',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProdutoSearchDelegate extends SearchDelegate {
  final List<ProductModel> produtos;
  final ProductController controller;

  ProdutoSearchDelegate(this.produtos, this.controller);

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    controller.filtro.value = query;
    close(context, null);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final sugestoes = produtos
        .where((p) => p.nome.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: sugestoes.length,
      itemBuilder: (context, index) {
        final produto = sugestoes[index];
        return ListTile(
          title: Text(produto.nome),
          onTap: () {
            query = produto.nome;
            showResults(context);
          },
        );
      },
    );
  }
}
