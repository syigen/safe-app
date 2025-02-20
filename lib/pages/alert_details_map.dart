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
  LatLng? currentLocation;
  bool showCustomWindow = false;
  LatLng? selectedLocation;
  Offset? customInfoWindowOffset;

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

  Future<void> updateCustomInfoWindowPosition() async {
    if (selectedLocation != null) {
      final screenPosition = await _controller.getScreenCoordinate(
        selectedLocation!,
      );
      final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

      setState(() {
        customInfoWindowOffset = Offset(
          screenPosition.x / devicePixelRatio,
          screenPosition.y / devicePixelRatio,
        );
      });
    }
  }

  Future<void> getAddressFromCoordinates(LatLng position) async {
    try {
      List<Placemark> placemarks;
      placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];

      setState(() {
        selectedLocation = position;
        showCustomWindow = true;
      });

      await updateCustomInfoWindowPosition();
    } catch (e) {
      if (kDebugMode) {
        print("Error getting address: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = ref.watch(locationProvider);
    final alerts = ref.watch(alertProvider);

    LatLng initialPosition = widget.selectedLocation ??
        (locationData?.latitude != null && locationData?.longitude != null
            ? LatLng(locationData!.latitude!, locationData.longitude!)
            : const LatLng(
                7.8731, 80.7718));

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

                // Move to selectedLocation if it was passed
                if (widget.selectedLocation != null) {
                  _controller.animateCamera(
                    CameraUpdate.newLatLng(widget.selectedLocation!),
                  );
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
                          getAddressFromCoordinates(alertPosition);
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
            ),
          ],
        ),
      ),
    );
  }
}
