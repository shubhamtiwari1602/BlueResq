import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

import 'resolved_confirm.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  LocationData? _currentLocation;

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

    // Handle the case where the user denied the permission
    // You can show a dialog or message to inform the user
    print("Location permission denied by user");
  }

  Future<void> _getCurrentLocation() async {
    final location = Location();
    try {
      final currentLocation = await location.getLocation();
      setState(() {
        _currentLocation = currentLocation;
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
                      initialPosition: LatLng(
                        _currentLocation!.latitude!,
                        _currentLocation!.longitude!,
                      ),
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
              child: ThreatCard(),
            ),
          ),
        ],
      ),
    );
  }
}

class MapImage extends StatelessWidget {
  final LatLng initialPosition;

  const MapImage({Key? key, required this.initialPosition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (initialPosition.latitude == 0.0 && initialPosition.longitude == 0.0) {
      return Center(
        child: Text(
          'Location not available',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 13,
      ),
      myLocationEnabled: true,
      markers: {
        Marker(
          markerId: MarkerId('user_location'),
          position: initialPosition,
          infoWindow: InfoWindow(title: 'Your Location'),
        ),
      },
    );
  }
}

class ThreatCard extends StatelessWidget {
  const ThreatCard({Key? key}) : super(key: key);

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
                subtitle: const Text('Dog'),
              ),
              ListTile(
                leading: const Icon(Icons.dangerous_outlined),
                title: const Text('Severity'),
                subtitle: const Text('Medium'),
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
                            builder: (context) => verify(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Resolved'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text('Request Help'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
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
