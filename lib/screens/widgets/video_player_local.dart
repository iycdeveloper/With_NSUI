import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iyc/screens/widgets/button/next_prev_button.dart';
import 'package:video_player/video_player.dart';

import 'u_round_button.dart';

class VideoPlayerLocal extends StatefulWidget {
  final File? videoFile;

  const VideoPlayerLocal({required this.videoFile, Key? key}) : super(key: key);

  @override
  _VideoPlayerLocalState createState() => _VideoPlayerLocalState();
}

class _VideoPlayerLocalState extends State<VideoPlayerLocal> {
  VideoPlayerController? videoController;
  File? _videoFile;
  bool videoPlay = false;
  @override
  void initState() {
    _videoFile = widget.videoFile;
    _startVideoPlayer();
    super.initState();
  }

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }

  Future<void> _startVideoPlayer() async {
    if (_videoFile != null) {
      videoController = VideoPlayerController.file(_videoFile!);
      await videoController!.initialize().then((value) => {
            videoController!.addListener(() {
              //custom Listner
              setState(() {
                if (!videoController!.value.isPlaying &&
                    videoController!.value.isInitialized &&
                    (videoController!.value.duration ==
                        videoController!.value.position)) {
                  //checking the duration and position every time
                  //Video Completed//
                  setState(() {
                    videoPlay = false;
                  });
                }
              });
            })
          });
      await videoController!.setLooping(false);
      await videoController!.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: videoController!.value.isInitialized
          ? () async {
              //await videoController!.play();
            }
          : null,
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: videoController != null && videoController!.value.isInitialized
            ? AspectRatio(
                aspectRatio: videoController!.value.aspectRatio,
                child: Stack(alignment: Alignment.center, children: [
                  VideoPlayer(videoController!),
                  videoController!.value.isPlaying
                      ? SizedBox()
                      : NextPrevButton(
                          width: 100,
                          title: "Close",
                          onTap: () => Navigator.pop(context)),
                ]),
              )
            : Container(),
      ),
    );
  }
}
