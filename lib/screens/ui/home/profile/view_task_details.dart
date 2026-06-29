import 'dart:math';

import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iyc/model/api_model/task/task.dart';
import 'package:iyc/screens/widgets/button/iyc_icon_button.dart';
import 'package:iyc/screens/widgets/button/upload_button.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/profile/inbox/task_details_vm.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ViewTaskDetails extends StatefulWidget {
  const ViewTaskDetails({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  State<ViewTaskDetails> createState() => _ViewTaskDetailsState();
}

class _ViewTaskDetailsState extends State<ViewTaskDetails> {
  late Task task;

  @override
  void initState() {
    task = widget.task;
    if (task.taskType == "D2D" || task.taskType == "BJ") {
      // context.read<TaskDetailsVM>().getTaskDetails(task);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task Details")),
      body: Consumer<TaskDetailsVM>(
        builder: (_, model, __) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 6,
                      backgroundColor: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      task.taskType,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Text(
                  task.taskStatus,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: task.taskStatus == 'COMPLETED'
                          ? Colors.green
                          : customGreyColor),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                          side: BorderSide(
                              color: task.taskStatus == 'COMPLETED'
                                  ? Colors.transparent
                                  : customGreyColor)),
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: task.taskStatus == 'COMPLETED'
                            ? Colors.green
                            : Colors.transparent,
                        child: Icon(
                          Icons.check,
                          color: task.taskStatus == 'COMPLETED'
                              ? Colors.white
                              : customGreyColor,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 280,
                      child: DetectableText(
                        text: task.taskText,
                        detectionRegExp: urlRegex,
                        detectedStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                        ),
                        basicStyle: TextStyle(
                          fontSize: 20,
                        ),
                        onTap: (tappedText) async {
                          try {
                            await launchUrl(Uri.parse(task.taskUrl),
                                mode: LaunchMode.externalApplication);
                          } on Exception catch (e) {
                            debugPrint(e.toString());
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),


            if (task.taskType == "VIDEO" && task.taskUrl.contains("youtube"))
              Container(
                child: Image.network(
                    "https://i.ytimg.com/vi/${task.taskUrl.split("v=").last}/hqdefault.jpg"),
              ),
            if (task.taskType == "PHOTO" && task.taskUrl.contains(".jpg"))
              Container(
                child: Image.network(task.taskUrl),
              ),
            if (task.taskType == "AUDIO")
              Image.network(
                  "https://www.headphonesty.com/wp-content/uploads/2020/04/Audio-file-format-MP3_OK-1100x653.jpg"),
            Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  DateFormat("dd-MM-yyyy").format(task.taskEndDate),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: task.taskStatus == 'Completed'
                          ? Colors.green
                          : customGreyColor),
                )),
            // Text('${task.isExpired}'),
            // Text('${task.taskStatus}'),
            task.isExpired || task.taskStatus == "COMPLETED"
                ? SizedBox()
                : Column(
              children: [
                if (task.taskType == "CAMERA")
                  Column(
                    children: [
                      if (model.uploadCount < 5)
                        UploadButtonImage(
                            onlyCamera: true,
                            buttonTextLabel: "Upload Task Image",
                            onTap: (str) => context
                                .read<TaskDetailsVM>()
                                .pickDocument(str, context, task)),
                      model.showUploadComplete
                          ? IycIconButton(
                          title: "Complete Task",
                          onTap: () => context
                              .read<TaskDetailsVM>()
                              .completeTask(context, task))
                          : SizedBox()
                    ],
                  ),
                if (task.taskType == "UPLOAD")
                  Column(
                    children: [
                      if (model.uploadCount < 5)
                        UploadButtonImage(
                            buttonTextLabel: "Upload Task Image",
                            onTap: (str) => context
                                .read<TaskDetailsVM>()
                                .pickDocument(str, context, task)),
                      model.showUploadComplete
                          ? IycIconButton(
                          title: "Complete Task",
                          onTap: () => context
                              .read<TaskDetailsVM>()
                              .completeTask(context, task))
                          : SizedBox()
                    ],
                  ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      task.taskPoint,
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 22,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      "assets/iyc_icons/reward.png",
                      height: 50,
                      width: 50,
                    ),
                  ],
                ),
                if (task.taskType == "D2D" || task.taskType == "BJ")
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        if (int.parse(model.taskCount) != 0)
                          CircularProgressBarWithText(
                            progress: int.parse(model.taskCompleteCount) /
                                int.parse(model.taskCount),
                            text:
                            '${int.parse(model.taskCompleteCount)}/${int.parse(model.taskCount)}',
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Task Progress")
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (task.taskType == "D2D" ||
                    task.taskType == "DATE" ||
                    task.taskType == "BJ")
                  IycIconButton(
                      title: "Complete Task",
                      onTap: () => context
                          .read<TaskDetailsVM>()
                          .completeTask(context, task)),
                if ((task.taskType == "AUDIO" ||
                    task.taskType == "VIDEO" ||
                    task.taskType == "PHOTO") &&
                    model.isShared)
                  IycIconButton(
                      title: "Complete Task",
                      onTap: () => context
                          .read<TaskDetailsVM>()
                          .completeTask(context, task)),
                if (task.taskType == "AUDIO" ||
                    task.taskType == "VIDEO" ||
                    task.taskType == "PHOTO")
                  IycIconButton(
                      title: "Share",
                      onTap: () =>
                          context.read<TaskDetailsVM>().shareTask(context, task)),
              ],
            ),

            // task.isExpired || task.taskStatus == "COMPLETED"
            //     ? SizedBox()
            //     :model.isShared
            //                 ? IycIconButton(
            //                     title: "Complete Task",
            //                     onTap: () => context
            //                         .read<TaskDetailsVM>()
            //                         .completeTask(context, task))
            //                 :
            // task.taskType == "CAMERA" || task.taskType == "UPLOAD" || task.taskType == "DATE" || task.taskType == "BJ"
            //                     ? SizedBox()
            //                     : IycIconButton(
            //                         title: "Share",
            //                         onTap: () => context
            //                             .read<TaskDetailsVM>()
            //                             .shareTask(context, task)),
            //https://i.ytimg.com/vi/jNQXAC9IVRw/hqdefault.jpg

            // if (task.taskType == "TEXT" && task.taskUrl.isNotEmpty)
            //   GestureDetector(
            //     onTap: () {
            //       context.read<TaskDetailsVM>().shareTask(context, task);
            //       // UrlLauncher().launchURL(task.taskUrl,);
            //     },
            //     child: Container(
            //       height: 700,
            //       child: AbsorbPointer(
            //         child: WebView(
            //           javascriptMode: JavascriptMode.unrestricted,
            //           initialUrl: task.taskUrl,
            //           onWebViewCreated: (controlller) {
            //             print(".........................wenbvie wcreated");
            //           },
            //           navigationDelegate: (req) {
            //             if (req.url.contains("fb://native"))
            //               return NavigationDecision.prevent;
            //             else
            //               return NavigationDecision.navigate;
            //           },
            //         ),
            //       ),
            //     ),
            //   ),
            ///`````````````````````````````````````````````````````````````````````````````
            const SizedBox(
              height: 25,
            ),
            if (task.taskUrl.trim().isNotEmpty)
              Container(
                child: Text(
                  "Preview",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                margin: EdgeInsets.symmetric(vertical: 20),
              ),
            if (task.taskUrl.trim().isNotEmpty)
              GestureDetector(
                onTap: () {
                  context.read<TaskDetailsVM>().shareTask(context, task);
                  // UrlLauncher().launchURL(task.taskUrl,);
                },
                child: Container(
                  height: 700,
                  //TODO
                  // child: AbsorbPointer(
                  //   child: WebView(
                  //     javascriptMode: JavascriptMode.unrestricted,
                  //     initialUrl: '${task.taskUrl}',
                  //     onWebViewCreated: (controller) {
                  //       print(".........................webview created");
                  //     },
                  //     navigationDelegate: (req) {
                  //       if (req.url.contains("fb://native"))
                  //         return NavigationDecision.prevent;
                  //       else
                  //         return NavigationDecision.navigate;
                  //     },
                  //   ),
                  // ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Color customRedColor = Color.fromRGBO(229, 62, 62, 1.0);
Color customGreyColor = Color.fromRGBO(113, 128, 150, 1);

class CircularProgressBarWithText extends StatelessWidget {
  final double progress;
  final String text;

  CircularProgressBarWithText({required this.progress, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 80, // Set the desired width
              height: 80,
              child: CircularProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                strokeWidth: 8, // Adjust the thickness of the indicator
              ),
            ),
            Text(
              text,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ],
    );
  }
}
