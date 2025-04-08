/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 * Licensed under the GNU GENERAL PUBLIC LICENSE
 *                      Version 3  (See LICENSE.md orhttps://www.gnu.org/licenses/gpl-3.0.en.html).
 */

import 'package:geocoding/geocoding.dart';

class LocationService {
  static Future<String> getLocationDetails(String location) async {
    try {
      List<String> coordinates = location.split(',');
      if (coordinates.length < 2) return 'Unknown Location';

      double longitude = double.parse(coordinates[0].trim());
      double latitude = double.parse(coordinates[1].trim());

      List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final String city = place.locality ?? 'Unknown City';
        final String nearestPlace = place.name ?? 'Unknown Place';

        return '$city, near $nearestPlace';
      }
    } catch (e) {
      return 'Unknown Location';
    }
    return 'Unknown Location';
  }
}