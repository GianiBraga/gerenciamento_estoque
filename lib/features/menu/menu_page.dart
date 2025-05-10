import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/product/controller/product_controller.dart';
import '../../features/movement/controller/movement_controller.dart';
import '../../features/product/view/product_list_page.dart';
import '../../features/dashboard/view/home_page.dart';
import '../../features/movement/view/in_out_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int currentPageIndex = 1;

  @override
  void initState() {
    super.initState();
    _registerControllersIfNeeded();
  }

  void _registerControllersIfNeeded() {
    if (!Get.isRegistered<ProductController>()) {
      Get.put(ProductController());
    }
    if (!Get.isRegistered<MovementController>()) {
      Get.put(MovementController());
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = const [
      ProductListPage(),
      HomePage(),
      InOutPage(),
    ];

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
            Icon(Icons.assignment, size: 30, color: Colors.white),
            Icon(Icons.home, size: 30, color: Colors.white),
            Icon(Icons.swap_vert_circle_sharp, size: 30, color: Colors.white),
          ],
        ),
        body: pages[currentPageIndex],
      ),
    );
  }
}
