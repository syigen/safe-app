import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/location_provider.dart';
import '../providers/marker_provider.dart';

class GoogleMapsScreen extends ConsumerStatefulWidget {
  @override
  _GoogleMapsScreenState createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends ConsumerState<GoogleMapsScreen> {
  late GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    final locationData = ref.watch(locationProvider);
    final markers = ref.watch(markerProvider);

    if (locationData == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Google Maps')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final CameraPosition _initialPosition = CameraPosition(
      target: LatLng(locationData.latitude!, locationData.longitude!),
      zoom: 14,
    );

    final currentLocationMarker = Marker(
      markerId: MarkerId('current_location'),
      position: LatLng(locationData.latitude!, locationData.longitude!),
      infoWindow: InfoWindow(title: 'Current Location'),
      icon: BitmapDescriptor.defaultMarker,
    );

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (controller) {
          _controller = controller;
          _controller.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(locationData.latitude!, locationData.longitude!),
            14,
          ));
        },
        markers: markers.isEmpty
            ? {currentLocationMarker}
            : markers,
        onTap: (LatLng position) {
          final newMarker = Marker(
            markerId: MarkerId('selected_location'),
            position: position,
            infoWindow: InfoWindow(title: 'Pinned Location'),
            icon: BitmapDescriptor.defaultMarker,
          );

          ref.read(markerProvider.notifier).addMarker(newMarker);

          _controller.animateCamera(CameraUpdate.newLatLngZoom(position, 14));
        },
      ),
    );
  }
}

