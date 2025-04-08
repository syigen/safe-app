/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/location_provider.dart';
import '../services/alert_service.dart';
import '../model/alert_data.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../styles/map_styles.dart';
import 'main_page.dart';

final alertProvider = FutureProvider<List<AlertData>>((ref) async {
  return await AlertService().getAlerts();
});

class AlertDetailsMap extends ConsumerStatefulWidget {
  final LatLng? selectedLocation;

  const AlertDetailsMap({super.key, this.selectedLocation});

  @override
  _AlertDetailsMapState createState() => _AlertDetailsMapState();
}

class _AlertDetailsMapState extends ConsumerState<AlertDetailsMap> {
  late GoogleMapController _controller;
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor tappedIcon = BitmapDescriptor.defaultMarker;
  LatLng? selectedLocation;
  String? alertTitle;
  String? alertDate;
  String? alertTime;
  bool showCustomWindow = false;
  Offset infoWindowPosition = Offset.zero;
  String? tappedMarkerId; // Track which marker is currently tapped
  bool markersLoaded = false;

  @override
  void initState() {
    super.initState();
    loadMarkers();
    // Set the selected location from widget if provided
    if (widget.selectedLocation != null) {
      selectedLocation = widget.selectedLocation;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(locationProvider.notifier).getCurrentLocation();
      ref.refresh(alertProvider);

      // Initialize selected marker when map loads with widget.selectedLocation
      if (widget.selectedLocation != null) {
        Future.delayed(Duration(milliseconds: 500), () {
          _setInitialSelectedMarker();
        });
      }
    });
  }
  void _setInitialSelectedMarker() {
    final alerts = ref.read(alertProvider);
    if (!alerts.hasValue || widget.selectedLocation == null) return;

    // Find the alert that matches widget.selectedLocation
    for (final alert in alerts.value!) {
      try {
        final parts = alert.location
            .split(',')
            .map((e) => e.trim())
            .toList();
        double latitude = double.parse(parts[1]);
        double longitude = double.parse(parts[0]);
        LatLng alertPosition = LatLng(latitude, longitude);

        // Check if this alert position matches the selected location
        if (_arePositionsEqual(alertPosition, widget.selectedLocation!)) {
          String markerId = generateMarkerId(alert);

          setState(() {
            tappedMarkerId = markerId;
            selectedLocation = alertPosition;
            alertTitle = "Elephant Sighting";
            alertDate = alert.date;
            alertTime = alert.time;
            showCustomWindow = true;
          });

          // Update info window position after a short delay
          Future.delayed(Duration(milliseconds: 100), () {
            if (mounted) {
              updateInfoWindowPosition(alertPosition);
            }
          });

          break;
        }
      } catch (e) {
        print("Error checking alert position: $e");
      }
    }
  }

  bool _arePositionsEqual(LatLng pos1, LatLng pos2) {
    const double tolerance = 0.00001; // Adjust based on your coordinate precision needs
    return (pos1.latitude - pos2.latitude).abs() < tolerance &&
        (pos1.longitude - pos2.longitude).abs() < tolerance;
  }

  Future<void> loadMarkers() async {
    await customMarker();
    await tappedMarker();
    setState(() {
      markersLoaded = true;
    });
  }

  Future<void> customMarker() async {
    final data = await rootBundle.load('assets/map/alert_detail_pinpoint.png');
    double screenWidth = MediaQuery.of(context).size.width;
    final markerSize = math.max(80, (screenWidth * 0.30).round());

    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: markerSize,
      targetHeight: markerSize,
    );
    final fi = await codec.getNextFrame();
    final resizedImageData = (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!
        .buffer
        .asUint8List();

    setState(() {
      customIcon = BitmapDescriptor.fromBytes(resizedImageData);
    });
  }

  Future<void> tappedMarker() async {
    final data = await rootBundle.load('assets/map/pinpoint_logo.png');
    double screenWidth = MediaQuery.of(context).size.width;
    final markerSize = math.max(80, (screenWidth * 0.30).round()); // Make tapped marker slightly larger

    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: markerSize,
      targetHeight: markerSize,
    );
    final fi = await codec.getNextFrame();
    final resizedImageData = (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!
        .buffer
        .asUint8List();

    setState(() {
      tappedIcon = BitmapDescriptor.fromBytes(resizedImageData);
    });
  }

  Future<void> updateInfoWindowPosition(LatLng position) async {
    final screenPosition = await _controller.getScreenCoordinate(position);
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    setState(() {
      infoWindowPosition = Offset(
        screenPosition.x / devicePixelRatio,
        screenPosition.y / devicePixelRatio,
      );
    });
  }

  void showAlertInfoWindow(
      String markerId, LatLng position, String title, String date, String time) async {

    setState(() {
      tappedMarkerId = markerId; // Set the tapped marker ID
      selectedLocation = position;
      alertTitle = title;
      alertDate = date;
      alertTime = time;
      showCustomWindow = true;
    });

    await updateInfoWindowPosition(position);
  }

  // Generate a consistent ID for each alert
  String generateMarkerId(AlertData alert) {
    return "marker_${alert.location}_${alert.date}_${alert.time}";
  }



  @override
  Widget build(BuildContext context) {
    final locationData = ref.watch(locationProvider);
    final alerts = ref.watch(alertProvider);

    LatLng initialPosition = widget.selectedLocation ??
        (locationData?.latitude != null && locationData?.longitude != null
            ? LatLng(locationData!.latitude!, locationData.longitude!)
            : const LatLng(7.8731, 80.7718));

    // Responsive values
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double infoWindowWidth = screenWidth * 0.5;
    double infoWindowHeight = screenHeight * 0.08;
    double paddingHorizontal = screenWidth * 0.03;
    double paddingVertical = screenHeight * 0.01;

    return WillPopScope(
      onWillPop: () async {
        final mainPageState = context.findAncestorStateOfType<MainPageState>();
        if (mainPageState != null) {
          mainPageState.navigateToHome();
        }
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialPosition,
                zoom: 15,
              ),
              myLocationEnabled: false,
              myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                _controller.setMapStyle(mapStyle);
                if (widget.selectedLocation != null) {
                  _controller.animateCamera(
                    CameraUpdate.newLatLng(widget.selectedLocation!),
                  );
                } else {
                  final locationData = ref.read(locationProvider);
                  if (locationData?.latitude != null &&
                      locationData?.longitude != null) {
                    LatLng currentPos = LatLng(
                        locationData!.latitude!, locationData.longitude!);
                    _controller.animateCamera(
                      CameraUpdate.newLatLng(currentPos),
                    );
                  }
                }
              },
              markers: markersLoaded && alerts.hasValue
                  ? Set<Marker>.from(
                alerts.value!.map((alert) {
                  try {
                    final parts = alert.location
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    double latitude = double.parse(parts[1]);
                    double longitude = double.parse(parts[0]);
                    LatLng alertPosition = LatLng(latitude, longitude);

                    // Create a stable, consistent marker ID for this alert
                    String markerId = generateMarkerId(alert);

                    // Check only if this specific marker is the currently tapped one
                    bool isSelected = tappedMarkerId == markerId;

                    return Marker(
                      markerId: MarkerId(markerId),
                      position: alertPosition,
                      icon: isSelected ? tappedIcon : customIcon,
                      onTap: () {
                        // Clear previous selection and set new one
                        setState(() {
                          // If tapping the already selected marker, just deselect it
                          if (tappedMarkerId == markerId) {
                            tappedMarkerId = null;
                            showCustomWindow = false;
                          } else {
                            // Otherwise, select the new marker
                            tappedMarkerId = markerId;
                            selectedLocation = alertPosition;
                            // Animate camera to the selected marker
                            _controller.animateCamera(
                              CameraUpdate.newLatLng(alertPosition),
                            );
                            // Show info window for the tapped marker
                            showAlertInfoWindow(markerId, alertPosition,
                                "Elephant Sighting", alert.date, alert.time);
                          }
                        });
                      },
                      zIndex: isSelected ? 2 : 1, // Make selected marker appear on top
                    );
                  } catch (e) {
                    print("Invalid alert location format: ${alert.location}");
                    return Marker(
                      markerId: MarkerId(UniqueKey().toString()),
                      position: const LatLng(0, 0),
                      visible: false,
                    );
                  }
                }),
              )
                  : {},
              onCameraMove: (position) async {
                if (selectedLocation != null) {
                  await updateInfoWindowPosition(selectedLocation!);
                }
              },
            ),
            // Custom info window (Fixed on screen, follows marker)
            if (showCustomWindow && selectedLocation != null)
              Positioned(
                left: infoWindowPosition.dx -
                    (infoWindowWidth * 0.1), // Adjusted for screen size
                top: infoWindowPosition.dy -
                    infoWindowHeight -
                    50, // Position above the marker
                child: Container(
                  width: infoWindowWidth,
                  height: infoWindowHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 4,
                        child: Container(
                          height: infoWindowHeight,
                          padding: EdgeInsets.symmetric(
                            horizontal: paddingHorizontal,
                            vertical: paddingVertical,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFF00FF90),
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(12)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                alertTitle ?? "Elephant Sighting",
                                style: TextStyle(
                                  fontSize:
                                  screenWidth * 0.035,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${alertDate ?? ""} | ${alertTime ?? ""}',
                                style: TextStyle(
                                  fontSize:
                                  screenWidth * 0.03,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.08,
                        height: infoWindowHeight,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(12)),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: screenWidth * 0.05,
                          ),
                          onPressed: () {
                            setState(() {
                              showCustomWindow = false;
                              tappedMarkerId = null; // Reset tapped marker when closing info window
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}