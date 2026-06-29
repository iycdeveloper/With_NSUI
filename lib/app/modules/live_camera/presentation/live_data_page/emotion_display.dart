import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class EmotionDisplay extends StatefulWidget {
  final Face? faceData;

  const EmotionDisplay({super.key, required this.faceData});

  @override
  State<EmotionDisplay> createState() => _EmotionDisplayState();
}

class _EmotionDisplayState extends State<EmotionDisplay> {
  @override
  void initState() {
    super.initState();
    currentEmotion();
    // Your initialization code here
  }

  currentEmotion() {
    if (widget.faceData == null) {
      return "";
    }
    // else if (isWinking(faceData!)) {
    //   return "😉";
    // } else if (hasEyesOpen(faceData!) && isSmilling(faceData!)) {
    //   return "😀";
    // }
    else if (hasEyesOpen(widget.faceData!) && isSmilling(widget.faceData!)) {
      setState(() {
        smilecheckbox = true;
      });
      return "Smile";
    }
    // else if (!hasEyesOpen(faceData!)) {
    //   return "😴";
    // } else if (isBlink(faceData!)) {
    //   return "blink";
    // }
    else if (isFaceTurnLeft(widget.faceData!)) {
      setState(() {
        leftturncheckbox = true;
      });
      return "Left";
    } else if (isFaceTurnRight(widget.faceData!)) {
      setState(() {
        if (!rightturncheckbox) {
          rightturncheckbox = true;
        }
      });
      return "Right";
    } else {
      return "";
    }
  }

  bool smilecheckbox = false;

  bool leftturncheckbox = false;

  bool rightturncheckbox = false;

  bool isRightEyeOpen(Face data) =>
      data.rightEyeOpenProbability != null &&
      data.rightEyeOpenProbability! > 0.6;

  bool isLeftEyeOpen(Face data) =>
      data.leftEyeOpenProbability != null && data.leftEyeOpenProbability! > 0.6;

  bool hasEyesOpen(Face data) => isRightEyeOpen(data) && isLeftEyeOpen(data);

  bool isWinking(Face data) => isRightEyeOpen(data) ^ isLeftEyeOpen(data);

  bool isSmilling(Face data) =>
      data.smilingProbability != null && data.smilingProbability! > 0.6;

  bool isBlink(Face data) =>
      (data.leftEyeOpenProbability != null &&
          data.leftEyeOpenProbability! < 0.3) ||
      (data.rightEyeOpenProbability != null &&
          data.rightEyeOpenProbability! < 0.3);

  bool isFaceTurnLeft(Face data) =>
      data.headEulerAngleY != null && data.headEulerAngleY! > 10;

  bool isFaceTurnRight(Face data) =>
      data.headEulerAngleY != null && data.headEulerAngleY! < -10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Checkbox(checkColor: Colors.green, value: true, onChanged: (value) {}),
          Checkbox(
              checkColor: Colors.green,
              value: leftturncheckbox,
              onChanged: (value) {}),
          Checkbox(
              checkColor: Colors.green,
              value: rightturncheckbox,
              onChanged: (value) {}),
          // Text(
          //   currentEmotion,
          //   style: const TextStyle(fontSize: 24),
          // ),
        ],
      ),
    );
  }
}
