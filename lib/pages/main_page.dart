/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'package:flutter/material.dart';
import 'package:safe_app/services/auth_service.dart';
import 'package:safe_app/pages/alert_details_map.dart';
import 'package:safe_app/pages/home_page.dart';
import 'package:safe_app/pages/notification_page.dart';
import 'package:safe_app/pages/service_page.dart';
import 'package:safe_app/widgets/bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(authClient: SupabaseAuthClient()),
    AlertDetailsMap(),
    const ServicePage(),
    const NotificationsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void navigateToHome() {
    setState(() {
      _currentIndex = 0;
    });
  }

  void navigateToMap() {
    setState(() {
      _currentIndex = 1;
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