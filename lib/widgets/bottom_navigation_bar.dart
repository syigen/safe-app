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
      selectedItemColor: const Color(0xFF00FF9D),
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Map'),
        BottomNavigationBarItem(icon: Icon(Icons.apps_outlined), label: 'Services'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: 'Notifications'),
      ],
    );
  }
}
