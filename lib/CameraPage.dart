import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:vibration/vibration.dart';

  CameraController? _cameraController;
  late Future<void> _initializeControllerFuture;
  final String apiEndpoint = 'https://small.engineer';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool isAlertOn = false;
  bool isIndoor = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
    );
    await _cameraController!.initialize();
    setState(() {});
  }

  Future<void> takePictureAndPost() async {
    if (!_cameraController!.value.isInitialized) {
      Fluttertoast.showToast(msg: 'Camera is not initialized.');
      return;
    }

    try {
      final image = await _cameraController!.takePicture();
      final apiResponse = await sendFrameToAPI(File(image.path));
      Fluttertoast.showToast(msg: apiResponse);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error capturing picture: $e');
    }
  }

  Future<String> sendFrameToAPI(File frame) async {
    try {
      final bytes = await frame.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(apiEndpoint),
        body: jsonEncode({'image': base64Image}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final apiResponse = jsonResponse['text'] as String;
        return apiResponse;
      } else {
        return 'API request failed with status code: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error sending frame to API: $e';
    }
  }

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
