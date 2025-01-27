/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';


final locationProvider = StateNotifierProvider<LocationNotifier, LocationData?>((ref) {
  return LocationNotifier();
});

class LocationNotifier extends StateNotifier<LocationData?> {
  LocationNotifier() : super(null) {
    getCurrentLocation();
  }

  final Location _location = Location();

  Future<void> getCurrentLocation() async {
    try {
      // Ensure location services are enabled
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          throw Exception("Location services are disabled.");
        }
      }

      // Ensure permissions are granted
      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          throw Exception("Location permission not granted.");
        }
      }

      // Fetch the current location
      final currentLocation = await _location.getLocation();
      state = currentLocation;
    } catch (e) {
      print('Error getting location: $e');
      // Retry after 2 seconds if an error occurs
      Future.delayed(Duration(seconds: 2), getCurrentLocation);
    }
  }

  void updateLocation(double latitude, double longitude) {
    if (state != null) {
      state = LocationData.fromMap({
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': state!.accuracy,
        'altitude': state!.altitude,
        'speed': state!.speed,
        'speed_accuracy': state!.speedAccuracy,
      });
      print('Location updated: $latitude, $longitude');
    }
  }
}
