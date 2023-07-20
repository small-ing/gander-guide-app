import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:vibration/vibration.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool isAlertOn = false;
  bool isIndoor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Verbal/Vibrate Switch
            LiteRollingSwitch(
              value: isAlertOn,
              textOn: 'Verbal',
              textOff: 'Vibrate',
              colorOn: Colors.green,
              colorOff: Colors.red,
              iconOn: Icons.volume_up,
              iconOff: Icons.vibration_outlined,
              textSize: 16,
              onChanged: (bool state) {
                setState(() {
                  isAlertOn = state;
                });
              },
              onTap: () {}, // Add an empty function or a custom action here
              onDoubleTap:
                  () {}, // Add an empty function or a custom action here
              onSwipe: () {}, // Add an empty function or a custom action here
            ),
            // Indoor/Outdoor Switch
            LiteRollingSwitch(
              value: isAlertOn,
              textOn: 'Indoor',
              textOff: 'Outdoor',
              colorOn: Colors.blue,
              colorOff: Colors.yellow,
              iconOn: Icons.chair,
              iconOff: Icons.grass,
              textSize: 16,
              onChanged: (bool state) {
                setState(() {
                  isAlertOn = state;
                });
              },
              onTap: () {}, // Add an empty function or a custom action here
              onDoubleTap:
                  () {}, // Add an empty function or a custom action here
              onSwipe: () {}, // Add an empty function or a custom action here
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: Colors.grey, // Customize the color of the square
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
