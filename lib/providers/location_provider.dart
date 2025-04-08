/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_settings/app_settings.dart';

final locationProvider = StateNotifierProvider<LocationNotifier, LocationData?>((ref) {
  return LocationNotifier();
});

class LocationNotifier extends StateNotifier<LocationData?> {
  LocationNotifier() : super(null) {
    _initializeLocation();
  }

  final Location _location = Location();
  Timer? _permissionCheckTimer;
  bool _isRequestingPermission = false;

  Future<void> _initializeLocation() async {
    await _checkStoredPermissionStatus();
    await getCurrentLocation();
    _startPermissionCheck();
  }

  Future<void> _checkStoredPermissionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final permissionGranted = prefs.getBool('locationPermissionGranted') ?? false;
    if (permissionGranted) {
      if (kDebugMode) {
        print("Location permission previously granted.");
      }
    }
  }

  Future<bool> _handlePermissionRequest() async {
    if (_isRequestingPermission) return false;

    _isRequestingPermission = true;
    final prefs = await SharedPreferences.getInstance();

    try {
      PermissionStatus permissionStatus = await _location.requestPermission();

      if (permissionStatus == PermissionStatus.granted ||
          permissionStatus == PermissionStatus.grantedLimited) {
        prefs.setBool('locationPermissionGranted', true);
        return true;
      } else if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await _location.requestPermission();
        if (permissionStatus == PermissionStatus.granted ||
            permissionStatus == PermissionStatus.grantedLimited) {
          prefs.setBool('locationPermissionGranted', true);
          return true;
        }
      } else if (permissionStatus == PermissionStatus.deniedForever) {
        if (kDebugMode) {
          print("Permission denied forever. Opening settings...");
        }
        await AppSettings.openAppSettings();
      }

      return false;
    } finally {
      _isRequestingPermission = false;
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          throw Exception("Location services are disabled.");
        }
      }

      PermissionStatus permissionStatus = await _location.hasPermission();
      if (permissionStatus == PermissionStatus.denied ||
          permissionStatus == PermissionStatus.deniedForever) {
        final granted = await _handlePermissionRequest();
        if (!granted) {
          if (kDebugMode) {
            print("Location permission not granted after request.");
          }
          return;
        }
      }

      if (await _location.hasPermission() == PermissionStatus.granted ||
          await _location.hasPermission() == PermissionStatus.grantedLimited) {
        final currentLocation = await _location.getLocation();
        state = currentLocation;
      }
    } catch (e) {
      if (!mounted) return;
      Future.delayed(const Duration(seconds: 2), getCurrentLocation);
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
    }
  }

  void _startPermissionCheck() {
    _permissionCheckTimer?.cancel();
    _permissionCheckTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (!mounted) return;

      PermissionStatus permissionStatus = await _location.hasPermission();
      if (permissionStatus == PermissionStatus.denied) {
        await _handlePermissionRequest();
      } else if (permissionStatus == PermissionStatus.deniedForever) {
        _permissionCheckTimer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _permissionCheckTimer?.cancel();
    super.dispose();
  }
}