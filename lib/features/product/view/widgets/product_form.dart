import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/core/widgets/decoration.dart';
import 'package:gerenciamento_estoque/features/product/controller/product_controller.dart';
import 'package:gerenciamento_estoque/features/product/model/product_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

/// Form widget for adding or editing a product.
/// Supports image selection, validation, and saving to Supabase.
class ProductForm extends StatefulWidget {
  final VoidCallback onSaved; // Callback to execute after save
  final ProductModel? produto; // Product to edit (null for new)

  const ProductForm({
    super.key,
    required this.onSaved,
    this.produto,
  });

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final ProductController controller = Get.find();

  File? _imagemSelecionada;
  bool _isLoading = false;

  String? unidadeSelecionada;

  final List<String> unidades = ['unidade', 'caixa'];

  @override
  void initState() {
    super.initState();

    // If editing an existing product, populate form fields
    if (widget.produto != null) {
      final p = widget.produto!;
      controller.codigoController.text = p.codigo;
      controller.nomeController.text = p.nome;
      controller.valorController.text = p.valor.toString();
      controller.categoriaController.text = p.categoria;
      controller.validadeController.text = p.validade;
      controller.quantidadeController.text = p.quantidade.toString();
      controller.descricaoController.text = p.descricao;
      controller.estoqueMinimoController.text = p.estoqueMinimo.toString();
      unidadeSelecionada = p.unidade;
    }
  }

  /// Opens a calendar picker and fills the expiration date field.
  Future<void> _selecionarData() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      controller.validadeController.text =
          DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }

  /// Opens the device gallery to select an image for the product.
  Future<void> _selecionarImagem() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagemSelecionada = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.8;

    return SizedBox(
      height: maxHeight,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image selection area
              Center(
                child: GestureDetector(
                  onTap: _selecionarImagem,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _imagemSelecionada != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _imagemSelecionada!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.add_a_photo,
                            size: 50,
                            color: Colors.grey,
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _buildLabel('Código:'),
              _buildField(controller.codigoController, 'Ex.: 12345...', true),

              _buildLabel('Nome:'),
              _buildField(controller.nomeController, 'Ex.: Caneta...', true),

              _buildLabel('Valor R\$:'),
              _buildField(controller.valorController, 'R\$ 00.00', false,
                  keyboardType: TextInputType.number),

              _buildLabel('Categoria:'),
              _buildField(controller.categoriaController, 'Escritório', false),

              _buildLabel('Data de validade:'),
              TextFormField(
                controller: controller.validadeController,
                readOnly: true,
                onTap: _selecionarData,
                decoration: decorationTheme(
                  '',
                  '20/05/2025',
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selecionarData,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              _buildLabel('Unidade de Medida:'),
              DropdownButtonFormField<String>(
                value: unidadeSelecionada,
                decoration: decorationTheme('', 'Selecione a unidade', null),
                items: unidades
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    unidadeSelecionada = value;
                  });
                },
                validator: (v) => v == null ? 'Selecione uma unidade' : null,
              ),

              const SizedBox(height: 12),

              _buildLabel('Quantidade:'),
              TextFormField(
                controller: controller.quantidadeController,
                decoration: decorationTheme('', 'Ex.: 10', null),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe a quantidade';
                  if (int.tryParse(v) == null) return 'Número inválido';
                  return null;
                },
              ),

              const SizedBox(height: 12),

              _buildLabel('Estoque mínimo:'),
              TextFormField(
                controller: controller.estoqueMinimoController,
                decoration: decorationTheme('', 'Ex.: 5', null),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe o estoque mínimo';
                  if (int.tryParse(v) == null) return 'Número inválido';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              _buildLabel('Descrição:'),
              TextFormField(
                controller: controller.descricaoController,
                decoration:
                    decorationTheme('', 'Descrição do produto...', null),
                maxLines: 3,
              ),

              const SizedBox(height: 24),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () =>
                          {controller.clearForm(), Navigator.of(context).pop()},
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Color(0xFF1C4C9C)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _isLoading = true);
                          if (widget.produto == null) {
                            await controller.saveProduct(
                              imageFile: _imagemSelecionada,
                              unidade: unidadeSelecionada!,
                            );
                          } else {
                            await controller.updateProduct(
                              widget.produto!,
                              imageFile: _imagemSelecionada,
                              unidade: unidadeSelecionada!,
                            );
                          }
                          setState(() => _isLoading = false);
                          widget.onSaved();
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C4C9C),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Salvar',
                              style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(text),
    );
  }

  Widget _buildField(
      TextEditingController controller, String hint, bool required,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: decorationTheme('', hint, null),
      keyboardType: keyboardType,
      validator: required
          ? (v) => (v == null || v.isEmpty) ? 'Campo obrigatório' : null
          : null,
    );
  }
}
