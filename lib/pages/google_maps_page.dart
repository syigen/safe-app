/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:safe_app/widgets/animated_slide_up.dart';
import '../providers/location_provider.dart';
import '../providers/marker_provider.dart';
import '../styles/map_styles.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/services.dart';
import '../widgets/circular_back_button.dart';
import 'bottom_panel.dart';
import 'dart:math' as math;

final selectedLocationProvider = StateProvider<LatLng?>((ref) => null);
final addressProvider = StateProvider<String>((ref) => '');

class GoogleMapsScreen extends ConsumerStatefulWidget {
  const GoogleMapsScreen({super.key});

  @override
  GoogleMapsScreenState createState() => GoogleMapsScreenState();
}

class GoogleMapsScreenState extends ConsumerState<GoogleMapsScreen> {
  late GoogleMapController _controller;
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  String visibleMarkerId = 'current_location';
   LatLng? currentLocation;
  bool showCustomWindow = false;
  LatLng? selectedLocation;
  double _bottomSheetExtent = 0.35;
  Offset? customInfoWindowOffset;


  @override
  void initState() {
    super.initState();
    customMarker();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(locationProvider.notifier).getCurrentLocation();
    });
  }

  Future<void> customMarker() async {
    final data = await rootBundle.load('assets/map/pinpoint_logo.png');
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
    ))!.buffer.asUint8List();

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

  Future<void> getAddressFromCoordinates(LatLng position, bool isCurrentLocation) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];

      ref.read(addressProvider.notifier).state = "${place.street}";

      setState(() {
        if (isCurrentLocation) {
          selectedLocation = position;
        } else {
          selectedLocation = position;
        }
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
    final markers = ref.watch(markerProvider);
    final currentAddress = ref.watch(addressProvider);

    currentLocation = LatLng(locationData!.latitude!, locationData!.longitude!);

    if (currentAddress.isEmpty) {
      getAddressFromCoordinates(currentLocation!, true);
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove shadow
        leading: const CircularBackButton(
          backgroundColor: Colors.white,
          iconColor: Colors.black,
          padding: EdgeInsets.only(left: 16),
        )
      ),

      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentLocation!,
              zoom: 15,
            ),
            myLocationEnabled: false,
            myLocationButtonEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              _controller.setMapStyle(mapStyle);
            },
            onCameraMove: (position) {
              if (showCustomWindow) {
                updateCustomInfoWindowPosition();
              }
            },
            markers: {
              Marker(
                markerId: const MarkerId('current_location'),
                position: currentLocation!,
                icon: customIcon,
                visible: visibleMarkerId == 'current_location',
                onTap: () {
                  getAddressFromCoordinates(currentLocation!, true);
                },
              ),
              if (selectedLocation != null)
                Marker(
                  markerId: const MarkerId('selected_location'),
                  position: selectedLocation!,
                  icon: customIcon,
                  visible: visibleMarkerId == 'selected_location',
                  onTap: () {
                    getAddressFromCoordinates(selectedLocation!, false);
                  },
                ),
            },
            onTap: (LatLng position) {
              setState(() {
                visibleMarkerId = 'selected_location';
              });
              getAddressFromCoordinates(position, false);
              _controller.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
            },
          ),

          // Custom Info Window
          if (showCustomWindow && customInfoWindowOffset != null)
            Positioned(
              left: customInfoWindowOffset!.dx -
                  (MediaQuery.of(context).size.width * 0.3) / 2,
              top: customInfoWindowOffset!.dy - 80,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00FF90),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        currentAddress,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showCustomWindow = false;
                        });
                      },
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Floating Action Button
          Positioned(
            right: 16,
            top: 150,
            child: FloatingActionButton(
              onPressed: () async {
                final currentLocationData = ref.read(locationProvider);

                if (currentLocationData == null || currentLocationData.latitude == null || currentLocationData.longitude == null) {
                  await ref.read(locationProvider.notifier).getCurrentLocation();
                }

                final locationData = ref.read(locationProvider);

                if (locationData != null && locationData.latitude != null && locationData.longitude != null) {
                  final LatLng newCurrentLocation = LatLng(
                    locationData.latitude!,
                    locationData.longitude!,
                  );

                  setState(() {
                    visibleMarkerId = 'current_location';
                    currentLocation = newCurrentLocation;
                    selectedLocation = currentLocation;
                    showCustomWindow = true;
                  });

                  await getAddressFromCoordinates(currentLocation!, true);

                  _controller.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      currentLocation!,
                      15,
                    ),
                  );
                }
              },
              backgroundColor: const Color(0xFF021B1A),
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),

          //  AnimatedSlideUp
          Positioned(
            left: 0,
            right: 0,
            bottom: _bottomSheetExtent * MediaQuery.of(context).size.height,
            child: const AnimatedSlideUp(),
          ),


          // BottomPanel
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              setState(() {
                _bottomSheetExtent = notification.extent;
              });
              return true;
            },
            child: BottomPanel(
              currentAddress,
              selectedLocation ?? currentLocation!,
            ),
          ),
        ],
      ),
    );
  }
}