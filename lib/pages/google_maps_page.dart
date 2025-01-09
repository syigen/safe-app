import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import '../providers/location_provider.dart';
import '../providers/marker_provider.dart';
import '../styles/map_styles.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/services.dart';
import 'bottom_panel.dart';

final selectedLocationProvider = StateProvider<LatLng?>((ref) => null);
final addressProvider = StateProvider<String>((ref) => '');

class GoogleMapsScreen extends ConsumerStatefulWidget {
  @override
  _GoogleMapsScreenState createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends ConsumerState<GoogleMapsScreen> {
  late GoogleMapController _controller;
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  String visibleMarkerId = 'current_location';
  late LatLng currentLocation;
  bool showCustomWindow = false;
  LatLng? selectedLocation;

  @override
  void initState() {
    customMarker();
    super.initState();
  }


  Future<void> customMarker() async {
    final ByteData data = await rootBundle.load('assets/map/pinpoint_logo.png');
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 100,
      targetHeight: 100,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final Uint8List resizedImageData = (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();

    final BitmapDescriptor resizedIcon = BitmapDescriptor.fromBytes(resizedImageData);

    setState(() {
      customIcon = resizedIcon;
    });
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
          selectedLocation = position; // Update selectedLocation for current location
        } else {
          selectedLocation = position;
        }
        showCustomWindow = true;
      });
    } catch (e) {
      print("Error getting address: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    final locationData = ref.watch(locationProvider);
    final markers = ref.watch(markerProvider);
    final currentAddress = ref.watch(addressProvider);

    if (locationData == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    currentLocation = LatLng(locationData.latitude!, locationData.longitude!);

    if (currentAddress.isEmpty) {
      getAddressFromCoordinates(currentLocation, true);
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentLocation,
              zoom: 15,
            ),
            myLocationEnabled: false,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) {
              _controller = controller;
              _controller.setMapStyle(mapStyle);
            },
            markers: {
              Marker(
                markerId: MarkerId('current_location'),
                position: currentLocation,
                icon: customIcon,
                visible: visibleMarkerId == 'current_location',
                onTap: () {
                  getAddressFromCoordinates(currentLocation, true);
                },
              ),
              if (selectedLocation != null)
                Marker(
                  markerId: MarkerId('selected_location'),
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
          if (showCustomWindow)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4,
              left: MediaQuery.of(context).size.width * 0.2,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFF00FF90),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        currentAddress,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showCustomWindow = false;
                        });
                      },
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          BottomPanel(
            currentAddress,
            selectedLocation ?? currentLocation,
          ),


          Positioned(
            right: 16,
            top: 80,
            child: FloatingActionButton(
              onPressed: () async {
                final locationData = ref.read(locationProvider);

                if (locationData != null) {
                  final LatLng newCurrentLocation = LatLng(locationData.latitude!, locationData.longitude!);

                  setState(() {
                    visibleMarkerId = 'current_location';
                    currentLocation = newCurrentLocation; // Re-fetch the current location
                    selectedLocation = currentLocation; // Update selectedLocation
                    showCustomWindow = true;
                  });

                  // Fetch address for the updated current location
                  await getAddressFromCoordinates(currentLocation, true);

                  // Animate camera to the new current location
                  _controller.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      currentLocation,
                      15,
                    ),
                  );
                }
              },


              backgroundColor: Color(0xFF021B1A),
              child: Icon(Icons.my_location, color: Colors.white),
            ),
          ),

        ],
      ),
    );
  }
}
