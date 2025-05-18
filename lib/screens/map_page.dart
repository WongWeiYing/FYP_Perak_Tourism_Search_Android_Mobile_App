import 'package:flutter/material.dart';
import 'package:go_perak/helper/map_helper.dart' as MapHelper;
import 'package:go_perak/helper/map_helper.dart';
import 'package:go_perak/widgets/button/primary_button.dart';
import 'package:go_perak/widgets/loading_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  final String address;
  const MapPage({Key? key, required this.address}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  LatLng _origin = LatLng(0, 0);
  LatLng _destination = LatLng(0, 0);
  final String _apiKey = 'AIzaSyC_AP1sPf_hp0T6S18DO105SxOHV30RdDg';

  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  String _distance = '';
  String _duration = '';
  String _selectedMode = 'driving';
  String _locationError = '';
  bool _isLoading = true;

  List<String> _modes = ['driving', 'walking'];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationError = 'Location services are disabled.';
        _isLoading = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationError = 'Location permissions are denied.';
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationError =
            'Location permissions are permanently denied. Enable them in settings.';
        _isLoading = false;
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _origin = LatLng(position.latitude, position.longitude);

    _getDestinationLatLng(widget.address);
  }

  Future<void> _getDestinationLatLng(String address) async {
    _destination = await MapHelper.getDestinationLatLng(address, _apiKey);
    _getRouteData();
  }

  Future<void> _getRouteData() async {
    setState(() => _isLoading = true);
    try {
      final routeData = await MapHelper.getRouteData(
          _origin, _destination, _apiKey, _selectedMode);
      final polylinePoints = MapHelper.decodePolyline(
          routeData['routes'][0]['overview_polyline']['points']);
      final bounds = MapHelper.getBounds(polylinePoints);

      setState(() {
        _polylines.clear();
        _markers.clear();

        _markers.add(Marker(
          markerId: const MarkerId('origin'),
          position: _origin,
          infoWindow: const InfoWindow(title: 'Origin'),
        ));
        _markers.add(Marker(
          markerId: const MarkerId('destination'),
          position: _destination,
          infoWindow: const InfoWindow(title: 'Destination'),
        ));

        _polylines.add(Polyline(
          polylineId: const PolylineId('route'),
          points: polylinePoints,
          color: Colors.blue,
          width: 4,
        ));

        _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));

        _distance = routeData['routes'][0]['legs'][0]['distance']['text'];
        _duration = routeData['routes'][0]['legs'][0]['duration']['text'];
        _locationError = '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _locationError = 'Error fetching route data.';
        _isLoading = false;
      });
      print('Error fetching route data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Route Map"),
        backgroundColor: Colors.white,
      ),
      body: _locationError.isNotEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _locationError,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : _isLoading
              ? Center(
                  child: showLoading(),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        value: _selectedMode,
                        decoration: const InputDecoration(
                          labelText: "Select Transportation Mode",
                          border: OutlineInputBorder(),
                        ),
                        items: _modes.map((mode) {
                          return DropdownMenuItem<String>(
                            value: mode,
                            child:
                                Text(mode[0].toUpperCase() + mode.substring(1)),
                          );
                        }).toList(),
                        onChanged: (newMode) {
                          if (newMode != null) {
                            setState(() {
                              _selectedMode = newMode;
                            });
                            _getRouteData();
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Distance: $_distance | Duration: $_duration'),
                    ),
                    Expanded(
                      child: GoogleMap(
                        onMapCreated: (controller) =>
                            _mapController = controller,
                        initialCameraPosition: CameraPosition(
                          target: _origin,
                          zoom: 12,
                        ),
                        markers: _markers,
                        polylines: _polylines,
                        myLocationEnabled: true,
                        zoomControlsEnabled: false,
                      ),
                    ),
                    PrimaryButton(
                      onTap: () =>
                          openGoogleMapsNavigation(_destination, _selectedMode),
                      title: 'Start Navigation in Google Maps',
                    ),
                  ],
                ),
    );
  }
}
