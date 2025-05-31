import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/product_controller.dart';

/// A standalone form page for creating or editing a product.
/// Uses GetX to bind form fields from the ProductController.
class ProductPage extends GetView<ProductController> {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with title
      appBar: AppBar(
        title: const Text('Cadastro de Produtos',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),

      // Scrollable form body
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('Código:'),
                _buildField(controller.codigoController, 'Adicionar Código',
                    'Ex.: 12345...'),

                _buildLabel('Nome:'),
                _buildField(
                    controller.nomeController, 'Nome', 'Ex.: Caneta...'),

                _buildLabel('Valor R\$:'),
                _buildField(controller.valorController, 'Valor', 'R\$ 00.00',
                    keyboardType: TextInputType.number),

                _buildLabel('Categoria:'),
                _buildField(
                    controller.segmentoController, 'Categoria', 'Escritório'),

                _buildLabel('Data de validade:'),
                _buildField(controller.validadeController, 'Data de validade',
                    '20/05/2025'),

                _buildLabel('Unidade:'),
                _buildField(controller.unidadeController, 'Unidade',
                    'Ex.: caixa, unidade'),

                _buildLabel('Quantidade:'),
                _buildField(
                    controller.quantidadeController, 'Quantidade', 'Ex.: 10',
                    keyboardType: TextInputType.number),

                _buildLabel('Descrição:'),
                _buildField(controller.descricaoController, 'Descrição',
                    'Breve descrição do produto'),

                const SizedBox(height: 32),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.saveProduct,
                    child: const Text('Salvar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds section label for each input field.
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Builds a customized TextFormField.
  Widget _buildField(
    TextEditingController controller,
    String label,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}
