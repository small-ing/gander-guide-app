import 'package:flutter/material.dart';
import 'HomePage.dart'; // Import the HomePage class
// import 'CameraPage.dart'; // Import the CameraPage class
// import 'InfoPage.dart'; // Import the InfoPage class

void main() {
  runApp(GanderGuide());
}

class GanderGuide extends StatelessWidget {
  const GanderGuide({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF14141C)),
      home: HomePage(), // Set the HomePage as the initial route
    );
  }
}