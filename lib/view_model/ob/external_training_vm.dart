import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/app/data/resources/repository/unit_management_repo.dart';
import 'package:iyc/app/data/resources/services/aws_upload_services.dart';
import 'package:iyc/app/data/resources/services/image_services.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:iyc/utils/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:path/path.dart' as p;

class ExternalTrainingVM extends ChangeNotifier {
  bool isLoading = false;

  String? selectedExternalTrainingType;
  String? selectedExternalTrainingDateFrom;
  String? selectedExternalTrainingDateTo;
  TextEditingController externalTrainingDescription = TextEditingController();

  List<DropdownItem> externalTrainingType = [
    DropdownItem("Ahimsa ke raste", "AHIMSA KE RASTE"),
    DropdownItem("Netrutva Sangam", "Netrutva Sangam"),
  ];

  void onChangeTrainingType(String value) {
    selectedExternalTrainingType = value;
    notifyListeners();
  }

  void onChangeTrainingDateFrom(DateTime dateTime) {
    selectedExternalTrainingDateFrom =
        DateFormat('dd-MM-yyyy').format(dateTime);
    notifyListeners();
  }

  void onChangeTrainingDateTo(DateTime dateTime) {
    selectedExternalTrainingDateTo = DateFormat('dd-MM-yyyy').format(dateTime);
    notifyListeners();
  }

  void validateAndCreateExternalTraining(BuildContext context) async {
    if (externalTrainingDescription.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('External training description is required')));
      return;
    }
    if (selectedExternalTrainingType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('External training type is required')));
      return;
    }
    if (selectedExternalTrainingDateFrom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('External training date from is required')));
      return;
    }
    if (selectedExternalTrainingDateTo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('External training date to is required')));
      return;
    }
    if (uploadedIndex.length != 3) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Upload all three photos')));
      return;
    }
    await createExternalTraining(context);
  }

  Future<void> createExternalTraining(BuildContext context) async {
    // isLoading = true;
    // notifyListeners();
    // ApiResponse apiResponse =
    // await UnitManagementRepo().createExternalTraining(selectedExternalTrainingType!, selectedExternalTrainingDateFrom!, selectedExternalTrainingDateTo!, externalTrainingDescription.text);
    // if (apiResponse.response != null &&
    //     apiResponse.response!.statusCode == 200) {
    //   var responseDecoded =
    //   jsonDecode(utf8.decode(base64.decode(apiResponse.response!.data)));
    //   if (responseDecoded['status'] == "SUCCESS") {
    //     print(responseDecoded["response"]);
    //     isLoading = false;
    //     notifyListeners();
    //     await Alert(
    //       context: context,
    //       type: AlertType.success,
    //       title: "Success",
    //       desc: responseDecoded['response'],
    //       buttons: [
    //         DialogButton(
    //           child: Text(
    //             "OKAY",
    //             style: TextStyle(color: Colors.white, fontSize: 20),
    //           ),
    //           onPressed: () async {
    //             Navigator.pop(context);
    //           },
    //           width: 120,
    //         )
    //       ],
    //     ).show();
    //     Navigator.of(context).pop(true);
    //   } else {
    //     isLoading = false;
    //     notifyListeners();
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
    //   }
    // }
    // isLoading = false;
    // notifyListeners();
  }

  String description = "";
  int count = 1;

  List<String> uploadedIndex = [];

  Future<bool> uploadDocumentTask(
      String path, String date, String count) async {
    String? result = await AwsUploadServices().uploadFile(
        file: File(path),
        destDir: "ET",
        filename:
            "${date}_${await LocalStorageServices().getMobile()}_$count.${path.split(".").last}");

    if (result is String)
      return true;
    else
      return false;
  }

  pickDocument(
      ImageSource imageSource, BuildContext context, String count) async {
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
      final uploadResult = await uploadDocumentTask(
          _image.path, selectedExternalTrainingDateFrom!, count);

      uploadedIndex.add(count);
      notifyListeners();
      showCustomSnackBar("Uploaded Image ${count} Successfully", context);
    }
  }

  showDatepickerTodate(BuildContext context) async {
    final datePick = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100, 12, 31),// DateTime.now().add(const Duration(days: 30)),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Constants.themeGradients[1],
              onPrimary: Colors.black87,
              surface: Constants.themeGradients[0],
              onSurface: Constants.themeGradients[1],
            ),
            dialogBackgroundColor: Constants.themeGradients[0],
          ),
          child: child!,
        );
      },
    );
    if (datePick != null && datePick != selectedExternalTrainingDateTo) {
      onChangeTrainingDateTo(datePick);
    }
  }
}
