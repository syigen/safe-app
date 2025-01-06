import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/location_provider.dart';
import '../providers/marker_provider.dart';
import '../styles/map_styles.dart';

class GoogleMapsScreen extends ConsumerStatefulWidget {
  @override
  _GoogleMapsScreenState createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends ConsumerState<GoogleMapsScreen> {
  late GoogleMapController _controller;
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  String visibleMarkerId = 'current_location'; // Track which marker is visible

  @override
  void initState() {
    customMarker();
    super.initState();
  }

  void customMarker() {
    BitmapDescriptor.asset(
      ImageConfiguration(),
      "assets/map/pinpoint_logo.png",
    ).then((icon) {
      setState(() {
        customIcon = icon;
      });
    });
  }

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
      zoom: 15,
    );

    // Current location marker
    final currentLocationMarker = Marker(
      markerId: MarkerId('current_location'),
      position: LatLng(locationData.latitude!, locationData.longitude!),
      infoWindow: InfoWindow(title: 'Current Location'),
      icon: customIcon,
      visible: visibleMarkerId == 'current_location', // Only visible if active
    );

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (controller) {
          _controller = controller;
          _controller.setMapStyle(mapStyle);
          _controller.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(locationData.latitude!, locationData.longitude!),
            15,
          ));
        },
        markers: {
          // Update visibility dynamically based on the currently active marker
          ...markers.map((marker) => marker.copyWith(
            visibleParam: marker.markerId.value == visibleMarkerId,
          )),
          currentLocationMarker,
        },
        onTap: (LatLng position) {
          // Create a new marker for the tapped position
          final newMarker = Marker(
            markerId: MarkerId('selected_location'),
            position: position,
            infoWindow: InfoWindow(title: 'Pinned Location'),
            icon: customIcon,
            visible: true, // Always visible when added
          );

          // Update the marker state to include the new marker
          ref.read(markerProvider.notifier).addMarker(newMarker);

          // Set the tapped marker as the visible one
          setState(() {
            visibleMarkerId = 'selected_location';
          });

          // Zoom into the newly tapped location
          _controller.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
        },
      ),
    );
  }
}
