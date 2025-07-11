import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/core/widgets/decoration.dart';
import 'package:gerenciamento_estoque/core/widgets/user_session_util.dart';
import 'package:get/get.dart';
import 'package:gerenciamento_estoque/features/movement/view/modals/product_search_modal.dart';
import 'package:gerenciamento_estoque/features/employee/views/modals/employee_search_modal.dart';
import '../controller/movement_controller.dart';

/// Page for registering stock entries and exits (movimentações).
/// Includes a form with product code, quantity, employee matricula, and movement type.
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
          'Movimentações',
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
                  icon: const Icon(
                    Icons.logout_rounded,
                    size: 28,
                    color: Color(0xFF1C4C9C),
                  ),
                  onPressed: () async {
                    await UserSessionUtil.clearSession();
                    Get.offAllNamed('/welcome');
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
                        'Dados da Movimentação',
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
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Matrícula do funcionário + botão de pesquisa
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: controller.matriculaController,
                                  decoration: decorationTheme(
                                    'Matrícula do Funcionário',
                                    '',
                                    null,
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Informe a matrícula do funcionário';
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
                                    builder: (context) => EmployeeSearchModal(
                                      onSelect: (matricula) {
                                        controller.matriculaController.text =
                                            matricula;
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Código do produto + botão de pesquisa
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: controller.codigoController,
                                  decoration: decorationTheme(
                                      'Código do Produto', '', null),
                                  keyboardType: TextInputType.number,
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Informe o código'
                                      : null,
                                  onChanged: (_) =>
                                      controller.fetchAvailableQuantity(),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.search,
                                    color: Color(0xFF1C4C9C)),
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (_) => ProductSearchModal(
                                      onSelect: (code) {
                                        controller.codigoController.text = code;
                                        controller.fetchAvailableQuantity();
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
                            validator: (v) {
                              if (v == null || v.isEmpty)
                                return 'Informe a quantidade';
                              if (int.tryParse(v) == null)
                                return 'Quantidade inválida';
                              return null;
                            },
                          ),

                          // Aqui mostramos o estoque disponível em tempo real
                          Obx(() {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  Text(
                                    '  Disponível: ${controller.availableQuantity.value}  unidades',
                                    style: TextStyle(
                                        color: Color(0xFF1C4C9C),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            );
                          }),

                          const SizedBox(height: 16),

                          // Tipo de movimentação: fixo em 'Saída' para user, dropdown p/ admin
                          FutureBuilder<String?>(
                            future: UserSessionUtil.getUserRole(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.done) {
                                return const SizedBox.shrink();
                              }
                              final role = snapshot.data?.trim().toLowerCase();

                              if (role == 'admin') {
                                // Admin pode escolher Entradas e Saídas
                                return Obx(() =>
                                    DropdownButtonFormField<String>(
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
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          controller.tipoMovimentacao.value =
                                              value;
                                        }
                                      },
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      dropdownColor: Colors.white,
                                      isDense: true,
                                    ));
                              }

                              // Usuário comum: força 'Saída' e mostra apenas texto
                              return Obx(() {
                                // garante valor compatível
                                controller.tipoMovimentacao.value = 'Saída';
                                return InputDecorator(
                                  decoration: decorationTheme(
                                    'Tipo de Movimentação',
                                    '',
                                    null,
                                  ),
                                  child: Text(
                                    controller.tipoMovimentacao.value,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              });
                            },
                          ),

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
