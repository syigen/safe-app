/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../components/filter_button.dart';
import '../components/notification_item.dart';
import '../model/alert_data.dart';
import '../services/alert_service.dart';
import 'main_page.dart';

class NotificationsPage extends StatefulWidget {
  final String type;

  const NotificationsPage({super.key, required this.type});

  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {
  String currentFilter = 'All';

  late Future<List<AlertData>> futureAlerts;

  @override
  void initState() {
    super.initState();
    futureAlerts = AlertService().getAlerts();
    currentFilter = widget.type == 'Alerts' ? 'Alerts' : 'All';
  }

  Future<String> getCityFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks.isNotEmpty ? placemarks.first : const Placemark();
      return place.locality ?? place.subLocality ?? place.name ?? "Unknown place";
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching address: $e");
      }
      return "Unknown place";
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final mainPageState = context.findAncestorStateOfType<MainPageState>();
        if (mainPageState != null) {
          mainPageState.navigateToHome();
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF021B1A),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    color: Color(0xFFF1F7F6),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    FilterButton(
                      text: 'All',
                      isSelected: currentFilter == 'All',
                      onTap: () => setState(() => currentFilter = 'All'),
                    ),
                    const SizedBox(width: 12),
                    FilterButton(
                      text: 'Alerts',
                      isSelected: currentFilter == 'Alerts',
                      onTap: () => setState(() => currentFilter = 'Alerts'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<AlertData>>(
                  future: futureAlerts,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No notifications available',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    List<Future<Map<String, Object>>> notifications = snapshot.data!.map((alert) async {
                      final parts = alert.location.split(',').map((e) => e.trim()).toList();
                      final latitude = double.parse(parts[1]);
                      final longitude = double.parse(parts[0]);

                      String locationName = await getCityFromCoordinates(latitude, longitude);

                      return {
                        'icon': Icons.warning_amber_rounded,
                        'message': 'Elephants spotted at $locationName!',
                        'time': alert.time,
                        'showMapButton': true,
                        'isAlert': true,
                        'latitude': latitude,
                        'longitude': longitude,
                      };
                    }).toList();

                    return FutureBuilder<List<Map<String, dynamic>>>(
                      future: Future.wait(notifications),
                      builder: (context, notificationsSnapshot) {
                        if (notificationsSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        List<Map<String, dynamic>> filteredNotifications =
                        currentFilter == 'All'
                            ? notificationsSnapshot.data!
                            : notificationsSnapshot.data!.where((n) => n['isAlert']).toList();

                        final ScrollController scrollController = ScrollController();

                        return Scrollbar(
                          controller: scrollController,
                          thickness: 6,
                          radius: const Radius.circular(3),
                          thumbVisibility: true,
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: filteredNotifications.length,
                            itemBuilder: (context, index) {
                              final notification = filteredNotifications[index];
                              final latitude = notification['latitude'];
                              final longitude = notification['longitude'];

                              return NotificationItem(
                                icon: notification['icon'],
                                message: notification['message'],
                                time: notification['time'],
                                showMapButton: notification['showMapButton'],
                                location: LatLng(latitude, longitude),
                                onTap: () {
                                 // Handle tap action here
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}