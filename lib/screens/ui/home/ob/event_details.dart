import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iyc/model/api_model/events/event.dart';
import 'package:iyc/app/data/resources/repository/unit_management_repo.dart';
import 'package:iyc/app/data/resources/services/aws_upload_services.dart';
import 'package:iyc/app/data/resources/services/image_services.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/screens/widgets/button/next_prev_button.dart';
import 'package:iyc/utils/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as p;

import '../../../../di_container.dart';
import '../../../../model/api_model/base/api_response.dart';
import '../../../widgets/custom_snack_bar.dart';
import '../../../widgets/network_loading_dialog_box.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  String description = "";
  int count = 1;

  List<String> uploadedIndex = [];

  Future<bool> uploadDocumentTask(String path, String eventId, String count) async {
    String? result = await AwsUploadServices().uploadFile(
        file: File(path),
        destDir: "TASKS",
        filename: "${eventId}_${await LocalStorageServices().getMobile()}_$count.${path.split(".").last}");

    if (result is String)
      return true;
    else
      return false;
  }

  pickDocument(ImageSource imageSource, BuildContext context, String count) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final result = await ImageServices().pickImage(imageSource);
    if (result != null) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      File image;
      image = File(result.path);
      //  final myImagePath = '/storage/emulated/0/Download' ;
      final Directory extDir = await getApplicationDocumentsDirectory();
      String dirPath = extDir.path;
      final String filePath = '$dirPath/${p.basename(result.path)}';
      final File newImage = await image.copy(filePath);
      File _image = newImage;
      final uploadResult = await uploadDocumentTask(_image.path, widget.event.eventId!, count);
      if(uploadResult){
        setState(() {
          uploadedIndex.add(count);
        });
      }
      showCustomSnackBar(
          "Uploaded Image ${count} Successfully", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Program Details"),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NextPrevButton(
                  width: 120,
                  onTap: () async {
                              await Share.share(
                                '${widget.event.eventName}\n${widget.event.eventDescription}\n${widget.event.eventLocation}\n',
                                subject: widget.event.eventName,
                              );
                  },
                  title: "Share"),
              GestureDetector(
                onTap: () async {
                  String query =
                  Uri.encodeComponent(widget.event.eventLocation);
                  String googleUrl =
                      "https://www.google.com/maps/search/?api=1&query=${widget.event.lat},${widget.event.long}";

                  String mapUrl =
                      "google.navigation:q=${widget.event.lat},${widget.event.long}&mode=d";
                  //  "geo:${widget.event.lat},${widget.event.long}";
                  launchUrl(Uri.parse(googleUrl),
                      mode: LaunchMode.externalApplication);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.deepOrangeAccent.shade200)),
                  width: 120,
                  height: 50,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FaIcon(FontAwesomeIcons.locationArrow,
                          size: 40),
                      Text(
                        "Navigate",
                        style: TextStyle(
                            color: Colors.deepOrangeAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              NextPrevButton(
                  width: 120,
                  onTap: () async {
                    // if(uploadedIndex.length == 3){
                    //   showNetworkLoadingDialog(context,
                    //       willPopScope: false);
                    //   ApiResponse apiResponse =
                    //   await sl<UnitManagementRepo>()
                    //       .checkInEvent(widget.event.eventId!);
                    //   if (apiResponse.response != null &&
                    //       apiResponse.response!.statusCode == 200) {
                    //     final responseDecoded = jsonDecode(utf8.decode(
                    //         base64Decode(apiResponse.response!.data)));
                    //     print(responseDecoded);
                    //     if (responseDecoded['status'] == "SUCCESS") {
                    //       Navigator.of(context).pop();
                    //       Alert(
                    //         context: context,
                    //         type: AlertType.success,
                    //         title: "Check In Event Success",
                    //         buttons: [
                    //           DialogButton(
                    //             child: Text(
                    //               "OKAY",
                    //               style: TextStyle(
                    //                   color: Colors.white,
                    //                   fontSize: 20),
                    //             ),
                    //             onPressed: () async {
                    //               Navigator.pop(context);
                    //             },
                    //             width: 120,
                    //           )
                    //         ],
                    //       ).show();
                    //     } else {
                    //       Navigator.of(context).pop();
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //           SnackBar(
                    //               content: Text(
                    //                   responseDecoded["response"])));
                    //     }
                    //   } else {
                    //     Navigator.of(context).pop(); // loading
                    //     showCustomSnackBar(
                    //         "${apiResponse.error}", context);
                    //   }
                    // }
                    // else{
                    //   ScaffoldMessenger.of(context)
                    //       .showSnackBar(SnackBar(content: Text("Upload all three image")));
                    // }
                  },
                  title: "Check In"),
            ],
          ),
        ),
        body: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  buildYuvaTileRow(
                      "Program Name ",
                      widget.event.eventName,
                      GoogleFonts.actor(
                        textStyle: TextStyle(
                            color: Constants.themeTextGradients[1],
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      )),
                  buildYuvaTileRow("Host ",
                      "${widget.event.createrFirstName} ${widget.event.createrLastName}"),
                  buildYuvaTileRow("Post ", "${widget.event.createrPost}"),
                  buildYuvaTileRow("Contact ", "${widget.event.createrMobile}"),
                  buildYuvaTileRow(
                      "Program Description ", widget.event.eventDescription),
                  buildYuvaTileRow("Date Time ", widget.event.eventDateTime),
                  buildYuvaTileRow("Place ", widget.event.eventLocation),
                  // Container(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         "Share",
                  //         style: TextStyle(
                  //             color: Colors.blueAccent,
                  //             fontSize: 20,
                  //             fontWeight: FontWeight.w600),
                  //       ),
                  //       buildSocialButton(
                  //         icon: FontAwesomeIcons.facebookSquare,
                  //         color: Color(0xFF0075FC),
                  //         onClicked: () async {
                  //           await Share.share(
                  //             widget.event.eventDescription,
                  //             subject: widget.event.eventName,
                  //           );
                  //         },
                  //       ),
                  //       buildSocialButton(
                  //         icon: FontAwesomeIcons.twitter,
                  //         color: Color(0xFF1da1f2),
                  //         onClicked: () => {},
                  //       ),
                  //       const Spacer(),
                  //       Text(
                  //         "Go Live With",
                  //         style: TextStyle(
                  //             color: Colors.deepOrangeAccent,
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w500),
                  //       ),
                  //       buildSocialButton(
                  //         icon: FontAwesomeIcons.facebookSquare,
                  //         color: Color(0xFF0075FC),
                  //         onClicked: () => {},
                  //       )
                  //     ],
                  //   ),
                  // ),

                ],
              ),
            ),
            UploadButtonImageLocal(
                showImage: uploadedIndex.contains('1'),
                onlyCamera: false,
                buttonTextLabel: "Upload image 1",
                onTap: (str)=> pickDocument(str, context, '1')
            ),
            UploadButtonImageLocal(
                showImage: uploadedIndex.contains('2'),
                onlyCamera: false,
                buttonTextLabel: "Upload image 2",
                onTap: (str)=> pickDocument(str, context, '2')
            ),
            UploadButtonImageLocal(
                showImage: uploadedIndex.contains('3'),
                onlyCamera: false,
                buttonTextLabel: "Upload image 3",
                onTap: (str)=> pickDocument(str, context, '3')
            ),
          ],
        ));
  }

  setRSPV(String rsvp, Event event, {String? reason = ""}) async {
    showNetworkLoadingDialog(context, willPopScope: false);
    ApiResponse apiResponse =
        await sl<UnitManagementRepo>().setRSVPEvent(rsvp, event);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Navigator.of(context).pop(); // loading
      Alert(
        context: context,
        type: AlertType.success,
        title: "Success",
        buttons: [
          DialogButton(
            child: const Text(
              "OKAY",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              Navigator.pop(context); //pop dialog
              Navigator.of(context).pop(); // pop screen
            },
            width: 120,
          )
        ],
      ).show();
    } else {
      Navigator.of(context).pop(); // loading
      showCustomSnackBar("${apiResponse.error}", context);
    }
  }

  Padding buildYuvaTileRow(String label, String content, [TextStyle? style]) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(
              child: Text(
            content,
            style: style ?? const TextStyle(fontWeight: FontWeight.w600),
          ))
        ],
      ),
    );
  }

  Widget buildSocialButton(
          {required IconData icon,
          Color? color,
          required Function() onClicked}) =>
      InkWell(
        child: Container(
          width: 60,
          height: 60,
          child: Center(child: FaIcon(icon, color: color, size: 40)),
        ),
        onTap: onClicked,
      );


}
class UploadButtonImageLocal extends StatelessWidget {
  final Function onTap;
  final String buttonTextLabel;
  final File? pickedFile;
  final BuildContext? passedContext;
  final bool showImage;
  final onlyCamera;

  const UploadButtonImageLocal(
      {required this.onTap,
        this.pickedFile,
        this.buttonTextLabel = "Upload Media",
        Key? key,
        this.showImage = false,
        this.onlyCamera = false,
        this.passedContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Constants.formItemDecoration,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        leading: Icon(
          CupertinoIcons.add_circled,
          size: 27,
          color: Constants.kitThemeGradients[4],
        ),
        trailing: showImage
            ? Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border:
                  Border.all(color: Colors.lightBlueAccent.shade200)),
              padding: const EdgeInsets.all(8),
              child: const Text(
                "Uploaded",
                style: TextStyle(color: Colors.blue),
              ),
            )
            : null,
        onTap: () async {
          showDialog(
              context: context,
              builder: (context) => onlyCamera
                  ? CupertinoAlertDialog(
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(ImageSource.camera);
                      },
                      child: const Text("Camera"))
                ],
              )
                  : CupertinoAlertDialog(
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(ImageSource.gallery);
                      },
                      child: const Text("gallery")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(ImageSource.camera);
                      },
                      child: const Text("Camera"))
                ],
              )).then((value) async {
            if (value != null) onTap(value);
          });
        },
        title: Container(
          child: Text(buttonTextLabel,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: Constants.kitThemeGradients[4], fontSize: 12),
              )),
        ),
      ),
    );
  }
}