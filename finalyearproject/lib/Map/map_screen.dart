import 'package:finalyearproject/profile/subscription_prompt_dialog.dart';
import 'package:finalyearproject/profile/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:math' as math;
import 'package:provider/provider.dart';


class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String placeName;

  const MapScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.placeName,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  LatLng _origin = LatLng(5.261873923639764, 103.16787347384805); // Example coordinates, replace with actual current location
  double? _distance;
  String? _duration;
  String? _currentTime;
  final String apiKey = '5b3ce3597851110001cf624800fa54e26e634049ab06662d17ad5d02'; // Replace with your OpenRouteService API key
  bool _navigationStarted = false;
  bool _detailedInfo = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _addDestinationMarker();
    _startRealTimeUpdates(); // Start real-time clock updates
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Start real-time updates for the clock
  void _startRealTimeUpdates() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _currentTime = TimeOfDay.now().format(context); // Update the current time every second
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _addOriginMarker(); // Ensure the origin marker is added when the map is created
  }

  void _addDestinationMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('place'),
          position: LatLng(widget.latitude, widget.longitude),
          infoWindow: InfoWindow(
            title: widget.placeName,
          ),
        ),
      );
    });
  }

  void _addOriginMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('origin'),
          position: _origin,
          infoWindow: InfoWindow(
            title: 'Your Location',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    });
  }

  void _getRoute() async {
    String url = 'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${_origin.longitude},${_origin.latitude}&end=${widget.longitude},${widget.latitude}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['features'] != null && data['features'].isNotEmpty) {
        List<dynamic> coordinates = data['features'][0]['geometry']['coordinates'];
        List<LatLng> polylineCoordinates = coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();

        // Add the origin and destination to the polyline coordinates
        polylineCoordinates.insert(0, _origin);
        polylineCoordinates.add(LatLng(widget.latitude, widget.longitude));

        double distanceInMeters = data['features'][0]['properties']['segments'][0]['distance'];
        double durationInSeconds = data['features'][0]['properties']['segments'][0]['duration'];

        setState(() {
          _distance = distanceInMeters / 1000; // Convert to kilometers
          _duration = _formatDuration(durationInSeconds); // Format the duration

          _polylines.add(Polyline(
            polylineId: PolylineId('route'),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ));
        });

        mapController.animateCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(
              _origin.latitude < widget.latitude ? _origin.latitude : widget.latitude,
              _origin.longitude < widget.longitude ? _origin.longitude : widget.longitude,
            ),
            northeast: LatLng(
              _origin.latitude > widget.latitude ? _origin.latitude : widget.latitude,
              _origin.longitude > widget.longitude ? _origin.longitude : widget.longitude,
            ),
          ),
          100.0, // padding
        ));
      } else {
        print("No routes found");
      }
    } else {
      print("Failed to fetch route");
    }
  }

  String _formatDuration(double seconds) {
    int hours = (seconds ~/ 3600); // Calculate hours
    int minutes = ((seconds % 3600) ~/ 60); // Calculate minutes
    return "${hours > 0 ? '$hours hours ' : ''}$minutes minutes"; // Return formatted duration
  }

  void _navigateToPlace() {
    final isSubscribed = Provider.of<SubscriptionService>(context, listen: false).isSubscribed;

    if (isSubscribed) {
      setState(() {
        _navigationStarted = true; // Indicate that navigation has started
        _detailedInfo = false;
      });
      _addOriginMarker();
      _calculateDistance();
      _getRoute();
    } else {
      showSubscriptionPromptDialog(context);
    }
  }

  void _showDetailedInfo() {
    setState(() {
      _detailedInfo = true; // Show detailed information
    });
    _zoomToCurrentLocation();
  }

  void _stopNavigation() {
    setState(() {
      _detailedInfo = false; // Stop showing detailed information
    });
    _resetCameraPosition();
  }

  //calculate the distance between the origin and the destination
  void _calculateDistance() {
    double distance = _haversine(
      _origin.latitude,
      _origin.longitude,
      widget.latitude,
      widget.longitude,
    );
    setState(() {
      _distance = distance; // Update the distance state
    });
  }
  
  //implementation of the Haversine formula
  double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Radius of the Earth in km
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degToRad(lat1)) * math.cos(_degToRad(lat2)) *
            math.sin(dLon / 2) * math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = R * c; // Distance in km
    return distance;
  }

  double _degToRad(double deg) {
    return deg * (math.pi / 180); // Convert degrees to radians
  }

  void _zoomToCurrentLocation() {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _origin,
          zoom: 18.0, // Adjust the zoom level as needed
        ),
      ),
    );
  }

  void _resetCameraPosition() {
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            _origin.latitude < widget.latitude ? _origin.latitude : widget.latitude,
            _origin.longitude < widget.longitude ? _origin.longitude : widget.longitude,
          ),
          northeast: LatLng(
            _origin.latitude > widget.latitude ? _origin.latitude : widget.latitude,
            _origin.longitude > widget.longitude ? _origin.longitude : widget.longitude,
          ),
        ),
        100.0, // padding
      ),
    );
  }

  //Display map
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.placeName),
        backgroundColor: Colors.orange,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude),
              zoom: 14,
            ),
            markers: _markers, // Set of markers on the map
            polylines: _polylines, // Set of polylines on the map
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
          ),
          if (!_navigationStarted)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: _navigateToPlace,
                child: Text('Start Navigation'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
            ),
          if (_navigationStarted && !_detailedInfo && _duration != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    children: [
                      if (_distance != null)
                        Text(
                          'Distance: ${_distance!.toStringAsFixed(1)} km',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      Text(
                        'Estimated Time: $_duration',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_navigationStarted && !_detailedInfo)
            Positioned(
              bottom: 80, // Adjusted position to be above the "+" button
              left: 16,
              child: FloatingActionButton(
                onPressed: _showDetailedInfo,
                backgroundColor: Colors.orange,
                child: Icon(Icons.navigation),
              ),
            ),
          if (_detailedInfo && _distance != null && _duration != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _stopNavigation,
                      child: Icon(Icons.close, color: Colors.black), // Stop navigation button
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _duration ?? "",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "${_distance!.toStringAsFixed(1)} km",
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            SizedBox(width: 8),
                            Text(
                              _currentTime ?? "",
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 24), // Placeholder for alignment
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
