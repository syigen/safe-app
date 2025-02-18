import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';  // Import geocoding package
import '../components/filter_button.dart';
import '../components/notification_item.dart';
import '../model/alert_data.dart';
import '../services/alert_service.dart';
import 'main_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String currentFilter = 'All';
  late Future<List<AlertData>> futureAlerts;

  @override
  void initState() {
    super.initState();
    futureAlerts = AlertService().getAlerts();
  }

  // Function to get the nearest city or known place from coordinates
  Future<String> getCityFromCoordinates(double latitude, double longitude) async {
    try {
      // Get a list of placemarks (addresses)
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      // Try to get the city name, or fall back to the first available known place
      Placemark place = placemarks.isNotEmpty ? placemarks.first : Placemark();
      return place.locality ?? place.subLocality ?? place.name ?? "Unknown place";
    } catch (e) {
      print("Error fetching address: $e");
      return "Unknown place"; // Fallback in case of an error
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
        backgroundColor: const Color(0xFF032221),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.white,
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
                      // Assuming location is in "longitude, latitude" format
                      final parts = alert.location.split(',').map((e) => e.trim()).toList();
                      final latitude = double.parse(parts[1]);
                      final longitude = double.parse(parts[0]);

                      // Get the nearest place or city
                      String locationName = await getCityFromCoordinates(latitude, longitude);

                      return {
                        'icon': Icons.warning_amber_rounded,
                        'message': 'Elephants spotted at $locationName!',
                        'time': alert.time,
                        'showMapButton': true,
                        'isAlert': true,
                      };
                    }).toList();

                    // Wait for all asynchronous location fetches to complete
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

                        return ListView.builder(
                          itemCount: filteredNotifications.length,
                          itemBuilder: (context, index) {
                            final notification = filteredNotifications[index];
                            return NotificationItem(
                              icon: notification['icon'],
                              message: notification['message'],
                              time: notification['time'],
                              showMapButton: notification['showMapButton'],
                              onTap: () {
                                if (kDebugMode) {
                                  print('Tapped notification: ${notification['message']}');
                                }
                              },
                            );
                          },
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
