import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/utils/constants.dart';
import 'package:permission_handler/permission_handler.dart';

class NewLivenessCheckPage extends StatefulWidget {
  const NewLivenessCheckPage({super.key});

  @override
  State<NewLivenessCheckPage> createState() => _NewLivenessCheckPageState();
}

class _NewLivenessCheckPageState extends State<NewLivenessCheckPage>
    with WidgetsBindingObserver {
  AppLifecycleState? _state;

  CameraDescription? selectedCamera;
  CameraController? cameraController;
  bool hasPermissions = false;
  bool isLoading = false;
  bool hasError = false;
  final FaceDetector faceDetector = FaceDetector(
    options: FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
        minFaceSize: 0.2,
        performanceMode: FaceDetectorMode.fast),
  );
  bool shouldCloseOnResume = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopLiveFeed();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _state = state;
    });
    debugPrint('Lifecycle changed: $state');
    final CameraController? cameraController2 = cameraController;

    // App state changed before we got the chance to initialize.
    if (cameraController2 == null || !cameraController2.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      // _stopLiveFeed();
      // cameraController!.dispose();
      if (mounted) cameraController!.dispose();

      // Navigator.pop(context);

      shouldCloseOnResume = true; // mark for closure
    }

    if (state == AppLifecycleState.resumed) {
      // if (shouldCloseOnResume) {
      //   shouldCloseOnResume = false;
      if (mounted)
        //  Navigator.pop(context);
        // } else {
        _initialize();
      // }
    }
  }

  void _initialize() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _askForPermissions();
      // await _getAvailableCameras();
      await _startLiveFeed();
    } catch (_) {
      setState(() {
        hasError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _askForPermissions() async {
    PermissionStatus permissionStatus;
    bool newPermissionStatus = false;

    permissionStatus = await Permission.camera.status;
    if (permissionStatus.isPermanentlyDenied) {
      newPermissionStatus = false;
    } else if (permissionStatus.isGranted || permissionStatus.isLimited) {
      newPermissionStatus = true;
    } else if (permissionStatus.isDenied) {
      newPermissionStatus = await Permission.camera.request().isGranted;
    }

    setState(() {
      hasPermissions = newPermissionStatus;
    });
  }

  // Future<void> _getAvailableCameras() async {
  //   final cameras = await availableCameras();
  //   setState(() {
  //     selectedCamera = cameras.firstWhere(
  //       (c) => c.lensDirection == CameraLensDirection.front,
  //     );
  //   });
  // }

  Future<void> _startLiveFeed() async {
    final cameras = await availableCameras();
    setState(() {
      selectedCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
      );
    });
    if (selectedCamera == null) {
      setState(() {
        hasError = true;
      });
      return;
    }

    cameraController = CameraController(
      selectedCamera!,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await cameraController!.initialize();
    try {
      cameraController!.startImageStream((CameraImage image) {
        detectFaces(image).then((_) {
          // isDetecting = false;
        });
      });
    } on CameraException catch (e) {
      CustomSnackBar.showErrorSnackBar('CameraException:${e.description}');

      // debugPrint('CameraException when starting stream: ${e.description}');
    }
  }

  bool smilecheckbox = false;
  Future<void> detectFaces(CameraImage image) async {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();
      final rotation = InputImageRotationValue.fromRawValue(
            cameraController!.description.sensorOrientation,
          ) ??
          InputImageRotation.rotation0deg;

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );
      final faces = await faceDetector.processImage(inputImage);

      if (!mounted) return;

      if (faces.isNotEmpty) {
        final face = faces.first;
        if (hasEyesOpen(face) && isSmilling(face)) {
          setState(() {
            smilecheckbox = true;
          });
          await Future.delayed(const Duration(milliseconds: 1000));
          XFile image = await cameraController!.takePicture();
          Navigator.pop(context, image);
        }
      }
    } catch (e) {
      debugPrint('Error in face detection: $e');
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
  bool isSmilling(Face data) =>
      data.smilingProbability != null && data.smilingProbability! > 0.6;

  Future _stopLiveFeed() async {
    if (cameraController!.value.isStreamingImages) {
      await cameraController!.stopImageStream();
    }
    // await cameraController!.stopImageStream();
    await cameraController!.dispose();
    await faceDetector.close();

    // cameraController;
  }

  Widget display() {
    if (isLoading ||
        !(cameraController!.value.isInitialized) ||
        cameraController == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!cameraController!.value.isInitialized ||
        cameraController!.value.isStreamingImages == false) {
      return const Center(child: Text('Camera not available'));
    }
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.grey[300],
            padding: const EdgeInsets.all(10),
            child: CameraPreview(
              cameraController!,
            ),
          ),
          Positioned(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'Blink and Smile',
                style: theme.textTheme.titleLarge!,
              ),
              Checkbox(value: smilecheckbox, onChanged: (value) {})
            ],
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Constants.themeGradients[0],
          title: Text(
            "Liveliness Check",
            // "MB-005-00-16",
            style: Constants.appbarTitleTextStyle,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: display(),
      ),
    );
  }
}
