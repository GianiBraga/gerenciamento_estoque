import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/pages/product_form.dart';
import 'package:gerenciamento_estoque/pages/product_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Map<String, dynamic>> produtos = [
    {
      "nome": "Camiseta M",
      "estoque": 10,
      "codigo": 1000,
      "imagemUrl":
          "https://static.wixstatic.com/media/5b4f0d_a24990f48954407c94bf4044af5103c4~mv2.jpg/v1/fit/w_500,h_500,q_90/file.jpg"
    },
    {
      "nome": "Jaleco",
      "estoque": 5,
      "codigo": 1001,
      "imagemUrl":
          "https://tocha.com.br/wp-content/uploads/2024/11/Design_sem_nome_-_2024-11-05T150202.818__1_-removebg.png"
    },
    {
      "nome": "Óculos",
      "estoque": 8,
      "codigo": 1002,
      "imagemUrl":
          "https://a-static.mlcdn.com.br/800x560/oculos-protecao-seguranca-epi-3m-anti-risco-incolor/boommix/753p/7a4e4e637de3940a15cba95118e58e29.jpeg"
    },
  ];

  String pesquisa = "";

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> produtosFiltrados = produtos
        .where((produto) =>
            produto['nome'].toLowerCase().contains(pesquisa.toLowerCase()))
        .toList();

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
            icon: const Icon(Icons.search),
            color: const Color(0xFF1C4C9C),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProdutoSearchDelegate(produtos, (value) {
                  setState(() {
                    pesquisa = value;
                  });
                }),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: produtosFiltrados.length,
        itemBuilder: (context, index) {
          final produto = produtosFiltrados[index];

          return TweenAnimationBuilder(
            duration: Duration(milliseconds: 400 + index * 100),
            tween: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero),
            builder: (context, offset, child) {
              return Opacity(
                opacity: 1 - offset.dy * 10,
                child: Transform.translate(
                  offset: offset * 100,
                  child: child,
                ),
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
                      produto['imagemUrl'] ?? 'https://via.placeholder.com/64',
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(produto['nome'],
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(
                          'Estoque: ${produto['estoque']} | Código: ${produto['codigo']}',
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    color: const Color(0xFF1C4C9C),
                    onPressed: () {
                      // Editar
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    color: Colors.red[400],
                    onPressed: () {
                      _confirmarExclusao(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              contentPadding:
                  EdgeInsets.zero, // remove padding padrão do content
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header customizado
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1C4C9C),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: const Center(
                      child: Text(
                        'Novo Produto',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  // Conteúdo do formulário
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ProductForm(),
                      ),
                    ),
                  ),
                  // Botões
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
                            // Salvar produto
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFF1C4C9C),
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  void _confirmarExclusao(int index) {
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
            // Cabeçalho com ícone mais próximo da borda
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

            // Conteúdo do corpo
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Deseja excluir o produto '${produtos[index]['nome']}'?",
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),

            // Botões
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
                    onPressed: () {
                      setState(() {
                        produtos.removeAt(index);
                      });
                      Navigator.of(context).pop();
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
  final List<Map<String, dynamic>> produtos;
  final Function(String) onSearch;

  ProdutoSearchDelegate(this.produtos, this.onSearch);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    close(context, null);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final sugestoes = produtos
        .where((p) => p['nome'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: sugestoes.length,
      itemBuilder: (context, index) {
        final produto = sugestoes[index];
        return ListTile(
          title: Text(produto['nome']),
          onTap: () {
            query = produto['nome'];
            showResults(context);
          },
        );
      },
    );
  }
}
