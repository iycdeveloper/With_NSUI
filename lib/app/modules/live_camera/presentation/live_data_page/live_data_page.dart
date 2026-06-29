import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:gmlkit_liveness/presentation/widgets/custom_face_detector/custom_face_detector.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:iyc/app/modules/live_camera/presentation/widgets/custom_face_detector/custom_face_detector.dart';
import 'package:permission_handler/permission_handler.dart';

class LiveDataPage extends StatefulWidget {
  const LiveDataPage({super.key});

  @override
  State<LiveDataPage> createState() => _LiveDataPageState();
}

class _LiveDataPageState extends State<LiveDataPage> {
  List<double> eulerAngles = [0, 0, 0];
  int lastAnalysisTimestamp = DateTime.now().millisecondsSinceEpoch;
  List<int> analysisLatencyStack = [];
  Face? faceData;

  List<List<double>> anglesData = [];

  late CameraController cameraController;


 @override
  void initState() {
    super.initState();
    // initializeCamera();
    // challengeActions.shuffle();
  }

  // Future<void> initializeCamera() async {
  //   var status = await Permission.camera.request();
  //   if (!status.isGranted) {
  //     throw Exception('Camera permission not granted');
  //   }
  //   final cameras = await availableCameras();
  //   final frontCamera = cameras.firstWhere(
  //       (camera) => camera.lensDirection == CameraLensDirection.front);
  //   cameraController = CameraController(frontCamera, ResolutionPreset.high,
  //       enableAudio: false);
  //   await cameraController.initialize();
  // }

  _onAnalysisData((InputImage, List<Face>) analysisData) {
    final face = analysisData.$2[0];
    if (!mounted) return;

    setState(() {
      analysisLatencyStack
          .add(DateTime.now().millisecondsSinceEpoch - lastAnalysisTimestamp);

      lastAnalysisTimestamp = DateTime.now().millisecondsSinceEpoch;
      if (analysisLatencyStack.length > 20) analysisLatencyStack.removeAt(0);

      faceData = analysisData.$2[0];
      eulerAngles = [
        face.headEulerAngleX!,
        face.headEulerAngleY!,
        face.headEulerAngleZ!
      ];

      currentEmotion();
      anglesData.add(eulerAngles);
      if (anglesData.length > 25) anglesData.removeAt(0);
    });
  }

  double get analysisLatency {
    return analysisLatencyStack.isNotEmpty
        ? analysisLatencyStack.reduce((prev, next) => prev + next) /
            analysisLatencyStack.length
        : 0;
  }

  currentEmotion() {
    if (hasEyesOpen(faceData!) && isSmilling(faceData!)) {
      setState(() {
        smilecheckbox = true;
      });
      return "Smile";
    } else if (isFaceTurnLeft(faceData!)) {
      setState(() {
        leftturncheckbox = true;
      });
      return "Left";
    } else if (isFaceTurnRight(faceData!)) {
      setState(() {
        if (!rightturncheckbox) {
          rightturncheckbox = true;
        }
      });
      return "Right";
    }
  }

  bool isBlink(Face data) =>
      (data.leftEyeOpenProbability != null &&
          data.leftEyeOpenProbability! < 0.3) ||
      (data.rightEyeOpenProbability != null &&
          data.rightEyeOpenProbability! < 0.3);
  bool hasEyesOpen(Face data) => isRightEyeOpen(data) && isLeftEyeOpen(data);
  bool isRightEyeOpen(Face data) =>
      data.rightEyeOpenProbability != null &&
      data.rightEyeOpenProbability! > 0.6;

  bool isLeftEyeOpen(Face data) =>
      data.leftEyeOpenProbability != null && data.leftEyeOpenProbability! > 0.6;
  bool isFaceTurnLeft(Face data) =>
      data.headEulerAngleY != null && data.headEulerAngleY! > 10;
  bool isSmilling(Face data) =>
      data.smilingProbability != null && data.smilingProbability! > 0.6;
  bool isFaceTurnRight(Face data) =>
      data.headEulerAngleY != null && data.headEulerAngleY! < -10;

  bool smilecheckbox = false;
  bool leftturncheckbox = false;
  bool rightturncheckbox = false;
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live data"),
      ),
      floatingActionButton:
          smilecheckbox && leftturncheckbox && rightturncheckbox
              ? IconButton(
                  iconSize: 60,
                  onPressed: () async {
                    
                    image = await cameraController.takePicture();

                    Navigator.pop(context, image);
                  },
                  icon: const Icon(Icons.camera))
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          CustomFaceDetector(
            onCameraControllerAvailable: (value){
              setState(() {
                cameraController=value;
              });
            },
            onAnalysisData: _onAnalysisData),
          // Positioned(
          //   top: 24,
          //   left: 24,
          //   child: Row(
          //     children: [
          //       Text(
          //         "${analysisLatency.toStringAsFixed(2)} ms \n${faceData != null ? faceData!.headEulerAngleY! : ''}",
          //         style: GoogleFonts.roboto(
          //           fontSize: 16,
          //           fontWeight: FontWeight.bold,
          //           color: const Color.fromARGB(255, 35, 45, 34),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Positioned(
            top: 20,
            left: 24,
            child: Row(
              children: [
                Row(
                  children: [
                    Checkbox(
                        checkColor: Colors.green,
                        value: smilecheckbox,
                        onChanged: (value) {}),
                    const Text('Smile')
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        checkColor: Colors.green,
                        value: leftturncheckbox,
                        onChanged: (value) {}),
                    const Text('Turn Left')
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        checkColor: Colors.green,
                        value: rightturncheckbox,
                        onChanged: (value) {}),
                    const Text('Trun Right')
                  ],
                ),
                // Text(
                //   currentEmotion,
                //   style: const TextStyle(fontSize: 24),
                // ),
              ],
            ),
            // EmotionDisplay(faceData: faceData),
          ),
          // Positioned(
          //   top: 24,
          //   right: 24,
          //   child: AnglesDisplay(angles: eulerAngles),
          // ),
          // Positioned(
          //   bottom: 24,
          //   right: 16,
          //   child: AnglesChart(
          //     anglesData: anglesData,
          //   ),
          // ),
        ],
      ),
    );
  }
}
