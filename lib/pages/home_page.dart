/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_app/pages/user_news_list.dart';
import '../model/alert_data.dart';
import '../services/alert_service.dart';
import '../services/auth_service.dart';
import '../services/location_service.dart';
import '../widgets/app_drawer.dart';
import '../providers/location_provider.dart';
import 'google_maps_page.dart';
import 'main_page.dart';

class HomeScreen extends ConsumerWidget {
  final AuthService _authService;

  final alertProvider = FutureProvider<List<AlertData>>((ref) async {
    final alertService = AlertService();
    List<AlertData> alerts = await alertService.getAlerts();

    alerts.sort((a, b) {
      final dateComparison = b.date.compareTo(a.date);
      return dateComparison != 0 ? dateComparison : b.time.compareTo(a.time);
    });

    return alerts.take(2).toList();
  });

  HomeScreen({super.key, required AuthClient authClient})
      : _authService = AuthService(authClient: authClient);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationData = ref.watch(locationProvider);
    bool isLoading = locationData == null;

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF021B1A),
        endDrawer: AppDrawer(
          onLogout: (context) => _authService.logout(context),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0).copyWith(right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            AssetImage('assets/images/profile_image.png'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Hello User',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ', welcome back!',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Builder(
                        builder: (BuildContext context) {
                          return IconButton(
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Latest alerts
                  _buildSectionHeader('Latest alerts', onTap: () {}),
                  const SizedBox(height: 12),
                  Consumer(
                    builder: (context, ref, child) {
                      final alertAsyncValue = ref.watch(alertProvider);

                      return alertAsyncValue.when(
                        data: (alerts) => SizedBox(
                          height: 220,
                          child: alerts.isNotEmpty
                              ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: alerts.length,
                            itemBuilder: (context, index) {
                              final alert = alerts[index];

                              return FutureBuilder<String>(
                                future: LocationService.getLocationDetails(alert.location),
                                builder: (context, snapshot) {
                                  String locationText = snapshot.data ?? 'Fetching location...';

                                  // Convert alert location to LatLng
                                  List<String> parts = alert.location.split(',').map((e) => e.trim()).toList();
                                  LatLng? alertLatLng;
                                  if (parts.length == 2) {
                                    try {
                                      double latitude = double.parse(parts[1]);
                                      double longitude = double.parse(parts[0]);
                                      alertLatLng = LatLng(latitude, longitude);
                                    } catch (e) {
                                      print("Error parsing alert location: ${alert.location}");
                                    }
                                  }

                                  return GestureDetector(
                                    onTap: () {
                                      if (alertLatLng != null) {
                                        final mainPageState = context.findAncestorStateOfType<MainPageState>();
                                        if (mainPageState != null) {
                                          mainPageState.navigateToMapWithLocation(location: alertLatLng);
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 12.0),
                                      child: _buildAlertCard(
                                        _formatAlertTitle(alert.elephantCount, locationText),
                                        '${alert.date} - ${alert.time}',
                                        imageUrl: alert.image != null
                                            ? alert.image!.path
                                            : 'assets/news/default.png',
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                              : const Center(
                            child: Text(
                              'No alerts available.',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) => Center(
                          child: Text(
                            'Error loading alerts: $error',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    },
                  ),
                  // Send Alert Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GoogleMapsScreen(),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FF9D),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Send alert',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Services and tools
                  const Text(
                    'Services and tools',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildServiceItem(
                        'assets/icons/contact.png',
                        'Contacts',
                      ),
                      _buildServiceItem(
                        'assets/icons/safety.png',
                        'Safety tips',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // News near you
                  _buildSectionHeader('Top News', onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserNewsListView()),
                    );

                  }),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 170,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildNewsCard(
                            'Wildlife Depart..', 'The Wildlife Depa.. '),
                        const SizedBox(width: 12),
                        _buildNewsCard(
                            'Elephant Death..', 'Sri Lanka Railways..'),
                        const SizedBox(width: 12),
                        _buildNewsCard(
                            'National Engin..', 'The National Eng..'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: const Text(
            'See all',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertCard(String title, String subtitle, {String? imageUrl}) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: const Color(0xFF021B1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl ?? 'assets/news/default.png',
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/news/default.png',
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.arrow_forward,
                        size: 20, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String iconPath, String label) {
    return ElevatedButton(
      onPressed: () {
        // Add your button action here
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8.0),
        backgroundColor: const Color(0xFF0B453A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(185, 80),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          Image.asset(
            iconPath,
            height: 70,
            width: 85,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildNewsCard(String title, String subtitle) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: const Color(0xFF021B1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              'assets/news/news3.png',
              height: 100,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.arrow_forward,
                      size: 20,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _formatAlertTitle(int count, String location) {
  return count > 1
      ? 'A group of elephants has been sighted in $location.'
      : 'An elephant has been sighted in $location.';
}
