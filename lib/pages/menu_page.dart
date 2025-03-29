import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_estoque/pages/home_page.dart';

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
              Icons.swap_vertical_circle_sharp,
              size: 30,
              color: Colors.white,
            ),
          ],
        ),
        body: <Widget>[
          //Product List
          Card(
            child: Center(
              child: Text('Product List Page'),
            ),
          ),

          /// Home page
          HomePage(),

          /// in and out
          Card(
            child: Center(
              child: Text('Product List Page'),
            ),
          ),
        ][currentPageIndex],
      ),
    );
  }
}
