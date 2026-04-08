import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const CustomBottomNav({Key? key, required this.currentIndex, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0B0B0D),
      selectedItemColor: const Color(0xFFFF9800),
      unselectedItemColor: Colors.white54,
      currentIndex: currentIndex,
      onTap: (index) {
        // TODO_NAVBAR: handle bottom navigation logic or navigation between pages
        onTap(index);
        print("top bar button");
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Meals'),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Star'),
      ],
    );
  }
}
