import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/features/movement/view/in_out_page.dart';
import 'package:gerenciamento_estoque/features/product/view/product_list_page.dart';
import 'package:gerenciamento_estoque/features/home/view/home_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          height: 55,
          index: currentPageIndex,
          color: const Color(0xFF1C4C9C),
          buttonBackgroundColor: const Color(0xFF1C4C9C),
          backgroundColor: Colors.transparent,
          onTap: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          items: const <Widget>[
            Icon(
              Icons.assignment,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.home,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.swap_vert_circle_sharp,
              size: 30,
              color: Colors.white,
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            switch (currentPageIndex) {
              case 0:
                return const ProductListPage();
              case 1:
                return const HomePage();
              case 2:
                return const InOutPage();
              default:
                return const HomePage();
            }
          },
        ),
      ),
    );
  }
}
