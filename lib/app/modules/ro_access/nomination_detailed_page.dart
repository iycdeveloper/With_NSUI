import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/modules/ro_access/membership/membership_ro_controller.dart';
import 'package:iyc/app/modules/ro_access/ro_access_controller.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/app/widgets/custom_outlined_button.dart';
import 'package:iyc/screens/widgets/custom_button.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:widget_zoom/widget_zoom.dart';

class NominationDetailScreen extends StatelessWidget {
  const NominationDetailScreen();
  @override
  Widget build(BuildContext context) {
    dynamic nominationDetail = Get.arguments;

    return GetBuilder<ROAccessController>(builder: (logic) {
      return SafeArea(
        child: logic.showVideo
            ? VideoPlayerExample(videoUrl: nominationDetail['video'])
            : Scaffold(
                appBar: CustomAppBar(
                    leadingWidth: 44.h,
                    leading: AppbarImage(
                        onTap: Get.back,
                        svgPath: ImageConstant.imgBiarrowleftIndigo800,
                        margin: EdgeInsets.only(
                            left: 20.h, top: 15.v, bottom: 15.v)),
                    title: AppbarSubtitle1(
                        text: '${nominationDetail['member_id']}',
                        margin: EdgeInsets.only(left: 12.h)),
                    styleType: Style.standard),
                bottomSheet: Container(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => showAlertDialog(
                              'Accept', '${nominationDetail['member_id']}'),
                          child: Container(
                            color: Colors.green.withOpacity(0.7),
                            child: Center(
                                child: Text(
                              'Accept',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => showAlertDialog(
                              'On Hold', '${nominationDetail['member_id']}'),
                          child: Container(
                            color: Colors.yellow.withOpacity(0.7),
                            child: Center(
                                child: Text(
                              'On Hold',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => showAlertDialog(
                              'Reject', '${nominationDetail['member_id']}'),
                          child: Container(
                            color: Colors.red.withOpacity(0.7),
                            child: Center(
                                child: Text(
                              'Reject',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      detailTile(
                          '${'${nominationDetail['contesting_for'] ?? '--'}'}',
                          'Contesting For'),
                      detailTile(
                          '${'${nominationDetail['first_name'] ?? '--'}'}',
                          'First Name'),
                      detailTile(
                          '${'${nominationDetail['last_name'] ?? '--'}'}',
                          'Last Name'),
                      detailTile('${'${nominationDetail['mobile'] ?? '--'}'}',
                          'mobile'),
                      detailTile(
                          '${nominationDetail['gender'] == "M" ? 'Male' : 'Female'}',
                          'Gender'),
                      detailTile(
                          '${logic.stateList!.firstWhere((element) => element.stateCode == '${nominationDetail['state']}').name}',
                          'State'),
                      detailTile('${'${nominationDetail['ds_name'] ?? '--'}'}',
                          'District'),
                      detailTile('${'${nominationDetail['as_name'] ?? '--'}'}',
                          'Assembly'),
                      detailTile(
                          '${'${nominationDetail['mandalam_name'] ?? '--'}'}',
                          'Mandalam'),
                      detailTile(
                          '${logic.category[nominationDetail['category']] ?? '--'}',
                          'Category'),
                      if (nominationDetail['caste_certificate_doc'] != null &&
                          nominationDetail['caste_certificate_doc'] != "")
                        docTile(
                            '${'${nominationDetail['caste_certificate_doc'] ?? ''}'}',
                            'Category'),
                      docTile(
                          '${'${nominationDetail['photo'] ?? ''}'}', 'Photo'),
                      docTile('${'${nominationDetail['id_front'] ?? ''}'}',
                          'ID Front View'),
                      docTile('${'${nominationDetail['id_back'] ?? ''}'}',
                          'ID Back View'),
                      docTile(
                          '${'${nominationDetail['video'] ?? ''}'}', 'Video',
                          isVideo: true),
                      docTile('${'${nominationDetail['dob_proof_doc'] ?? ''}'}',
                          'DOB Proof Doc'),
                      detailTile(
                          '${'${nominationDetail['criminal_cases'] ?? '--'}'}',
                          'Criminal Case'),
                      if ('${'${nominationDetail['criminal_cases'] ?? '--'}'}' ==
                          'Yes')
                        docTile(
                            '${'${nominationDetail['CriminalCaseDoc'] ?? ''}'}',
                            'Criminal Case Doc'),
                      SizedBox(
                        height: 80,
                      )
                    ],
                  ),
                ),
              ),
      );
    });
  }

  Widget detailTile(String title, String subTitle) => Container(
        margin: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(width: 1, color: Colors.lightBlue.withOpacity(0.1)),
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(color: Colors.black),
          ),
          subtitle: Text(subTitle),
        ),
      );

  Widget docTile(String url, String title, {bool isVideo = false}) => InkWell(
        onTap: () {
          if (url.isEmpty) {
            CustomSnackBar.showErrorSnackBar('Doc not available');
            return;
          }
          if (isVideo) {
            Get.find<ROAccessController>().updateShowVideo(true);
            return;
          }
          showModalBottomSheet<void>(
            context: Get.context!,
            isDismissible: false,
            // useSafeArea: false,
            enableDrag: false,
            useRootNavigator: true,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return InteractiveViewer(
                child: Container(
                    margin: EdgeInsets.only(top: 100),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24))),
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: ListView(children: [
                      Container(
                          decoration: BoxDecoration(
                              // color: Colors.white,
                              color: appTheme.indigo800,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24))),
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.h, vertical: 17.v),
                          child: Text(
                            title,
                          )),

                      WidgetZoom(
                        heroAnimationTag: 'tag',
                        zoomWidget: Image.network(
                          url,
                          // width: 150,
                          // height: 150,
                        ),
                      ),

                      //below one is old
                      // CustomImageView(
                      //   url: url,
                      //   // color: Colors.black,
                      // ),
                      SizedBox(height: 15.v),
                      CustomOutlinedButton(
                          width: 220.h,
                          height: 40.h,
                          text: "Back".toUpperCase(),
                          buttonStyle: CustomButtonStyles.outlinePrimary,
                          onTap: Get.back),
                      SizedBox(height: 5.v)
                    ])),
              );
            },
          );
        },
        child: Container(
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(width: 1, color: Colors.lightBlue.withOpacity(0.1)),
          ),
          child: ListTile(
            title: Text(
              title,
              style: TextStyle(color: Colors.black),
            ),
            trailing: Text('View'),
          ),
        ),
      );

  void showAlertDialog(String title, String memberId) async {
    return showCupertinoDialog(
      context: Get.context!,
      builder: (context) => GetBuilder<ROAccessController>(builder: (logic) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: CupertinoAlertDialog(
            title: Text(title),
            content: Column(
              children: [
                Text('Are you sure?'),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Remark',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.grey, // Border color
                        width: 2.0, // Border width
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.black, // Border color when focused
                        width: 2.0, // Border width when focused
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    Log.printDLog(value);
                    logic.updateRemark(value);
                  },
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Cancel'),
                onPressed: Get.back,
              ),
              CupertinoDialogAction(
                child: Text(title),
                onPressed: () {
                  Get.back();
                  logic.updateNominationStatus(
                      logic.roId,
                      memberId,
                      {
                        'Accept': 'ACCEPT',
                        'On Hold': 'ONHOLD',
                        'Reject': 'REJECT'
                      }[title]!);
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ZoomableNetworkImage extends StatelessWidget {
  final String imageUrl;

  const ZoomableNetworkImage({Key? key, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: Image.network(
        imageUrl,
        // You can add other image properties here, like fit, width, height, etc.
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return const Center(child: Icon(Icons.error));
        },
      ),
    );
  }
}

class VideoPlayerExample extends StatefulWidget {
  const VideoPlayerExample({Key? key, required this.videoUrl})
      : super(key: key);
  final String videoUrl;
  @override
  State<VideoPlayerExample> createState() => _VideoPlayerExampleState();
}

class _VideoPlayerExampleState extends State<VideoPlayerExample> {
  late VideoPlayerController controller;
  // String videoUrl =
  //     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(widget.videoUrl);

    controller.addListener(() {
      setState(() {});
    });
    controller.setLooping(true);
    controller.initialize().then((_) => setState(() {}));
    controller.play();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: SizedBox(
        height: 60,
        child: CustomButton(
            labelText: 'Back',
            onTap: () {
              Get.find<ROAccessController>().updateShowVideo(false);
            }),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            if (controller.value.isPlaying) {
              controller.pause();
            } else {
              controller.play();
            }
          },
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
        ),
      ),
    );
  }
}
