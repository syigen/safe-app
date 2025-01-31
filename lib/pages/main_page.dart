import 'package:flutter/material.dart';
import 'package:safe_app/auth/auth_service.dart';
import 'package:safe_app/pages/home_page.dart';
import 'package:safe_app/pages/map_page.dart';
import 'package:safe_app/pages/notification_page.dart';
import 'package:safe_app/pages/service_page.dart';
import 'package:safe_app/widgets/bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(authClient: SupabaseAuthClient()),
    const MapPage(),
    const ServicePage(),
    const NotificationsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
