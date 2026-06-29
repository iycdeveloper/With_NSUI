import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerCustom extends StatefulWidget {
  YoutubePlayerCustom({Key? key, required this.videoId}) : super(key: key);
  final String videoId;

  @override
  _YoutubePlayerCustomState createState() => _YoutubePlayerCustomState();
}

class _YoutubePlayerCustomState extends State<YoutubePlayerCustom> {
  YoutubePlayerController? _ytbPlayerController;

  // List<YoutubeModel> videosList = [
  //   YoutubeModel(id: 1, youtubeId: 'jA14r2ujQ7s'),
  //   YoutubeModel(id: 2, youtubeId: 'UQGoVB_zMYQ'),
  //   YoutubeModel(id: 3, youtubeId: 'FLcRb289uEM'),
  //   YoutubeModel(id: 4, youtubeId: 'g2nMKzhkvxw'),
  //   YoutubeModel(id: 5, youtubeId: 'qoDPvFAk2Vg'),
  // ];
  late String youtubeId;
  @override
  void initState() {
    super.initState();

    youtubeId = widget.videoId;
    _setOrientation([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
//TODO
    _ytbPlayerController = YoutubePlayerController(
      // initialVideoId: widget.videoId,
      // params: YoutubePlayerParams(
      //   showFullscreenButton: true,
      //   autoPlay: true,
      // ),
    );

    //_ytbPlayerController!.play();
  }

  @override
  void dispose() {
    super.dispose();

    _setOrientation([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _ytbPlayerController?.close();
  }

  _setOrientation(List<DeviceOrientation> orientations) {
    SystemChrome.setPreferredOrientations(orientations);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildYtbView(),
          ],
        ),
      ),
    );
  }

  _buildYtbView() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child:
          //TODO
      // _ytbPlayerController != null
      //     ? YoutubePlayerIFrame(
      //         controller: _ytbPlayerController,
      //       )
      //     :
      Center(child: CircularProgressIndicator()),
    );
  }
}
