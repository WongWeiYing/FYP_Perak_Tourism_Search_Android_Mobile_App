import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// Helper method to get the destination LatLng from an address
Future<LatLng> getDestinationLatLng(String address, String apiKey) async {
  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey',
  );
  final response = await http.get(url);
  final data = jsonDecode(response.body);
  final location = data['results'][0]['geometry']['location'];
  return LatLng(location['lat'], location['lng']);
}

// Helper method to get route data based on origin, destination, and mode of transport
Future<Map<String, dynamic>> getRouteData(
    LatLng origin, LatLng destination, String apiKey, String mode) async {
  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=$mode&key=$apiKey',
  );
  final response = await http.get(url);
  return jsonDecode(response.body);
}

// Helper method to decode the polyline points from the response
List<LatLng> decodePolyline(String encoded) {
  List<LatLng> points = [];
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1F) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1F) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    points.add(LatLng(lat / 1E5, lng / 1E5));
  }

  return points;
}

// Helper method to calculate the bounds for the polyline
LatLngBounds getBounds(List<LatLng> points) {
  double x0 = points[0].latitude;
  double x1 = points[0].latitude;
  double y0 = points[0].longitude;
  double y1 = points[0].longitude;

  for (var point in points) {
    if (point.latitude < x0) x0 = point.latitude;
    if (point.latitude > x1) x1 = point.latitude;
    if (point.longitude < y0) y0 = point.longitude;
    if (point.longitude > y1) y1 = point.longitude;
  }

  return LatLngBounds(
    southwest: LatLng(x0, y0),
    northeast: LatLng(x1, y1),
  );
}

Future<void> openGoogleMapsNavigation(LatLng destination, String mode) async {
  final url = Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}&travelmode=$mode',
  );
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

String generateStaticMapUrl(String address) {
  final apiKey = 'AIzaSyC_AP1sPf_hp0T6S18DO105SxOHV30RdDg';
  final encodedAddress = Uri.encodeComponent(address);
  return 'https://maps.googleapis.com/maps/api/staticmap?center=$encodedAddress&zoom=15&size=600x300&maptype=roadmap&markers=color:red|$encodedAddress&key=$apiKey';
}
