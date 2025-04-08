/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_app/pages/user_news_list.dart';
import '../components/user_profile_popup.dart';
import '../model/alert_data.dart';
import '../services/alert_service.dart';
import '../services/auth_service.dart';
import '../services/location_service.dart';
import '../widgets/app_drawer.dart';
import '../providers/location_provider.dart';
import '../widgets/build_alert_card.dart';
import '../widgets/build_news_card.dart';
import '../widgets/build_section_header.dart';
import '../widgets/build_service_item.dart';
import '../widgets/service_card.dart';
import 'google_maps_page.dart';
import 'main_page.dart';

final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final authService = AuthService(authClient: SupabaseAuthClient());
  return authService.getUserProfile();
});

class HomeScreen extends ConsumerStatefulWidget {
  final AuthService _authService;

  HomeScreen({super.key, required AuthClient authClient})
      : _authService = AuthService(authClient: authClient);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  bool _checkingProfile = true;

  final alertProvider = FutureProvider<List<AlertData>>((ref) async {
    final alertService = AlertService();
    List<AlertData> alerts = await alertService.getAlerts();

    alerts.sort((a, b) {
      final dateComparison = b.date.compareTo(a.date);
      return dateComparison != 0 ? dateComparison : b.time.compareTo(a.time);
    });

    return alerts.take(2).toList();
  });

  @override
  void initState() {
    super.initState();
    _checkProfileData();
  }

  Future<void> _checkProfileData() async {
    setState(() {
      _checkingProfile = true;
    });

    ref.refresh(userProfileProvider);
    ref.refresh(alertProvider);

    bool hasProfile = await widget._authService.hasProfileData();

    setState(() {
      _checkingProfile = false;
    });

    if (!hasProfile) {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _showProfilePopup();
      }
    }
  }

  void _showProfilePopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProfilePopup(
        authService: widget._authService,
        onConfirm: (name, image) {
          ref.refresh(userProfileProvider);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context)  {
    Future.microtask(() {
      ref.refresh(userProfileProvider);
      ref.refresh(alertProvider);
    });
    final locationData = ref.watch(locationProvider);
    bool isLoading = locationData == null || _checkingProfile;

    final GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey<RefreshIndicatorState>();

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF021B1A),
        endDrawer: AppDrawer(
          onLogout: () => widget._authService.logout(context),
          authService: widget._authService,
        ),
        body: RefreshIndicator(
          key: refreshKey,
          onRefresh: () async {
            ref.refresh(userProfileProvider);
            ref.refresh(alertProvider);
          },
          color: const Color(0xFF00FF9D),
          backgroundColor: const Color(0xFF021B1A),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0).copyWith(right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with user profile
                    Consumer(
                      builder: (context, ref, child) {
                        final userProfileAsync = ref.watch(userProfileProvider);

                        return userProfileAsync.when(
                          data: (profileData) {
                            final String fullName = profileData?['fullName'] ?? 'User';
                            final String avatarUrl = profileData?['avatarUrl'] ?? '';

                            return Row(
                              children: [
                                // Profile image
                                avatarUrl.isNotEmpty
                                    ? CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(avatarUrl),
                                  onBackgroundImageError: (exception, stackTrace) {
                                  },
                                )
                                    : const CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage('assets/user/default.png'),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Hello $fullName,\n',
                                          style: const TextStyle(
                                            color: Color(0xFFF1F7F6 ),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: 'welcome back!',
                                          style: TextStyle(
                                            color: Color(0xFFAACBC4),
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
                            );
                          },
                          loading: () => Row(
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage('assets/user/default.png'),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Loading profile...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
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
                          error: (error, stackTrace) => Row(
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage('assets/user/default.png'),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Hello User,\n',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'welcome back!',
                                        style: TextStyle(
                                          color: Color(0xFFAACBC4 ),
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
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Latest alerts
                    buildSectionHeader('Latest alerts', onTap: () {
                      final mainPageState = context.findAncestorStateOfType<MainPageState>();
                      if (mainPageState != null) {
                        mainPageState.navigateToNotificationPage("Alerts");
                      }
                    }),
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
                                        if (kDebugMode) {
                                          print("Error parsing alert location: ${alert.location}");
                                        }
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
                                        child: buildAlertCard(
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
                          backgroundColor: const Color(0xFF00FF81),
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
                                color: Color(0xFF021B1A),
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
                    GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                        childAspectRatio: 163 / 80,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      children: [
                        ServiceCard(
                          title: 'Contacts',
                          icon: 'assets/icons/contact.png',
                          onTap: () {
                            if (kDebugMode) {
                              print('Contacts button pressed!');
                            }
                          },
                        ),
                        ServiceCard(
                          title: 'Safety tips',
                          icon: 'assets/icons/safety.png',
                          onTap: () {
                            if (kDebugMode) {
                              print('Safety tips button pressed!');
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // News near you
                    buildSectionHeader('Top News', onTap: () {
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
                          buildNewsCard(
                              'Wildlife Depart..', 'The Wildlife Depa.. '),
                          const SizedBox(width: 12),
                          buildNewsCard(
                              'Elephant Death..', 'Sri Lanka Railways..'),
                          const SizedBox(width: 12),
                          buildNewsCard(
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
      ),
    );
  }
}

String _formatAlertTitle(int count, String location) {
  return count > 1
      ? 'A group of elephants has been sighted in $location.'
      : 'An elephant has been sighted in $location.';
}