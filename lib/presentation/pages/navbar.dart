import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.view_carousel),
          label: 'Анкеты',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Лайки'),
      ],
    );
  }
}
