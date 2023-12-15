import 'package:demo/pages/Active_cards.dart';
import 'package:demo/pages/drawer_pages/drawer.dart';

import 'package:flutter/material.dart';

//First letter of a function is always in small case
class HomePage extends StatelessWidget {
  final t = 15;

  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    //context keyword specifies the location of every widget inside the build() method
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Blue ResQ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        titleSpacing: 105,
      ),
      /*body: ListView.builder(
        itemCount: CatalogModel.items.length,
        itemBuilder: (context, index) {
          return ItemWidget(
            item: CatalogModel.items[index],
          );
        },
      ),*/
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const CardPage()), // Navigate to ActiveCasesPage
                  );
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue, // Customize the border color
                      width: 2.0, // Customize the border width
                    ),
                    borderRadius: BorderRadius.circular(
                        8.0), // Customize the border radius
                  ),
                  child: const Card(
                    elevation: 0, // Remove card elevation
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active Cases',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Total Cases: 1000',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Recovered Cases: 800',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Active Cases: 200',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green, // Customize the border color
                    width: 2.0, // Customize the border width
                  ),
                  borderRadius:
                      BorderRadius.circular(8.0), // Customize the border radius
                ),
                child: const Card(
                  elevation: 0, // Remove card elevation
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How to Use',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'How to Use Your App:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '1. Step one...',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '2. Step two...',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.orange, // Customize the border color
                    width: 2.0, // Customize the border width
                  ),
                  borderRadius:
                      BorderRadius.circular(8.0), // Customize the border radius
                ),
                child: const Card(
                  elevation: 0, // Remove card elevation
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Training/Workshops',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Upcoming Workshops:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '- Workshop 1: Date and Time',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '- Workshop 2: Date and Time',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red, // Customize the border color
                    width: 2.0, // Customize the border width
                  ),
                  borderRadius:
                      BorderRadius.circular(8.0), // Customize the border radius
                ),
                child: const Card(
                  elevation: 0, // Remove card elevation
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rewards and Stats',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Total Ice-cream Collected: 500',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          'Total Thanks Recieved',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer:
          const MyDrawer(), // Listview only renders items visible on the screen. means it presents a continios scrollable view of the items
    );
  }
}
