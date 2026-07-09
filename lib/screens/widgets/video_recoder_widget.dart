import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:permission_handler/permission_handler.dart';

/// Records a short front-camera clip and returns the saved file via [callback].
///
/// Hardened to behave the same across Android/iOS devices:
///  * dynamically finds the front camera (falls back to any camera) instead of
///    a hard-coded index — the previous `cameras[1]` crashed on phones with a
///    different camera ordering or a single camera,
///  * requests camera **and** microphone permission (audio is on by default),
///  * auto-stops after [recordSeconds] with a live countdown,
///  * guards every async step against a disposed widget and cancels its timer,
///  * shows an error + retry state instead of a dead "LOADING" screen.
class VideoRecorderWidget extends StatefulWidget {
  final void Function(File) callback;

  /// Maximum clip length before it auto-stops. The user may also stop early by
  /// tapping the record button. Defaults to 10 seconds.
  final int recordSeconds;

  /// Prefer the selfie/front camera (falls back to any camera if absent).
  final bool forceFrontCamera;

  const VideoRecorderWidget({
    Key? key,
    required this.callback,
    this.recordSeconds = 10,
    this.forceFrontCamera = true,
  }) : super(key: key);

  @override
  State<VideoRecorderWidget> createState() => _VideoRecorderWidgetState();
}

enum _RecorderStatus {
  initializing,
  ready,
  recording,
  saving,
  permissionDenied,
  error,
}

class _VideoRecorderWidgetState extends State<VideoRecorderWidget>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  CameraDescription? _selectedCamera;

  _RecorderStatus _status = _RecorderStatus.initializing;
  String? _errorMessage;
  int _remaining = 0;
  Timer? _countdownTimer;
  bool _isReturning = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Keep the top status bar; hide the rest for a focused capture screen.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    _bootstrap();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _countdownTimer?.cancel();
    _controller?.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      // Release the camera when backgrounded so it can be re-acquired cleanly.
      _countdownTimer?.cancel();
      controller.dispose();
      _set(() => _status = _RecorderStatus.initializing);
    } else if (state == AppLifecycleState.resumed) {
      _initController();
    }
  }

  Future<void> _bootstrap() async {
    // Camera + microphone are both required for an audible identity clip.
    final statuses =
        await [Permission.camera, Permission.microphone].request();
    final granted = (statuses[Permission.camera]?.isGranted ?? false) &&
        (statuses[Permission.microphone]?.isGranted ?? false);
    if (!granted) {
      _set(() => _status = _RecorderStatus.permissionDenied);
      return;
    }
    await _initController();
  }

  Future<void> _initController() async {
    _set(() {
      _status = _RecorderStatus.initializing;
      _errorMessage = null;
    });

    try {
      if (_cameras.isEmpty) {
        _cameras = await availableCameras();
      }
      if (_cameras.isEmpty) {
        _set(() {
          _status = _RecorderStatus.error;
          _errorMessage = 'No camera found on this device.';
        });
        return;
      }

      // Prefer the front camera; gracefully fall back to whatever exists so a
      // missing/oddly-ordered camera can never throw a RangeError.
      _selectedCamera = widget.forceFrontCamera
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.first;

      final controller = CameraController(
        _selectedCamera!,
        ResolutionPreset.medium,
        enableAudio: true,
      );
      _controller = controller;

      await controller.initialize();
      if (!mounted) {
        controller.dispose();
        return;
      }
      _set(() => _status = _RecorderStatus.ready);
    } on CameraException catch (e) {
      _set(() {
        _status = _RecorderStatus.error;
        _errorMessage = e.description ?? 'Could not start the camera.';
      });
    } catch (_) {
      _set(() {
        _status = _RecorderStatus.error;
        _errorMessage = 'Could not start the camera.';
      });
    }
  }

  Future<void> _startRecording() async {
    final controller = _controller;
    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.isRecordingVideo) {
      return;
    }

    try {
      await controller.prepareForVideoRecording();
      await controller.startVideoRecording();
      if (!mounted) return;
      setState(() {
        _status = _RecorderStatus.recording;
        _remaining = widget.recordSeconds;
      });

      _countdownTimer?.cancel();
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        if (_remaining <= 1) {
          timer.cancel();
          _stopAndReturn();
        } else {
          setState(() => _remaining--);
        }
      });
    } on CameraException catch (e) {
      _set(() {
        _status = _RecorderStatus.error;
        _errorMessage = e.description ?? 'Recording failed. Please retry.';
      });
    }
  }

  Future<void> _stopAndReturn() async {
    final controller = _controller;
    if (_isReturning ||
        controller == null ||
        !controller.value.isRecordingVideo) {
      return;
    }
    _isReturning = true;
    _countdownTimer?.cancel();
    if (mounted) setState(() => _status = _RecorderStatus.saving);

    try {
      final XFile raw = await controller.stopVideoRecording();

      // Return the freshly recorded file as-is. The consumer (saveVideo) copies
      // it into app-documents storage and the final S3 object name
      // ("{batch}01.mp4") is applied at upload time. We deliberately do NOT
      // copy here: a copy into the same directory/name that saveVideo targets
      // would be a self-copy and truncate the file to 0 bytes.
      widget.callback(File(raw.path));
      if (mounted) Navigator.of(context).pop();
    } on CameraException catch (e) {
      _isReturning = false;
      _set(() {
        _status = _RecorderStatus.error;
        _errorMessage =
            e.description ?? 'Could not save the video. Please retry.';
      });
    } catch (_) {
      _isReturning = false;
      _set(() {
        _status = _RecorderStatus.error;
        _errorMessage = 'Could not save the video. Please retry.';
      });
    }
  }

  void _set(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_status) {
      case _RecorderStatus.permissionDenied:
        return _messageView(
          icon: Icons.videocam_off_rounded,
          message:
              'Camera and microphone permission are required to record your video.',
          actionLabel: 'Open settings',
          onAction: openAppSettings,
        );
      case _RecorderStatus.error:
        return _messageView(
          icon: Icons.error_outline_rounded,
          message: _errorMessage ?? 'Something went wrong. Please retry.',
          actionLabel: 'Retry',
          onAction: _initController,
        );
      case _RecorderStatus.initializing:
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      default:
        return _cameraView();
    }
  }

  Widget _cameraView() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: 1 / controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
        ),
        Positioned(
          top: 24,
          left: 24,
          right: 24,
          child: Text(
            _status == _RecorderStatus.recording
                ? 'Recording… clearly say your NAME'
                : 'Please clearly say your NAME in the video',
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ),
        Positioned(bottom: 40, child: _controls()),
      ],
    );
  }

  Widget _controls() {
    switch (_status) {
      case _RecorderStatus.recording:
        // Tap to stop early; otherwise it auto-stops at [recordSeconds].
        return URoundButton(
          title: 'Stop  $_remaining',
          width: 130,
          color: Colors.red,
          onTap: _stopAndReturn,
        );
      case _RecorderStatus.saving:
        return URoundButton(
          title: 'Saving…',
          width: 140,
          height: 50,
          color: Colors.green,
          onTap: () {},
        );
      case _RecorderStatus.ready:
      default:
        return URoundButton(
          title: 'Start',
          width: 100,
          onTap: _startRecording,
        );
    }
  }

  Widget _messageView({
    required IconData icon,
    required String message,
    required String actionLabel,
    required Future<void> Function() onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 56),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => onAction(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(actionLabel, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
