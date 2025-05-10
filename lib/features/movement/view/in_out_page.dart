import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/core/widgets/decoration.dart';
import 'package:get/get.dart';

import '../controller/movement_controller.dart';

class InOutPage extends GetView<MovementController> {
  const InOutPage({super.key});

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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1C4C9C),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
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
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: GlobalKey<FormState>(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: controller.codigoController,
                                  decoration: decorationTheme(
                                      'Código do Produto', '', null),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.search,
                                    color: Color(0xFF1C4C9C)),
                                onPressed: () {
                                  Get.snackbar('Info',
                                      'Funcionalidade de pesquisa ainda não implementada.',
                                      snackPosition: SnackPosition.BOTTOM);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: controller.quantidadeController,
                            decoration: decorationTheme('Quantidade', '', null),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          Obx(() => DropdownButtonFormField<String>(
                                value: controller.tipoMovimentacao.value,
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
                                  if (value != null) {
                                    controller.tipoMovimentacao.value = value;
                                  }
                                },
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                                dropdownColor: Colors.white,
                                isDense: true,
                              )),
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
                                  controller.saveMovement();
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
