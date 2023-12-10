import 'package:flutter/material.dart';
import 'home_page.dart';

class verify extends StatefulWidget {
  const verify({super.key});

  @override
  State<verify> createState() => _verifyState();
}

class _verifyState extends State<verify> {
  TextEditingController _pdfController = TextEditingController();
  void _showSubmitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Submit Confirmation'),
          content: Text('Do you want to submit the PDF?'),
          actions: [
            TextButton(
              onPressed: () {
                // Navigate to the sign-up page when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage()), // Replace with your sign-up page widget
                );
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
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
          'Submit a proof',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Submit in form of File(preferaably pdf)'),
                      content: Column(
                        children: [
                          const Text('Please enter the File path:'),
                          TextField(
                            controller: _pdfController,
                            decoration: const InputDecoration(
                              labelText: 'File Path',
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Implement PDF validation logic
                            // You can access the entered PDF path using _pdfController.text
                            Navigator.pop(context);
                          },
                          child: const Text('Okay'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Submission'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showSubmitDialog();
              },
              child: const Text('Final Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
