import 'package:demo/pages/Sample_map_page.dart';
import 'package:flutter/material.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Active Cases',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: const Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CardItem('animal name', 'Location', 'severe'),
              CardItem('animal name', 'Location', 'severe'),
              CardItem('animal name', 'Location', 'mild'),
              CardItem('animal name', 'Location', 'severe'),
              CardItem('animal name', 'Location', 'severe'),
              CardItem('animal name', 'Location', 'mild'),
              CardItem('animal name', 'Location', 'severe'),
              CardItem('animal name', 'Location', 'mild'),
              CardItem('animal name', 'Location', 'severe'),
              CardItem('animal name', 'Location', 'mild'),
              CardItem('animal name', 'Location', 'severe'),
            ],
          ),
        ),
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final String animal;
  final String location;
  final String condition;

  const CardItem(this.animal, this.location, this.condition, {super.key});

  @override
  Widget build(BuildContext context) {
    // Define cardColor as white
    Color cardColor = Colors.white;

    // Define stripColor based on condition
    Color stripColor = condition == 'mild' ? Colors.yellow : Colors.red;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const MapPage()), // Navigate to ActiveCasesPage
        );
      },
      child: Row(
        children: [
          Expanded(
            child: Card(
              elevation: 5.0, // gives elevation to the card
              margin: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor, // gives card background color to white
                  border: Border(
                    left: BorderSide(
                      color:
                          stripColor, // gives left border color based on condition
                      width: 4.0, // this can be changed
                    ),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        animal,
                        style: const TextStyle(fontSize: 24.0, color: Colors.black),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        location,
                        style: const TextStyle(fontSize: 18.0, color: Colors.black),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        condition,
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
 // in the original code nextpage should be rishi's code so replace it