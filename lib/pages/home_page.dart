import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> produtos = [
    {'nome': 'Camiseta tam. M', 'quantidade': 10},
    {'nome': 'Jaleco', 'quantidade': 5},
    {'nome': 'Óculos', 'quantidade': 8},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRect(
                    child: Image.asset(
                      'assets/images/SISTEMA FIERGS.png',
                      width: 70,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Column(
                    children: [
                      Text('Seja bem-vindo(a),'),
                      Text(
                        'Giani Augusto Braga.',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.logout_rounded,
                      size: 28,
                      color: Color(0xFF1C4C9C),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              Expanded(
                child: Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF1C4C9C),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.blue[100]!,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.inventory,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(
                              width: 8,
                            ),
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
                      Expanded(
                          child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: produtos.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFF1C4C9C),
                          indent: 16,
                          endIndent: 16,
                        ),
                        itemBuilder: (context, index) {
                          final produto = produtos[index];
                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(width: 4, color: Colors.red),
                              ),
                            ),
                            child: ListTile(
                              minVerticalPadding: 16,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16),
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.warning_amber,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                produto['nome'],
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                'Código: ${index + 1000}',
                                style: TextStyle(fontSize: 12),
                              ),
                              trailing: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Disponível',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[600]),
                                  ),
                                  Text(
                                    produto['quantidade'].toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
