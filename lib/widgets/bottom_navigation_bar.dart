import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF032221),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF00FF81),
      unselectedItemColor: const Color(0xFFF1F7F6),
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(currentIndex == 0 ? Icons.home : Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(currentIndex == 1 ? Icons.explore_outlined : Icons.explore_outlined),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(currentIndex == 2 ? Icons.apps_outlined : Icons.apps_outlined),
          label: 'Services',
        ),
        BottomNavigationBarItem(
          icon: Icon(currentIndex == 3 ? Icons.notifications : Icons.notifications_outlined),
          label: 'Notifications',
        ),
      ],
    );
  }
}