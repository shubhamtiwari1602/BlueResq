import 'package:demo/auth/database_helpher.dart';
import 'package:demo/pages/resolved_confirm.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:url_launcher/url_launcher.dart';
import 'package:demo/pages/map_pages/detailed_sit_report.dart'; 
import 'package:demo/pages/map_pages/resolved.dart';

class MapPage extends StatefulWidget {
  final String animalName;
  final String uniqueId; 
  final String severity;
  final String animalLocation;
  

  const MapPage({
    Key? key,
    required this.animalName,
    required this.uniqueId,
    required this.severity,
    required this.animalLocation,
    
  }) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  LocationData? _currentLocation;
  late LatLng userLocation;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    await _requestLocationPermission();
    await _getCurrentLocation();
  }

  Future<void> _requestLocationPermission() async {
    if (await Permission.location.isGranted) {
      return;
    }

    if (await Permission.location.request().isGranted) {
      return;
    }

    print("Location permission denied by the user");
  }

  Future<void> _getCurrentLocation() async {
    final location = Location();
    try {
      final currentLocation = await location.getLocation();
      setState(() {
        _currentLocation = currentLocation;
        userLocation = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
      });
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  Future<LatLng> _convertAddressToLatLng(String address) async {
    try {
      final locations = await geocoding.locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      print("Error converting address to LatLng: $e");
    }
    return LatLng(0.0, 0.0);
  }

  Future<void> _launchGoogleMaps(LatLng start, LatLng end) async {
    final String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&travelmode=driving";

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Map Page',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 7, // 70% for the map
            child: SizedBox(
              height: 400,
              child: _currentLocation != null
                  ? MapImage(
                      userLocation: userLocation,
                      animalLocation: widget.animalLocation,
                    )
                  : Center(
                      child: Text(
                        'Loading...',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ),
          ),
          Expanded(
            flex: 3, // 30% for the card
            child: SizedBox(
              height: 100,
              child: ThreatCard(
                animalName: widget.animalName,
                severity: widget.severity,
                userLocation: userLocation,
                uniqueId: widget.uniqueId,
                animalLocation: widget.animalLocation,
                onDrivePressed: () async {
                  LatLng animalLatLng = await _convertAddressToLatLng(widget.animalLocation);
                  _launchGoogleMaps(userLocation, animalLatLng);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class MapImage extends StatelessWidget {
  final LatLng userLocation;
  final String animalLocation;

  const MapImage({Key? key, required this.userLocation, required this.animalLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng>(
      future: _convertAddressToLatLng(animalLocation),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final animalLatLng = snapshot.data ?? LatLng(0.0, 0.0);

        return GoogleMap(
          initialCameraPosition: _getInitialCameraPosition([userLocation, animalLatLng], context),
          myLocationEnabled: true,
          markers: {
            Marker(
              markerId: MarkerId('user_location'),
              position: userLocation,
              infoWindow: InfoWindow(title: 'Your Location'),
            ),
            Marker(
              markerId: MarkerId('animal_location'),
              position: animalLatLng,
              infoWindow: InfoWindow(title: 'Animal Location'),
            ),
          },
        );
      },
    );
  }

  Future<LatLng> _convertAddressToLatLng(String address) async {
    try {
      final locations = await geocoding.locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      print("Error converting address to LatLng: $e");
    }
    return LatLng(0.0, 0.0);
  }

  CameraPosition _getInitialCameraPosition(List<LatLng> markerPositions, BuildContext context) {
  if (markerPositions.isNotEmpty) {
    // Calculate the bounds that contain both the user and animal locations
    final double padding = 100.0; // Adjust padding as needed
    final LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        markerPositions.map((position) => position.latitude).reduce((a, b) => a < b ? a : b),
        markerPositions.map((position) => position.longitude).reduce((a, b) => a < b ? a : b),
      ),
      northeast: LatLng(
        markerPositions.map((position) => position.latitude).reduce((a, b) => a > b ? a : b),
        markerPositions.map((position) => position.longitude).reduce((a, b) => a > b ? a : b),
      ),
    );

    // Calculate the center of the bounds
    final LatLng center = LatLng(
      (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
      (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
    );

    // Calculate the zoom level based on the bounds and the screen size
    final double zoom = _calculateZoom(
      bounds.northeast.latitude,
      bounds.southwest.longitude,
      bounds.southwest.latitude,
      bounds.northeast.longitude,
      context,
    );

    return CameraPosition(
      target: center,
      zoom: zoom,
    );
  } else {
    // If no marker positions are available, fallback to a default position and zoom level
    return CameraPosition(
      target: LatLng(0.0, 0.0),
      zoom: 10.0,
    );
  }
}




  double _calculateZoom(double minLat, double minLng, double maxLat, double maxLng, BuildContext context) {
    const double padding = .0; // Adjust padding as needed

    double mapWidth = maxLng - minLng;
    double mapHeight = maxLat - minLat;

    double screenWidth = MediaQuery.of(context).size.width - padding * 2;
    double screenHeight = MediaQuery.of(context).size.height - padding * 2;

    double zoomWidth = mapWidth / screenWidth;
    double zoomHeight = mapHeight / screenHeight;

    double zoom = (zoomWidth > zoomHeight) ? zoomHeight : zoomWidth;

    return zoom;
  }
}

 // Update with the actual path to Verify

class ThreatCard extends StatelessWidget {
  final String animalName;
  final String severity;
  final LatLng? userLocation; // Make it nullable
  final String animalLocation;
  final VoidCallback onDrivePressed;
  final String uniqueId; // Add a field for uniqueId

  ThreatCard({
    Key? key,
    required this.animalName,
    required this.severity,
    required this.userLocation,
    required this.animalLocation,
    required this.onDrivePressed,
    required this.uniqueId, // Initialize uniqueId in the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use a default location if userLocation is null
    final LatLng defaultLocation = LatLng(0.0, 0.0);
    final LatLng locationToUse = userLocation ?? defaultLocation;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.catching_pokemon),
                title: const Text('Animal in Distress'),
                subtitle: Text(animalName),
              ),
              ListTile(
                leading: const Icon(Icons.dangerous_outlined),
                title: const Text('Severity'),
                subtitle: Text(severity),
              ),
              const Divider(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Verify(
                              onCardResolved: (String caseId) {
                                // Call the method to remove the card from the list
                                 deleteCardData(uniqueId); 
                              },
                              caseId: uniqueId, // Use the uniqueId field
                              animalName: animalName,
                              location: animalLocation,
                              severity: severity,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Resolved'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Request Help button press
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text('Request Help'),
                    ),
                    ElevatedButton(
                      onPressed: onDrivePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Drive'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SituationReportPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Detailed SitRep'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

