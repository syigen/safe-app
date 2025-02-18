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
