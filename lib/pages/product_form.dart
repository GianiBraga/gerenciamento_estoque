import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/core/widgets/decoration.dart';
import 'package:gerenciamento_estoque/core/widgets/snackbar_util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class ProductForm extends StatefulWidget {
  /// chamada quando o produto for salvo com sucesso
  final VoidCallback onSaved;
  const ProductForm({super.key, required this.onSaved});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers para os campos
  final _codigoController = TextEditingController();
  final _nomeController = TextEditingController();
  final _valorController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _validadeController = TextEditingController();
  final _quantidadeController = TextEditingController(text: '0');
  final _descricaoController = TextEditingController();

  // Imagem do produto
  File? _imagemSelecionada;
  bool _isLoading = false;

  // Cliente Supabase
  final supabase = Supabase.instance.client;

  @override
  void dispose() {
    _codigoController.dispose();
    _nomeController.dispose();
    _valorController.dispose();
    _categoriaController.dispose();
    _validadeController.dispose();
    _quantidadeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _validadeController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _selecionarImagem() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagemSelecionada = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImagem() async {
    if (_imagemSelecionada == null) return null;

    try {
      final fileName = 'produto_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await supabase.storage
          .from('produtosimagens')
          .upload(fileName, _imagemSelecionada!);

      // Obter URL pública da imagem
      final imageUrl =
          supabase.storage.from('produtosimagens').getPublicUrl(fileName);

      return imageUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer upload da imagem: $e')),
      );

      return null;
    }
  }

  // Converter formato de data DD/MM/YYYY para YYYY-MM-DD
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

  // Converter valor em string para decimal
  double? _formatarValor(String valor) {
    if (valor.isEmpty) return null;
    // Remove R$ e substitui vírgula por ponto
    String valorLimpo = valor.replaceAll('R\$', '').trim().replaceAll(',', '.');
    return double.tryParse(valorLimpo);
  }

  Future<void> _salvarProduto() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Upload da imagem (se existir)
        String? imageUrl;
        if (_imagemSelecionada != null) {
          imageUrl = await _uploadImagem();
        }

        // Obter ID do usuário atual
        final userId = supabase.auth.currentUser?.id;

        // Converter valores para os formatos corretos
        int quantidade = int.tryParse(_quantidadeController.text) ?? 0;
        double? valor = _formatarValor(_valorController.text);
        String dataValidade = _formatarDataParaSQL(_validadeController.text);

        // Inserir produto no banco
        await supabase.from('produtos').insert({
          'codigo': _codigoController.text,
          'nome': _nomeController.text,
          'descricao': _descricaoController.text,
          'quantidade': quantidade,
          'imagem_url': imageUrl,
          'usuario_id': userId,
          'valor': valor,
          'categoria': _categoriaController.text,
          'data_validade': dataValidade.isNotEmpty ? dataValidade : null,
        });

        // chama o callback de sucesso:
        widget.onSaved();
        // fecha o diálogo retornando true
        Navigator.of(context).pop(true);

        // Mostrar mensagem de sucesso
        final snackBar = SnackbarUtil.success(
          title: 'Sucesso!',
          message: 'Produto salvo com sucesso.',
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // Limpar formulário
        _formKey.currentState!.reset();
        _codigoController.clear();
        _nomeController.clear();
        _valorController.clear();
        _categoriaController.clear();
        _validadeController.clear();
        _quantidadeController.text = '0';
        _descricaoController.clear();
        setState(() {
          _imagemSelecionada = null;
        });
      } catch (e) {
        print(e);
        final snackBar = SnackbarUtil.error(
          title: 'Erro!',
          message: 'Erro ao salvar produto. $e',
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Limita a 80% da altura total da tela (por exemplo)
    final maxHeight = MediaQuery.of(context).size.height * 0.8;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: maxHeight,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagem
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

              const Text('Código:'),
              TextFormField(
                controller: _codigoController,
                decoration: decorationTheme('', 'Ex.: 12345...', null),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe o código' : null,
              ),
              const SizedBox(height: 12),

              const Text('Nome:'),
              TextFormField(
                controller: _nomeController,
                decoration: decorationTheme('', 'Ex.: Caneta...', null),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 12),

              const Text('Valor R\$:'),
              TextFormField(
                controller: _valorController,
                decoration: decorationTheme('', 'R\$ 00.00', null),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              const Text('Categoria:'),
              TextFormField(
                controller: _categoriaController,
                decoration: decorationTheme('', 'Escritório', null),
              ),
              const SizedBox(height: 12),

              const Text('Data de validade:'),
              TextFormField(
                controller: _validadeController,
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

              const Text('Quantidade:'),
              TextFormField(
                controller: _quantidadeController,
                decoration: decorationTheme('', 'Ex.: 10', null),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe a quantidade';
                  if (int.tryParse(v) == null) return 'Número inválido';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              const Text('Descrição:'),
              TextFormField(
                controller: _descricaoController,
                decoration:
                    decorationTheme('', 'Descrição do produto...', null),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              /// BOTÕES
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      onPressed: () {
                        _salvarProduto();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C4C9C),
                      ),
                      child: const Text(
                        'Salvar',
                        style: TextStyle(color: Colors.white),
                      ),
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
}
