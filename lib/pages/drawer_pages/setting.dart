import 'package:flutter/material.dart';
import 'package:demo/utils/routes.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  double _volume = 50.0;
  double _brightness = 50.0;
  bool _isFeatureEnabled = true;
  String _selectedTheme = 'Light';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text('Volume'),
              subtitle: Text('Adjust the volume level'),
              trailing: Slider(
                value: _volume,
                min: 0,
                max: 100,
                onChanged: (value) {
                  setState(() {
                    _volume = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Brightness'),
              subtitle: Text('Adjust the screen brightness'),
              trailing: Slider(
                value: _brightness,
                min: 0,
                max: 100,
                onChanged: (value) {
                  setState(() {
                    _brightness = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Enable Feature'),
              subtitle: Text('Toggle the feature on/off'),
              trailing: Switch(
                value: _isFeatureEnabled,
                onChanged: (value) {
                  setState(() {
                    _isFeatureEnabled = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Theme'),
              subtitle: Text('Select the app theme'),
              trailing: DropdownButton<String>(
                value: _selectedTheme,
                onChanged: (String? value) {
                  setState(() {
                    _selectedTheme = value!;
                  });
                },
                items: ['Light', 'Dark', 'System'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
              },
              child: const Text('Go Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
