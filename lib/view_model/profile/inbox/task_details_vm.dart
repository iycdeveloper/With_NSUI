import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/task/task.dart';
import 'package:iyc/app/data/resources/repository/task_management_repo.dart';
import 'package:iyc/app/data/resources/services/aws_upload_services.dart';
import 'package:iyc/app/data/resources/services/image_services.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:iyc/screens/widgets/date_picker_widget.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/constants.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TaskDetailsVM extends ChangeNotifier {
  bool isShared = false;
  bool isLoading = false;

  bool isExpired = false;

  String taskCount ='0';
  String taskCompleteCount = '0';

  File? pickedTaskImage;
  String? pickedTaskImagePath;
  TextEditingController taskInfoController = TextEditingController();

  String? selectedDate;
  DateTime eventDate = DateTime.now();

  bool showUploadComplete = false;

  changeDate(DateTime timeData) {
    // selectedDate = "${timeData.day}-${timeData.month}-${timeData.year}";
    selectedDate = DateFormat("dd-MM-yyyy").format(timeData);
    eventDate = timeData;
    notifyListeners();
  }

  shareTask(BuildContext context, Task task) async {
  //   if(task.taskUrl.isNotEmpty){
  //     // ShareResult? shareResult;
  //
  //     if (["AUDIO", "PHOTO", "VIDEO"].contains(task.taskType) &&
  //         (!task.taskUrl.contains("instagram") &&
  //             !task.taskUrl.contains("facebook") &&
  //             !task.taskUrl.contains("twitter"))) {
  //       final downloadLocation =
  //       await DownloadServices().downloadTemporary(task.taskUrl);
  //       if (downloadLocation is SuccessState) {
  //         print(downloadLocation.value);
  //         shareResult = await Share.shareXFiles(
  //           [XFile(downloadLocation.value)],
  //           // text: "${task.taskText}",
  //         );
  //       }
  //     } else {
  //       shareResult = await Share.shareWithResult(task.taskUrl);
  //     }
  //
  //     print(shareResult?.status);
  //     if (shareResult != null &&
  //         shareResult.status == ShareResultStatus.success) {
  //       isShared = true;
  //
  //       completeTask(context, task);
  //     }
  //     notifyListeners();
  //   }else{
  //     showCustomSnackBar("Task url is empty", context);
  //   }
  // }
  //
  // getTaskDetails(Task task) async {
  //   ApiResponse apiStarResponse = await TaskManagementRepo().getTaskDetails(task.taskId);
  //   if (apiStarResponse.response != null &&
  //       apiStarResponse.response!.statusCode == 200) {
  //     var responseDecoded =
  //     jsonDecode(utf8.decode(base64.decode(apiStarResponse.response!.data)));
  //
  //     if (responseDecoded['status'] == "SUCCESS") {
  //       taskCount = responseDecoded['response']['TASK_TOTAL_COUNT'];
  //       taskCompleteCount = responseDecoded['response']['TASK_COUNT_DONE'];
  //     }
  //     isLoading = false;
  //     notifyListeners();
  //   }
  }

  completeTask(BuildContext context, Task task) async {
    isLoading = true;
    showNetworkLoadingDialog(context, willPopScope: false);
    if (task.taskUrl.isEmpty)
      await Alert(
        context: context,
        title: "Comments ",
        content: Builder(builder: (context1) {
          return ChangeNotifierProvider.value(
            value: context.read<TaskDetailsVM>(),
            child: Column(
              children: [
                Container(
                  height: 200,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all()),
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration.collapsed(
                      hintText: "Comments....",
                    ),
                    maxLines: null,
                    controller: taskInfoController,
                  ),
                ),
                Consumer<TaskDetailsVM>(
                  builder: (_, model, __) => DatePickerWidget(
                    labelText: "Date",
                    selectedDate: model.selectedDate ?? "Select a date",
                    onTap: () async {
                      FocusManager.instance.primaryFocus?.unfocus();

                      final datePick = await showDatePicker(
                        context: context,
                        initialDate: new DateTime.now(),
                        firstDate: DateTime.now().subtract(Duration(days: 180)),
                        lastDate: new DateTime.now(),
                        builder: (BuildContext? context, Widget? child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: Constants.themeGradients[1],
                                onPrimary: Colors.black87,
                                surface: Constants.themeGradients[0],
                                onSurface: Constants.themeGradients[1],
                              ),
                              dialogBackgroundColor:
                                  Constants.themeGradients[0],
                            ),
                            child: child!,
                          );
                        },
                      );
                      //await datePicker(context);
                      print(datePick);
                      if (datePick != null && datePick != model.eventDate) {
                        model.changeDate(datePick);
                      }
                    },
                  ),
                )
              ],
            ),
          );
        }),
        buttons: [
          DialogButton(
            child: Text(
              "OKAY",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              Navigator.pop(context);

            },
            width: 120,
          )
        ],
      ).show();
    if (task.taskType == "DATE" && taskInfoController.text.isEmpty && selectedDate == null){
      showCustomSnackBar("Comment and Date is required", context);
      isLoading = false;
      Navigator.of(context).pop(); // loading close
      notifyListeners();
    }else{
      ApiResponse apiResponse = await TaskManagementRepo().completeTask(task.taskId, taskInfoController.text, selectedDate ?? "");
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        var responseDecoded = jsonDecode(utf8.decode(base64.decode(apiResponse.response!.data)));
        if (responseDecoded['status'] == "SUCCESS") {
          isLoading = false;

          await Alert(
            context: context,
            type: AlertType.success,
            onWillPopActive: true,
            title: "SUCCESS",
            desc: "Thank you. Your Task is completed",
            buttons: [
              DialogButton(
                child: Text(
                  "OKAY",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                width: 120,
              )
            ],
          ).show();
          Navigator.of(context).pop(true); // pop screen
        }
        else {
          isLoading = false;
          Navigator.of(context).pop(); // loading close
          notifyListeners();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
        }
      }
    }

  }

  Future<bool> uploadDocumentTask(Task task) async {
    String? result = await AwsUploadServices().uploadFile(
        file: File(pickedTaskImagePath!),
        destDir: "TASKS",
        filename:
            "${await LocalStorageServices().getMobile()}_${task.taskId}_$uploadCount.${pickedTaskImagePath!.split(".").last}");

    if (result is String)
      return true;
    else
      return false;
  }

  int uploadCount = 0;

  pickDocument(ImageSource imageSource, BuildContext context, Task task) async {
    //  FocusScope.of(context).unfocus();
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

      pickedTaskImage = _image;
      pickedTaskImagePath = pickedTaskImage!.path;
      final uploadResult = await uploadDocumentTask(task);
      showCustomSnackBar(
          "Uploaded Image ${uploadCount + 1} Successfully", context);
      uploadCount++;
      showUploadComplete = true;
      notifyListeners();
    }
  }


}
