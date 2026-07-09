import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Plays back a locally-recorded clip inside a dialog.
///
/// Previously this crashed the moment the dialog opened because `build()`
/// dereferenced `videoController!` while it was still null (the controller is
/// only created after the async `initialize()` completes). It now shows a
/// loader until the controller is ready, rebuilds on init, and offers
/// tap-to-play/pause with a close button.
class VideoPlayerLocal extends StatefulWidget {
  final File? videoFile;

  const VideoPlayerLocal({required this.videoFile, Key? key}) : super(key: key);

  @override
  State<VideoPlayerLocal> createState() => _VideoPlayerLocalState();
}

class _VideoPlayerLocalState extends State<VideoPlayerLocal> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final file = widget.videoFile;
    if (file == null || !file.existsSync()) {
      _set(() => _error = true);
      return;
    }
    try {
      final controller = VideoPlayerController.file(file);
      _controller = controller;
      await controller.initialize();
      await controller.setLooping(true);
      if (!mounted) {
        controller.dispose();
        return;
      }
      controller.addListener(() {
        if (mounted) setState(() {});
      });
      setState(() => _initialized = true);
      await controller.play();
    } catch (_) {
      _set(() => _error = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    setState(() {
      controller.value.isPlaying ? controller.pause() : controller.play();
    });
  }

  void _set(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Container(
      width: MediaQuery.of(context).size.width * 0.82,
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: _error
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Unable to play this video.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          : (!_initialized || controller == null)
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: VideoPlayer(controller),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _togglePlay,
                      child: AnimatedOpacity(
                        opacity: controller.value.isPlaying ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          color: Colors.black26,
                          child: const Center(
                            child: Icon(Icons.play_arrow_rounded,
                                color: Colors.white, size: 64),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.black54, shape: BoxShape.circle),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
