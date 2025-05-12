import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/product/controller/product_controller.dart';
import '../../features/movement/controller/movement_controller.dart';
import '../../features/product/view/product_list_page.dart';
import '../../features/dashboard/view/home_page.dart';
import '../../features/movement/view/in_out_page.dart';

/// Main navigation container that provides access to product list,
/// home dashboard, and stock movement pages using a curved bottom navigation bar.
class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  /// Tracks the index of the currently selected navigation tab.
  int currentPageIndex = 1;

  @override
  void initState() {
    super.initState();
    _registerControllersIfNeeded();
  }

  /// Registers required controllers only if they are not already instantiated.
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
    // Pages associated with each navigation index.
    final List<Widget> pages = const [
      ProductListPage(), // Index 0: Product list
      HomePage(), // Index 1: Dashboard / welcome screen
      InOutPage(), // Index 2: Stock movement registration
    ];

    return SafeArea(
      child: Scaffold(
        // Curved bottom navigation bar with 3 icons
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

        // Render the current page based on selected tab
        body: pages[currentPageIndex],
      ),
    );
  }
}
