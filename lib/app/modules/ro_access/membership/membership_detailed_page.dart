import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/modules/ro_access/membership/membership_ro_controller.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/screens/widgets/custom_button.dart';
import 'package:video_player/video_player.dart';

class MembershipDetailScreen extends StatelessWidget {
  const MembershipDetailScreen();
  @override
  Widget build(BuildContext context) {
    dynamic nominationDetail = Get.arguments;
    return GetBuilder<MemberShipRoController>(builder: (logic) {
      return SafeArea(
        child: logic.showVideo
            ? VideoPlayerExample(videoUrl: nominationDetail['VIDEO'])
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
                              'Correct', '${nominationDetail['member_id']}'),
                          child: Container(
                            color: Colors.green.withOpacity(0.7),
                            child: const Center(
                                child: Text(
                              'Correct',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => showAlertDialog(
                              'Incorrect', '${nominationDetail['member_id']}'),
                          child: Container(
                            color: Colors.red.withOpacity(0.7),
                            child: const Center(
                                child: Text(
                              'Incorrect',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                body:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      detailTile(
                          '${'${nominationDetail['first_name'] ?? '--'}'}',
                          'First Name'),
                      detailTile(
                          '${'${nominationDetail['last_name'] ?? '--'}'}',
                          'Last Name'),
                      detailTile(
                          '${'${nominationDetail['relative_name'] ?? '--'}'}',
                          'Relative Name'),
                      detailTile(
                          '${'${nominationDetail['date_of_birth'] ?? '--'}'}',
                          'DOB'),
                      detailTile(
                          '${nominationDetail['sex_code'] == "M" ? 'Male' : 'Female'}',
                          'Gender'),
                      detailTile(
                          '${logic.category[nominationDetail['category_code']] ?? '--'}',
                          'Category'),
                      detailTile(logic.stateName, 'State'),
                      detailTile(logic.districtName, 'District'),
                      detailTile(logic.assemblyName,
                          'Assembly'),
                      if('${nominationDetail['mandalam_name']}' != '')
                      detailTile(
                          '${'${nominationDetail['mandalam_name'] ?? '--'}'}',
                          'Mandalam'),
                      docTile('${'${nominationDetail['PHOTO_LINK'] ?? ''}'}',
                          'Photo'),
                      docTile(
                          '${'${nominationDetail['VIDEO'] ?? ''}'}', 'Video',
                          isVideo: true),
                      detailTile('${'${nominationDetail['id_value'] ?? '--'}'}',
                          'ID Number'),
                      docTile('${'${nominationDetail['ID_FRONT'] ?? ''}'}',
                          'ID Front View'),
                      docTile('${'${nominationDetail['ID_BACK'] ?? ''}'}',
                          'ID Back View'),
                      detailTile('${'${nominationDetail['reason'] ?? '--'}'}',
                          'Reason'),
                      const SizedBox(
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
        margin: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(width: 1, color: Colors.lightBlue.withOpacity(0.1)),
        ),
        child: ListTile(
          title: Text(title),
          titleTextStyle: const TextStyle(
            color: Colors.black
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
            Get.find<MemberShipRoController>().updateShowVideo(true);
            return;
          }

          RoutesManagement.goToNetworkImageViewer('$title', '$url');

          // showModalBottomSheet<void>(
          //   context: Get.context!,
          //   isDismissible: false,
          //   enableDrag: false,
          //   useRootNavigator: true,
          //   isScrollControlled: true,
          //   builder: (BuildContext context) {
          //     return Container(
          //         margin: EdgeInsets.only(top: 100),
          //         decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.only(
          //                 topLeft: Radius.circular(24),
          //                 topRight: Radius.circular(24))),
          //         width: double.maxFinite,
          //         height: double.maxFinite,
          //         child: ListView(children: [
          //           Container(
          //               decoration: BoxDecoration(
          //                   // color: Colors.white,
          //                   color: appTheme.indigo800,
          //                   borderRadius: BorderRadius.only(
          //                       topLeft: Radius.circular(24),
          //                       topRight: Radius.circular(24))),
          //               width: double.maxFinite,
          //               padding: EdgeInsets.symmetric(
          //                   horizontal: 20.h, vertical: 17.v),
          //               child: Text(title,
          //                   style: CustomTextStyles
          //                       .titleMediumOnPrimaryContainer18)),
          //           CustomImageView(
          //             url: url,
          //           ),
          //           SizedBox(height: 15.v),
          //           CustomOutlinedButton(
          //               width: 220.h,
          //               height: 40.h,
          //               text: "Back".toUpperCase(),
          //               buttonStyle: CustomButtonStyles.outlinePrimary,
          //               onTap: Get.back),
          //           SizedBox(height: 5.v)
          //         ]));
          //   },
          // );
        },
        child: Container(
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(width: 1, color: Colors.lightBlue.withOpacity(0.1)),
          ),
          child: ListTile(
            title: Text(title),
             titleTextStyle: const TextStyle(
            color: Colors.black
          ),
          
            trailing: const Text('View'),
          ),
        ),
      );

  void showAlertDialog(String title, String memberId) async {
    return showCupertinoDialog(
      context: Get.context!,
      builder: (context) => GetBuilder<MemberShipRoController>(
        builder: (logic) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: CupertinoAlertDialog(
              title: Text(title),
              content: Column(
                children: [
                  const Text('Are you sure?'),
                  const SizedBox(height: 20,),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Remark',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                  ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey, // Border color
                          width: 2.0, // Border width
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.black, // Border color when focused
                          width: 2.0, // Border width when focused
                        ),
                      ),
                    ),
                    onChanged: (value){
                      logic.updateRemark(value);
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('Cancel'),
                  onPressed: Get.back,
                ),
                CupertinoDialogAction(
                  child: Text(title),
                  onPressed: () {
                    Get.back();
                    Get.find<MemberShipRoController>().updateNominationStatus(
                        Get.find<MemberShipRoController>().roId,
                        memberId,
                        {
                          'Correct': 'CORRECT',
                          'Incorrect': 'INCORRECT'
                        }[title]!);
                  },
                ),
              ],
            ),
          );
        }
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
              Get.find<MemberShipRoController>().updateShowVideo(false);
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
