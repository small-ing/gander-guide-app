import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:math' as math;
import 'dart:async';
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
  bool isIndoor = true;
  int _vibrationDuration = 0;
  int _vibrationAmplitude = 0; 
  Uint8List imageBytes = Uint8List(0);


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
      imageFormatGroup: ImageFormatGroup.jpeg,
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
      debugPrint('Taking picture...');
      final image = await _cameraController!.takePicture();
      final apiResponse = await sendFrameToAPI(File(image.path));
      //debugPrint('JSON being returned: $apiResponse');
      if (!isAlertOn) {
        debugPrint('Vibrating...');
        bool? hasVibrator = await Vibration.hasVibrator();
        if (hasVibrator == true && _vibrationDuration > 0) {
          //debugPrint('Device has a vibrator');
          Vibration.vibrate(duration: _vibrationDuration, amplitude: _vibrationAmplitude);
        } else {
          debugPrint('Device does not have a vibrator or duration 0');
        }

      }
      imageBytes = base64Decode(apiResponse);
      setState(() {});
      debugPrint("State updated");
      
      //Fluttertoast.showToast(msg: apiResponse);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error capturing picture or Vibrating phone: $e', toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<String> sendFrameToAPI(File frame) async {
    try {
      debugPrint('Sending frame to API...');
      final bytes = await frame.readAsBytes();
      final base64Image = base64Encode(bytes);
      String vibe = 'false';
      String indoor = 'false';
      if (!isAlertOn) {
        vibe = 'true';
      }
      if (isIndoor) {
        indoor = 'true';
      }
      debugPrint('Sending frame to API at $apiEndpoint');
      final response = await http.post(
        Uri.parse(apiEndpoint),
        body: jsonEncode({'image': base64Image, 'vibrate': vibe, 'indoor': indoor}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        debugPrint('API request returned 200 OK');
        final jsonResponse = jsonDecode(response.body);
        debugPrint('JSON response: $jsonResponse');
        _vibrationAmplitude = jsonResponse['amplitude'];
        _vibrationDuration = jsonResponse['duration'];
        return jsonResponse['image'];
      } else {
        debugPrint('API request failed with status code: ${response.statusCode}');
        return 'API request failed with status code: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error sending frame to API: $e';
    }
  }

Widget rotatedImage(Uint8List imageBytes) {
  if (imageBytes.isEmpty) return Container(); // Return an empty container if imageBytes is empty.

  return Transform.rotate(
    angle: 90 * math.pi / 180, // Rotate the image by -90 degrees (clockwise).
    child: Image.memory(imageBytes),
  );
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
                  debugPrint("Switching Vibrate to $state");
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
              value: isIndoor,
              textOn: 'Indoor',
              textOff: 'Outdoor',
              colorOn: Colors.blue,
              colorOff: Colors.yellow,
              iconOn: Icons.chair,
              iconOff: Icons.grass,
              textSize: 16,
              onChanged: (bool state) {
                setState(() {
                  debugPrint("Switching Indoors to $state");
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
              width: MediaQuery.of(context).size.width * 0.75,
              //height: 360,
              //width: 270,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey,
              ),
              child: FittedBox(
                child: rotatedImage(imageBytes),
                fit: BoxFit.cover,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                takePictureAndPost();
              },
              child: Text('Take Picture'),
            ),
          ],
        ),
      ),
    );
  }
}
