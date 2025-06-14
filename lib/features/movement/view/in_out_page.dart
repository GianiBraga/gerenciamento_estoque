import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/core/widgets/decoration.dart';
import 'package:gerenciamento_estoque/core/widgets/user_session_util.dart';
import 'package:get/get.dart';
import '../../movement/view/modals/product_search_modal.dart';
import '../controller/movement_controller.dart';

/// Page for registering stock entries and exits (movimentações).
/// Includes a form with product code, quantity, and movement type.
/// Integrates with [MovementController] using GetX.
class InOutPage extends GetView<MovementController> {
  const InOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

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
        actions: [
          FutureBuilder<String?>(
            future: UserSessionUtil.getUserRole(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox.shrink();
              }
              if (snapshot.data == 'user') {
                return IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await UserSessionUtil.clearSession();
                    Get.offAllNamed('/login');
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
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
                  // Header of the form
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

                  // Movement form body
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Código do produto + botão de pesquisa (não implementado)
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: controller.codigoController,
                                  decoration: decorationTheme(
                                    'Código do Produto',
                                    '',
                                    null,
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Informe o código do produto';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  color: Color(0xFF1C4C9C),
                                ),
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => ProductSearchModal(
                                      onSelect: (codigoSelecionado) {
                                        controller.codigoController.text =
                                            codigoSelecionado;
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Campo de quantidade
                          TextFormField(
                            controller: controller.quantidadeController,
                            decoration: decorationTheme('Quantidade', '', null),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Informe a quantidade';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Quantidade inválida';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Dropdown para tipo de movimentação (Entrada ou Saída)
                          Obx(() => DropdownButtonFormField<String>(
                                value: controller.tipoMovimentacao.value,
                                decoration: decorationTheme(
                                  'Tipo de Movimentação',
                                  '',
                                  null,
                                ),
                                items: ['Entrada', 'Saída']
                                    .map((tipo) => DropdownMenuItem(
                                          value: tipo,
                                          child: Text(
                                            tipo,
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.tipoMovimentacao.value = value;
                                  }
                                },
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                dropdownColor: Colors.white,
                                isDense: true,
                              )),

                          const SizedBox(height: 24),

                          // Botão de salvar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Obx(() => ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1C4C9C),
                                    ),
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              controller.saveMovement();
                                            }
                                          },
                                    child: controller.isLoading.value
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text(
                                            'Salvar',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                  )),
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
