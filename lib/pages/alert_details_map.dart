/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
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
  LatLng? selectedLocation;
  String? alertTitle;
  String? alertDate;
  String? alertTime;
  bool showCustomWindow = false;
  Offset infoWindowPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    customMarker();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(locationProvider.notifier).getCurrentLocation();
      ref.refresh(alertProvider);
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

  // Update the info window position
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
      LatLng position, String title, String date, String time) async {
    setState(() {
      selectedLocation = position;
      alertTitle = title;
      alertDate = date;
      alertTime = time;
      showCustomWindow = true;
    });

    await updateInfoWindowPosition(position);
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
                ref.refresh(alertProvider);
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
              markers: {
                if (alerts.hasValue)
                  ...alerts.value!.map((alert) {
                    try {
                      final parts = alert.location
                          .split(',')
                          .map((e) => e.trim())
                          .toList();
                      double latitude = double.parse(parts[1]);
                      double longitude = double.parse(parts[0]);
                      LatLng alertPosition = LatLng(latitude, longitude);

                      return Marker(
                        markerId: MarkerId(UniqueKey().toString()),
                        position: alertPosition,
                        icon: customIcon,
                        onTap: () {
                          showAlertInfoWindow(alertPosition,
                              "Elephant Sighting", alert.date, alert.time);
                        },
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
              },
              onCameraMove: (position) async {
                if (selectedLocation != null) {
                  await updateInfoWindowPosition(selectedLocation!);
                }
              },
            ),
            // Custom info window (Fixed on screen, follows marker)
            if (showCustomWindow)
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
                        offset: Offset(0, 4),
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
                          decoration: BoxDecoration(
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
                              SizedBox(height: 2),
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
                        decoration: BoxDecoration(
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
