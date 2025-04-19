import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/widgets/decoration.dart';

class ProductForm extends StatelessWidget {
  const ProductForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Código:'),
          TextFormField(
            decoration: decorationTheme('', 'Ex.: 12345...', null),
          ),
          const SizedBox(height: 12),
          const Text('Nome:'),
          TextFormField(
            decoration: decorationTheme('', 'Ex.: Caneta...', null),
          ),
          const SizedBox(height: 12),
          const Text('Valor R\$:'),
          TextFormField(
            decoration: decorationTheme('', 'R\$ 00.00', null),
          ),
          const SizedBox(height: 12),
          const Text('Categoria:'),
          TextFormField(
            decoration: decorationTheme('', 'Escritório', null),
          ),
          const SizedBox(height: 12),
          const Text('Data de validade:'),
          TextFormField(
            decoration: decorationTheme('', '20/05/2025', null),
          ),
        ],
      ),
    );
  }
}
