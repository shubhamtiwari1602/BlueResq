import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlng/latlng.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:demo/pages/Sample_map_page.dart';
const String apiKey = 'AIzaSyAUqyE4e_IWgEWnOGPxrQEHYI0jcHpoBJs';

class CardPage extends StatefulWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  _CardPageState createState() => _CardPageState();
}
List<CardItem> _cards = [];
class _CardPageState extends State<CardPage> {
  late DatabaseReference _databaseReference;
  Future<List<CardItem>> _getSortedCards() async {
    

    List<CardItem> sortedCards = await _sortCardsByDistance(_cards);

    return sortedCards;
  }
  

@override
void initState() {
  super.initState();
  _databaseReference = FirebaseDatabase.instance.ref().child('name');
  _databaseReference.onChildAdded.listen((event) {
    Map<dynamic, dynamic>? values = event.snapshot.value as Map<dynamic, dynamic>?;
    if (values != null) {
      // Check if a card with the same uniqueId already exists in _cards
      bool cardExists = _cards.any((card) => card.uniqueId == values['uniqueId']);
      if (!cardExists) {
        setState(() {
          _cards.add(CardItem(
            values['animalName'],
            values['severity'],
            values['location'],
            values['uniqueId'],
          ));
        });
      }
    }
  });
}
  Future<List<CardItem>> _sortCardsByDistance(List<CardItem> cards) async {
    List<CardItem> sortedCards = [];

    try {
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng userLatLng = LatLng(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      for (var card in cards) {
        try {
          List<Location> locations = await locationFromAddress(card.location);
          if (locations.isNotEmpty) {
            LatLng animalLatLng = LatLng(
              locations.first.latitude,
              locations.first.longitude,
            );

            double distance =
                await _calculateDistance(userLatLng, animalLatLng);
            card.distance = distance;

            sortedCards.add(card);
          }
        } catch (e) {
          print("Error converting address to LatLng: $e");
        }
      }

      // Sort cards based on the newly calculated distance
      sortedCards.sort((a, b) => a.distance!.compareTo(b.distance!));

      return sortedCards;
    } catch (e) {
      print("Error getting current position: $e");
      return cards; // Return unsorted cards if there's an error
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Active Cases',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: _cards.isEmpty
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _cards.map((card) {
                    return CardItemWidget(cardItem: card);
                  }).toList(),
                ),
              ),
      ),
    );
  
  }
  Future<double> _calculateDistance(
      LatLng userLatLng, LatLng animalLatLng) async {
    try {
      String url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${userLatLng.latitude},${userLatLng.longitude}&destination=${animalLatLng.latitude},${animalLatLng.longitude}&key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['routes'][0]['legs'][0]['distance']['value'].toDouble();
      } else {
        print('Error calculating distance: ${response.reasonPhrase}');
        return 0.0;
      }
    } catch (e) {
      print("Error calculating distance: $e");
      return 0.0;
    }
  }
}

class CardItem {
  final String animalName;
  final String severity;
  final String location;
  final String uniqueId;
  double? distance;

  CardItem(this.animalName, this.severity, this.location, this.uniqueId, {this.distance});
}

class CardItemWidget extends StatelessWidget {
  final CardItem cardItem;

  const CardItemWidget({
    Key? key,
    required this.cardItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color cardColor = Colors.white;
    Color stripColor = cardItem.severity == 'mild' ? Colors.yellow : Colors.red;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapPage(
              animalName: cardItem.animalName,
              severity: cardItem.severity,
              animalLocation: cardItem.location,
            ),
          ),
        );
        /*showDialog(
          context: context,
          builder: (BuildContext context) {
            // Return the dialog
            return AlertDialog(
              title: Text('Confirmation'),
              content:
                  Text('Will you be able to respond to the selected case?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Proceed'),
                  onPressed: () {
                    // Close the dialog and navigate to the confirmation page
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/mappage');
                  },
                ),
              ],
            );
          },
        );*/
      },
      child: Row(
        children: [
          Expanded(
            child: Card(
              elevation: 5.0,
              margin: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  border: Border(
                    left: BorderSide(
                      color: stripColor,
                      width: 4.0,
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 10.0,
                      left: 10.0,
                      child: Text(
                        cardItem.uniqueId, // Replace with your 7-digit ID
                        style: const TextStyle(
                          fontSize: 14.0, // Adjust the font size as needed
                          color: Colors.black,
                          fontWeight:
                              FontWeight.bold, // Adjust the color as needed
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cardItem.animalName,
                            style: const TextStyle(
                              fontSize: 24.0,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            cardItem.location,
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            cardItem.severity,
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          if (cardItem.distance != null)
                            Text(
                              'Distance: ${cardItem.distance!.toStringAsFixed(2)} meters',
                              style: const TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                            ),
                          if (cardItem.distance == null)
                            CircularProgressIndicator(), // Placeholder for loading distance
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
