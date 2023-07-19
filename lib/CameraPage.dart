import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool isAlertOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LiteRollingSwitch(
              value: isAlertOn,
              textOn: 'Alerts On',
              textOff: 'Alerts Off',
              colorOn: Colors.green,
              colorOff: Colors.red,
              iconOn: Icons.notifications_active,
              iconOff: Icons.notifications_off,
              textSize: 16,
              onChanged: (bool state) {
                setState(() {
                  isAlertOn = state;
                });
              },
              onTap: () {}, // Add an empty function or a custom action here
              onDoubleTap: () {}, // Add an empty function or a custom action here
              onSwipe: () {}, // Add an empty function or a custom action here
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.grey, // Customize the color of the square
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}