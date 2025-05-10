import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/features/product/controller/product_controller.dart';
import 'package:get/get.dart';
import '../../../core/widgets/user_session_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductController controller = Get.find();
  String? userName;

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  Future<void> _getUserName() async {
    final name = await UserSessionUtil.getUserName();
    setState(() {
      userName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header com saudação
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/SISTEMA FIERGS.png',
                    width: 70,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                  Column(
                    children: [
                      const Text('Seja bem-vindo(a),'),
                      if (userName != null)
                        Text(
                          userName!,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                    ],
                  ),
                  IconButton(
                    onPressed: () async {
                      await UserSessionUtil.clearSession();
                      Get.offAllNamed('/login');
                    },
                    icon: const Icon(
                      Icons.logout_rounded,
                      size: 28,
                      color: Color(0xFF1C4C9C),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 60),
              // Card de produtos com estoque baixo
              Expanded(
                child: Obx(() {
                  final produtosCriticos = controller.products
                      .where((p) => p.quantidade <= 5)
                      .toList();

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C4C9C),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            border: Border.all(
                              color: Colors.blue[100]!,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.inventory,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Produtos com Estoque Baixo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (produtosCriticos.isEmpty)
                          const Expanded(
                            child: Center(
                              child: Text(
                                'Nenhum produto com estoque baixo.',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ),
                          )
                        else
                          Expanded(
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: produtosCriticos.length,
                              separatorBuilder: (_, __) => const Divider(
                                height: 1,
                                thickness: 1,
                                color: Color(0xFF1C4C9C),
                                indent: 16,
                                endIndent: 16,
                              ),
                              itemBuilder: (context, index) {
                                final produto = produtosCriticos[index];
                                return Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                          width: 4, color: Colors.red),
                                    ),
                                  ),
                                  child: ListTile(
                                    minVerticalPadding: 16,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    leading: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.red[50],
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.warning_amber,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    ),
                                    title: Text(
                                      produto.nome,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(
                                      'Código: ${produto.codigo}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    trailing: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Disponível',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600]),
                                        ),
                                        Text(
                                          produto.quantidade.toString(),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
