import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:demo/pages/Sample_map_page.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlng/latlng.dart';
import 'package:http/http.dart' as http;

// Add your Google Maps API key here
const String apiKey = 'AIzaSyAUqyE4e_IWgEWnOGPxrQEHYI0jcHpoBJs';

class CardPage extends StatelessWidget {
  const CardPage({Key? key}) : super(key: key);

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
      body: FutureBuilder<List<CardItem>>(
        future: _getSortedCards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}'));
          }

          List<CardItem> sortedCards = snapshot.data ?? [];

          return Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: sortedCards.map((card) {
                  return CardItemWidget(cardItem: card);
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<CardItem>> _getSortedCards() async {
    List<CardItem> cards = [
      CardItem('Dog', 'severe', 'Chennai Airport'),
      CardItem('Cat', 'mild', 'porur chennai'),
      CardItem('Monkey', 'severe', 'triplicane chennai'),
      CardItem('Donkey', 'mild', 'parry\'s corner chennai'),
      CardItem('Deer', 'severe', 'Himalaya IIT Madras'),
    ];

    List<CardItem> sortedCards = await _sortCardsByDistance(cards);

    return sortedCards;
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

            double distance = await _calculateDistance(userLatLng, animalLatLng);
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

  Future<double> _calculateDistance(LatLng userLatLng, LatLng animalLatLng) async {
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
  double? distance;

  CardItem(this.animalName, this.severity, this.location);
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
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        cardItem.animalName,
                        style: const TextStyle(fontSize: 24.0, color: Colors.black),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        cardItem.location,
                        style: const TextStyle(fontSize: 18.0, color: Colors.black),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        cardItem.severity,
                        style: const TextStyle(fontSize: 18.0, color: Colors.black),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Distance: ${cardItem.distance?.toStringAsFixed(2)} meters',
                        style: const TextStyle(fontSize: 18.0, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
