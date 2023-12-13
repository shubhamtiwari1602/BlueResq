// map_page.dart
import 'package:demo/pages/resolved_confirm.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class MapPage extends StatefulWidget {
  final String animalName;
  final String severity;
  final String animalLocation;

   const MapPage({
    Key? key,
    required this.animalName,
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

    print("Location permission denied by user");
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
          initialCameraPosition: CameraPosition(
            target: userLocation,
            zoom: 13,
          ),
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
}


class ThreatCard extends StatelessWidget {
  final String animalName;
  final String severity;

  const ThreatCard({Key? key, required this.animalName, required this.severity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        // Do something when Resolved button is pressed
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Resolved'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        const verify();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text('Request Help'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Do something when Detailed SitRep button is pressed
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