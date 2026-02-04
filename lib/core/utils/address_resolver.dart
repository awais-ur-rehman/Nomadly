import 'package:geocoding/geocoding.dart';

class AddressResolver {
  static Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        // Construct a readable address. e.g. "Street, City, Country"
        // Or "Name, Locality"
        List<String> parts = [];
        if (place.street != null && place.street!.isNotEmpty) parts.add(place.street!);
        if (place.locality != null && place.locality!.isNotEmpty) parts.add(place.locality!);
        if (place.country != null && place.country!.isNotEmpty) parts.add(place.country!);
        
        return parts.join(', ');
      }
      return '$lat, $lng';
    } catch (e) {
      return '$lat, $lng';
    }
  }
}
