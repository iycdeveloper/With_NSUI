import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/screens/widgets/video_player_local.dart';
import 'package:iyc/screens/widgets/video_recoder_widget.dart';
import 'package:iyc/utils/constants.dart';

class UploadButton extends StatelessWidget {
  final String labelText;
  final Function() onTap;
  final String buttonTextLabel;

  const UploadButton({
    required this.labelText,
    required this.onTap,
    this.buttonTextLabel = "Upload Media",
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onTap(),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            labelText != ""
                ? Text(
                    labelText,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  )
                : Container(),
            Container(
                color: Colors.transparent,
                child: Container(
                  // width: MediaQuery.of(context).size.width / 1.2,
                  decoration: Constants.formItemDecoration,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          CupertinoIcons.add_circled,
                          size: 27,
                          color: Constants.kitThemeGradients[4],
                        ),
                        Container(
                          child: Text(buttonTextLabel,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Constants.kitThemeGradients[4],
                                    fontSize: 12),
                              )),
                        )
                      ],
                    ),
                  ),
                )),
          ]),
        ));
  }
}

enum DocumentType {
  amImage,
  idFront,
  idBack,
  category,
  bpl,
  caseFile,
  amVideo,
  dob,
  barCouncilId,
  evoderidFront,
  evoderidBack,
  adhaaridFront,
  adhaaridBack,
  studentId
}

class UploadButtonImageNSUI extends StatelessWidget {
  final Function onTap;
  final String buttonTextLabel;
  final String labelText;
  final bool readOnly;
  final File? pickedFile;
  final BuildContext? passedContext;
  final bool showImage;
  final onlyCamera;
  final Color? lablecolor;

  const UploadButtonImageNSUI(
      {required this.onTap,
      this.pickedFile,
      this.lablecolor,
      this.readOnly = false,
      required this.labelText,
      this.buttonTextLabel = "Upload Media",
      Key? key,
      this.showImage = false,
      this.onlyCamera = false,
      this.passedContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style:
                TextStyle(color: lablecolor ?? Colors.blueAccent, fontSize: 14),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 5,
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[200]!,
                      spreadRadius: 1.2,
                      blurRadius: 0.6),
                ]),
            //Constants.formItemDecoration,
            // margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: ListTile(
              // leading: Icon(
              //   CupertinoIcons.add_circled,
              //   size: 27,
              //   color: Constants.kitThemeGradients[4],
              // ),
              trailing: showImage
                  ? pickedFile!.path.contains('http')
                      ? IconButton(
                          onPressed: () {
                            if (passedContext != null)
                              FocusScope.of(passedContext!).unfocus();
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      insetPadding: const EdgeInsets.all(20),
                                      content: SizedBox.expand(
                                          child:
                                              Image.network(pickedFile!.path)),
                                      actions: [
                                        TextButton(
                                          child: const Text("Close"),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        )
                                      ],
                                    ));
                          },
                          icon: Icon(
                            Icons.visibility_rounded,
                            color: Constants.themeGradients[0],
                          ))
                      : GestureDetector(
                          onTap: () {
                            if (passedContext != null)
                              FocusScope.of(passedContext!).unfocus();
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      insetPadding: const EdgeInsets.all(20),
                                      content: SizedBox.expand(
                                        child: Image.file(pickedFile!),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text("Close"),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        )
                                      ],
                                    ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.lightBlueAccent.shade200)),
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              "view",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ))
                  : IconButton(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(left: 25),
                      onPressed: () {},
                      icon: Icon(
                        Icons.file_upload_outlined,
                        color: theme.textTheme.bodyLarge!.color,
                        size: 20,
                      )),
              // dense: true,
              onTap: () async {
                if (readOnly) {
                  return;
                }
                showDialog(
                    context: context,
                    builder: (context) => onlyCamera
                        ? CupertinoAlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(ImageSource.camera);
                                  },
                                  child: const Text(
                                    "Camera",
                                    style: TextStyle(color: Colors.black),
                                  ))
                            ],
                          )
                        : CupertinoAlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(ImageSource.gallery);
                                  },
                                  child: const Text(
                                    "gallery",
                                    style: TextStyle(color: Colors.black),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(ImageSource.camera);
                                  },
                                  child: const Text(
                                    "Camera",
                                    style: TextStyle(color: Colors.black),
                                  ))
                            ],
                          )).then((value) async {
                  if (value != null) onTap(value);
                });
              },
              title: Container(
                child: Text(buttonTextLabel,
                    style: showImage
                        ? theme.textTheme.bodyLarge!.copyWith(
                            color: theme.textTheme.bodyLarge!.color,
                            fontWeight: FontWeight.w500)
                        : theme.textTheme.bodyMedium!
                            .copyWith(color: Colors.grey)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UploadButtonLiveImage extends StatelessWidget {
  final Function onTap;
  final String buttonTextLabel;
  final File? pickedFile;
  final BuildContext? passedContext;
  final bool showImage;
  final onlyCamera;

  const UploadButtonLiveImage(
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
            ? GestureDetector(
                onTap: () {
                  if (passedContext != null)
                    FocusScope.of(passedContext!).unfocus();
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            insetPadding: const EdgeInsets.all(20),
                            content: SizedBox.expand(
                              child: Image.file(pickedFile!),
                            ),
                            actions: [
                              TextButton(
                                child: const Text("Close"),
                                onPressed: () => Navigator.of(context).pop(),
                              )
                            ],
                          ));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: Colors.lightBlueAccent.shade200)),
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    "view",
                    style: TextStyle(color: Colors.blue),
                  ),
                ))
            : null,
        onTap: () async {
          onTap('value');
          // showDialog(
          //     context: context,
          //     builder: (context) => onlyCamera
          //         ? CupertinoAlertDialog(
          //       actions: [
          //         TextButton(
          //             onPressed: () {
          //               Navigator.of(context).pop(ImageSource.camera);
          //             },
          //             child: Text("Camera"))
          //       ],
          //     )
          //         : CupertinoAlertDialog(
          //       actions: [
          //         TextButton(
          //             onPressed: () {
          //               Navigator.of(context).pop(ImageSource.gallery);
          //             },
          //             child: Text("gallery")),
          //         TextButton(
          //             onPressed: () {
          //               Navigator.of(context).pop(ImageSource.camera);
          //             },
          //             child: Text("Camera"))
          //       ],
          //     )).then((value) async {
          //   if (value != null) onTap(value);
          // });
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

class UploadButtonVideo extends StatelessWidget {
  final Function onTap;
  final String buttonTextLabel;
  final File? pickedFile;
  final bool showImage;
  final String lable;
  final Color? labelcolor;

  const UploadButtonVideo({
    required this.onTap,
    this.pickedFile,
    required this.lable,
    this.labelcolor,
    this.buttonTextLabel = "Upload Media",
    Key? key,
    required this.showImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lable,
            style:
                TextStyle(color: labelcolor ?? Colors.blueAccent, fontSize: 14),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 5,
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[200]!,
                      spreadRadius: 1.2,
                      blurRadius: 0.6),
                ]),
            //Constants.formItemDecoration,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    CupertinoIcons.add_circled,
                    size: 27,
                    color: Constants.kitThemeGradients[4],
                  ),
                  trailing: showImage
                      ? GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      child: VideoPlayerLocal(
                                          videoFile: pickedFile),
                                    ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.lightBlueAccent.shade200)),
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              "view",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ))
                      : null,
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoRecorderWidget(
                          callback: (File file) {
                            onTap(file);
                          },
                        ),
                      ),
                    );
                  },
                  title: Container(
                      child: Text(buttonTextLabel,
                          style: showImage
                              ? theme.textTheme.bodyLarge!.copyWith(
                                  color: theme.textTheme.bodyLarge!.color,
                                  fontWeight: FontWeight.w500)
                              : theme.textTheme.bodyMedium!
                                  .copyWith(color: Colors.grey))
                      // GoogleFonts.poppins(
                      //   textStyle: TextStyle(
                      //       color: Constants.kitThemeGradients[4],
                      //       fontSize: 12),
                      // )),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
