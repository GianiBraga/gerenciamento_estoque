import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../product/controller/product_controller.dart';
import '../../../product/model/product_model.dart';

/// Modal to search for a product by name, code or description.
/// Returns the selected product's code back to the calling screen.
class ProductSearchModal extends StatefulWidget {
  final void Function(String codigoSelecionado) onSelect;

  const ProductSearchModal({super.key, required this.onSelect});

  @override
  State<ProductSearchModal> createState() => _ProductSearchModalState();
}

class _ProductSearchModalState extends State<ProductSearchModal> {
  final ProductController controller = Get.find();
  final TextEditingController searchController = TextEditingController();

  List<ProductModel> resultados = [];

  @override
  void initState() {
    super.initState();
    resultados = controller.products;
    searchController.addListener(_filterList);
  }

  void _filterList() {
    final query = searchController.text.toLowerCase();
    setState(() {
      resultados = controller.products.where((p) {
        return p.nome.toLowerCase().contains(query) ||
            p.codigo.toLowerCase().contains(query) ||
            p.descricao.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF1C4C9C),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Buscar Produto',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Fechar',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Pesquisar',
                  hintText: 'Nome, código ou descrição',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: resultados.length,
                itemBuilder: (context, index) {
                  final produto = resultados[index];
                  return ListTile(
                    leading: const Icon(Icons.inventory_2_outlined),
                    title: Text(produto.nome),
                    subtitle: Text('Código: ${produto.codigo}'),
                    onTap: () {
                      widget.onSelect(produto.codigo);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
