import 'package:flutter/material.dart';
import 'package:demo/utils/routes.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to BlueResq!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'BlueResq is dedicated to helping animal rescue efforts. '
              'Our app connects animal lovers and volunteers, making it '
              'easier to locate and assist animals in need. We believe in '
              'creating a community that cares for the well-being of all '
              'living creatures.',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),

            Text(
              'About Blue Cross:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Blue Cross is an animal welfare organization that works '
              'tirelessly to provide care, medical treatment, and support '
              'for animals in distress. They play a crucial role in '
              'rescuing and rehabilitating animals, promoting animal '
              'welfare awareness, and advocating for the rights of animals.',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
                },
                child: const Text('Go Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
