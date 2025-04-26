// import 'package:flutter/material.dart';
// import 'package:gerenciamento_estoque/widgets/user_session_util.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//   // Adicione o UserSessionUtil aqui

// class CadastroPage extends StatefulWidget {
//   const CadastroPage({super.key});

//   @override
//   State<CadastroPage> createState() => _CadastroPageState();
// }

// class _CadastroPageState extends State<CadastroPage> {
//   final TextEditingController _nomeController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _senhaController = TextEditingController();

//   Future<void> _cadastrar() async {
//     final nome = _nomeController.text;
//     final email = _emailController.text;
//     final senha = _senhaController.text;

//     if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
//       _showMessage('Por favor, preencha todos os campos.');
//       return;
//     }

//     try {
//       // Realiza o cadastro do usuário no Supabase
//       final response = await Supabase.instance.client.auth.signUp(email, senha);

//       if (response.user != null) {
//         // Cadastra o nome na tabela 'usuarios'
//         final userId = response.user!.id;

//         final insertResponse = await Supabase.instance.client
//             .from('usuarios')
//             .insert({
//           'id': userId,  // O 'id' vai ser o mesmo do 'auth.users'
//           'nome': nome,  // Armazena o nome do usuário
//         }).execute();

//         if (insertResponse.error == null) {
//           // Salva o nome na sessão
//           await UserSessionUtil.saveUserName(nome);

//           _showMessage('Cadastro realizado com sucesso!');
//           Navigator.pop(context);  // Volta para a página de login ou outra página
//         } else {
//           _showMessage('Erro ao salvar nome. Tente novamente.');
//         }
//       } else {
//         _showMessage('Erro ao criar conta. Tente novamente.');
//       }
//     } catch (e) {
//       _showMessage('Erro desconhecido: $e');
//     }
//   }

//   // Função para exibir uma mensagem de erro ou sucesso
//   void _showMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Cadastro de Usuário'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nomeController,
//               decoration: const InputDecoration(labelText: 'Nome'),
//             ),
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(labelText: 'E-mail'),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             TextField(
//               controller: _senhaController,
//               decoration: const InputDecoration(labelText: 'Senha'),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _cadastrar,
//               child: const Text('Cadastrar'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Código com erro, verificar depois. 