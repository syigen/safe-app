/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  LatLng? selectedLocation;

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

  void navigateToMapWithLocation({LatLng? location}) {
    setState(() {
      _currentIndex = 1;
      selectedLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(authClient: SupabaseAuthClient()),
      AlertDetailsMap(selectedLocation: selectedLocation),
      const ServicePage(),
      const NotificationsPage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}