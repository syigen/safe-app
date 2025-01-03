import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

// Define a provider to manage location data
final locationProvider = StateNotifierProvider<LocationNotifier, LocationData?>((ref) {
  return LocationNotifier();
});

class LocationNotifier extends StateNotifier<LocationData?> {
  LocationNotifier() : super(null) {
    _getCurrentLocation();
  }

  final Location _location = Location();

  // Get the current location and update the state
  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return;
      }

      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }

      final currentLocation = await _location.getLocation();
      state = currentLocation;
    } catch (e) {
      print('Error getting location: $e');
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
