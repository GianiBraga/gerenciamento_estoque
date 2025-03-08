import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/widgets/decoration.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Cadastro de Produtos',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Código:'),
                    ),
                    TextFormField(
                      decoration:
                          decoration_theme('Adicionar Código', 'Ex.: 12345...'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Nome:'),
                    ),
                    TextFormField(
                      decoration: decoration_theme('Nome', 'Ex.: Caneta...'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Valor R\$:'),
                    ),
                    TextFormField(
                      decoration: decoration_theme('Valor', 'R\$ 00.00'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Categoria:'),
                    ),
                    TextFormField(
                      decoration: decoration_theme('Categoria', 'Escritório'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Data de validade:'),
                    ),
                    TextFormField(
                      decoration:
                          decoration_theme('Data de validade', '20/05/2025'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Salvar',
                        ),
                      ),
                    ),
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
