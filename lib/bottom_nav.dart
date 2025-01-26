import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pix_wall/pages/categories.dart';
import 'package:pix_wall/pages/home.dart';
import 'package:pix_wall/pages/search.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;
  late List<Widget> pages;
  late Categories categories;
  late Home home;
  late Search search;

  @override
  void initState() {
    home = Home();
    search = Search();
    categories = Categories();
    pages = [home, search, categories];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: currentTabIndex,
        height: 60,
        backgroundColor: Colors.white, // Fondo detrás del navbar
        color: Colors.black, // Color del navbar
        buttonBackgroundColor: Colors.grey.shade800, // Fondo del botón activo
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        items: const [
          Icon(Icons.home_outlined, color: Colors.white, size: 30),
          Icon(Icons.search_outlined, color: Colors.white, size: 30),
          Icon(Icons.category_outlined, color: Colors.white, size: 30),
        ],
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
      ),
      body: pages[currentTabIndex],
    );
  }
}
