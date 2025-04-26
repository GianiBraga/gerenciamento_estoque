// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/widgets/decoration.dart';

class InOutPage extends StatefulWidget {
  const InOutPage({super.key});

  @override
  _InOutPageState createState() => _InOutPageState();
}

class _InOutPageState extends State<InOutPage> {
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();
  String tipoMovimentacao = 'Entrada'; // Valor inicial

  final _formKey = GlobalKey<FormState>(); // Chave para o formulário

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
          'Entrada e Saída',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // HEADER AZUL DENTRO DO CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1C4C9C),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: const Center(
                      child: Text(
                        'Selecionar Produto',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  // CONTEÚDO DO FORMULÁRIO
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: codigoController,
                                  decoration: decorationTheme(
                                      'Código do Produto', '', null),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Informe o código';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.search,
                                    color: Color(0xFF1C4C9C)),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Funcionalidade de pesquisa ainda não implementada.'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: quantidadeController,
                            decoration: decorationTheme('Quantidade', '', null),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Informe a quantidade';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: tipoMovimentacao,
                            decoration: decorationTheme(
                                'Tipo de Movimentação', '', null),
                            items: ['Entrada', 'Saída']
                                .map(
                                  (tipo) => DropdownMenuItem(
                                    value: tipo,
                                    child: Text(
                                      tipo,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                tipoMovimentacao = value!;
                              });
                            },
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            dropdownColor: Colors.white,
                            isDense: true,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1C4C9C),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Movimentação de ${tipoMovimentacao.toLowerCase()} salva com sucesso!'),
                                      ),
                                    );
                                    codigoController.clear();
                                    quantidadeController.clear();
                                    setState(() {
                                      tipoMovimentacao = 'Entrada';
                                    });
                                  }
                                },
                                child: const Text(
                                  'Salvar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
