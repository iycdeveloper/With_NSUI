import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/provider/scrutiny/member/scrutiny_member_edit_vm.dart';
import 'package:iyc/app/data/resources/services/image_services.dart';
import 'package:iyc/screens/widgets/button/upload_button.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
// import 'package:m7_livelyness_detection/m7_livelyness_detection.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ScrutinyIdentityInfoVM extends ChangeNotifier {
  String? selectedIdProof;
  String? membershipId;
  String? pickedAMFilePath;
  String? pickedIdProofPath;
  String? pickedProfileFilePath;

  List<DropdownItem> idProofList = [
    DropdownItem("Passport", "PP"),
    DropdownItem("Adhar Card", "AC"),
    DropdownItem("Driving Licence", "LD"),
    DropdownItem("Epic Voter ID", "EI"),
  ];

  TextEditingController idController = TextEditingController();
  String? pickedDocumentBackFilePath;
  File? pickedIdFile;
  File? pickedAMFile;
  File? pickedDocumentBack;
  bool showIdImage = false;

  bool showAMImage = false;
  bool showDocumentBack = false;

  bool enableMediaEdit = false;
  bool enableIDEdit = false;
  bool enableAMImageEdit = false;
  bool enableAMVideoEdit = false;
  bool disableFields = true;
  List<String> scrutinyCodeList = [];
  File? pickedVideoFile;
  String? pickedVideoFilePath;
  bool showVideoFile = false;

  File? pickedProfileFile;

  bool showProfileImage = false;

  pickProfileImage(ImageSource imageSource) async {
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
      print("path=========");
      print(p.basename(result.path));
      final String filePath = '$dirPath/${p.basename(result.path)}';
      final File newImage = await image.copy(filePath);

      File _image = newImage;

      pickedProfileFile = _image;
      pickedProfileFilePath = _image.path;
      print(pickedProfileFilePath);
      showProfileImage = true;
      notifyListeners();
    } else {
      print("file picked not");
    }
  }

  void clickLivePhoto() async {
    // M7LivelynessDetection.instance.configure(
    //   contourColor: Colors.white,
    //   thresholds: [
    //     M7SmileDetectionThreshold(
    //       probability: 0.8,
    //     ),
    //     M7BlinkDetectionThreshold(
    //       leftEyeProbability: 0.25,
    //       rightEyeProbability: 0.25,
    //     ),
    //   ],
    // );
    // final String? response =
    // await M7LivelynessDetection.instance.detectLivelyness(
    //   Get.context!,
    //   config: M7DetectionConfig(
    //     maxSecToDetect: 600,
    //     steps: [
    //       M7LivelynessStepItem(
    //         step: M7LivelynessStep.smile,
    //         title: "Smile",
    //         isCompleted: false,
    //       ),
    //       M7LivelynessStepItem(
    //         step: M7LivelynessStep.blink,
    //         title: "Blink",
    //         isCompleted: false,
    //       ),
    //     ],
    //     startWithInfoScreen: false,
    //     captureButtonColor: Colors.red,
    //   ),
    // );
    // Log.printDLog(response);
    // if(response == null){
    //   CustomSnackBar.showErrorSnackBar('No live person detected.');
    // }
    // else{
    //   pickedAMFilePath = response;
    //   pickedAMFile = File(pickedAMFilePath!);
    //   showAMImage = true;
    //   notifyListeners();
    // }


  }

  changeIdProof(String val) {
    selectedIdProof = val;
    notifyListeners();
  }

  saveVideo(File result) async {
    File image;
    image = File(result.path);
    final Directory extDir = await getApplicationDocumentsDirectory();
    String dirPath = extDir.path;

    print(p.basename(result.path));
    final String filePath = '$dirPath/${p.basename(result.path)}';
    final File newImage = await image.copy(filePath);
    File _image = newImage;

    pickedVideoFile = _image;
    pickedVideoFilePath = _image.path;
    print("ipdated filee");
    print(pickedVideoFilePath);
    showVideoFile = true;
    notifyListeners();
  }

  pickIdImage(ImageSource imageSource) async {
    final result = await ImageServices().pickImage(imageSource);
    if (result != null) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      File _image;
      _image = File(result.path);
      // final myImagePath = '/storage/emulated/0/Download' ;
      final Directory extDir = await getApplicationDocumentsDirectory();
      String dirPath = extDir.path;
      print("path=========");
      print(p.basename(result.path));
      final String filePath = '$dirPath/${p.basename(result.path)}';
      final File newImage = await _image.copy(filePath);

      _image = newImage;
      pickedIdFile = _image;
      pickedIdProofPath = result.path;
      showIdImage = true;
      notifyListeners();
    } else {
      print("file picked not");
    }
  }

  pickAMImage(ImageSource imageSource) async {
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
      print("path=========");
      print(p.basename(result.path));
      final String filePath = '$dirPath/${p.basename(result.path)}';
      final File newImage = await image.copy(filePath);

      File _image = newImage;

      pickedAMFile = _image;
      pickedAMFilePath = _image.path;
      print(pickedAMFilePath);
      showAMImage = true;
      notifyListeners();
    } else {
      print("file picked not");
    }
  }

  pickDocumentBack(ImageSource imageSource) async {
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
      print("path=========");
      print(p.basename(result.path));
      final String filePath = '$dirPath/${p.basename(result.path)}';
      final File newImage = await image.copy(filePath);

      File _image = newImage;

      pickedDocumentBack = _image;
      pickedDocumentBackFilePath = _image.path;
      print(pickedDocumentBackFilePath);
      showDocumentBack = true;
      notifyListeners();
    } else {
      print("file picked not");
    }
  }

  pickDocument(ImageSource imageSource, String? pickedFilePath,
      DocumentType documentType) async {
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
      print("path=========");
      print(p.basename(result.path));
      final String filePath = '$dirPath/${p.basename(result.path)}';
      final File newImage = await image.copy(filePath);

      File _image = newImage;

      switch (documentType) {
        case DocumentType.amImage:
          pickedAMFile = _image;
          pickedAMFilePath = pickedAMFile!.path;
          showAMImage = true;
          break;
        case DocumentType.idFront:
          pickedIdFile = _image;
          pickedIdProofPath = pickedIdFile!.path;
          showIdImage = true;
          break;
        case DocumentType.idBack:
          pickedDocumentBack = _image;
          pickedDocumentBackFilePath = pickedDocumentBack!.path;
          showDocumentBack = true;
          break;
        case DocumentType.amVideo:
          // TODO: Handle this case.
          break;
        case DocumentType.category:
          // TODO: Handle this case.
          break;
        case DocumentType.bpl:
          // TODO: Handle this case.
          break;
        case DocumentType.caseFile:
          // TODO: Handle this case.
          break;
        case DocumentType.dob:
          // TODO: Handle this case.
          throw UnimplementedError();
        case DocumentType.barCouncilId:
          // TODO: Handle this case.
          throw UnimplementedError();
        case DocumentType.evoderidFront:
          // TODO: Handle this case.
          throw UnimplementedError();
        case DocumentType.evoderidBack:
          // TODO: Handle this case.
          throw UnimplementedError();
        case DocumentType.adhaaridFront:
          // TODO: Handle this case.
          throw UnimplementedError();
        case DocumentType.adhaaridBack:
          // TODO: Handle this case.
          throw UnimplementedError();
        case DocumentType.studentid:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
      notifyListeners();
    } else {
      return null;
      print("file picked not");
    }
  }

  checkpreFillData(BuildContext context) async {
    /// for edit mode fetch data from table
    BatchMember membershipRequestModel =
        context.read<ScrutinyMembershipEditVM>().currentMember!;
    if (idProofList
        .any((element) => element.value == membershipRequestModel.idType))
      selectedIdProof = membershipRequestModel.idType;
    pickedIdProofPath = membershipRequestModel.idDocumentFilePath;
    pickedAMFilePath = membershipRequestModel.amPhotoFilePath;
    idController.text = membershipRequestModel.idValue ?? "";
    print("start");
    if (membershipRequestModel.scrutinyCode != null) {
      scrutinyCodeList = membershipRequestModel.scrutinyCode!.split(';');
      print("---scrutinyCode");
      scrutinyCodeList.forEach((element) {
        Log.printILog(element);
        if (element == "2") {
          enableMediaEdit = true;
          // enableAMImageEdit = true;
          if (membershipRequestModel.reason!.contains("INVALID VIDEO"))
            enableAMVideoEdit = true;
          enableIDEdit = true;
          disableFields = true;
        }
        if (element == "18") {
          if (membershipRequestModel.reason!.contains("INVALID VIDEO"))
            enableAMVideoEdit = true;
          enableIDEdit = true;
          disableFields = true;
        }

        if (element == "27") {
          enableMediaEdit = true;
          enableAMImageEdit = true;
          enableAMVideoEdit = true;
          enableIDEdit = true;
          disableFields = true;
        }
        if (element == "9") {
          disableFields = true;
        }
        if (element == "1") {
          disableFields = true;
        }
        if (element == "20") {
          enableAMVideoEdit = true;
        }
        if (element == "21" ) {
          enableAMImageEdit = true;
          enableAMVideoEdit = true;
        }
        if (element == "13" ) {
          enableAMImageEdit = true;
        }
      });
      notifyListeners();
    }

    if (membershipRequestModel.idDocumentFilePath != null &&
        membershipRequestModel.idDocumentFilePath != "null") {
      pickedIdFile = File(membershipRequestModel.idDocumentFilePath!);
      showIdImage = true;
      notifyListeners();
      print("set 1");
    }
    if (membershipRequestModel.documentBackPath != null) {
      pickedDocumentBack = File(membershipRequestModel.documentBackPath!);
      showDocumentBack = true;
      notifyListeners();
      print("set 1");
    }
    if (membershipRequestModel.videoFilePath != null) {
      pickedVideoFile = File(membershipRequestModel.videoFilePath!);
      showVideoFile = true;
      notifyListeners();
      print("set 1");
    }
    if (membershipRequestModel.amPhotoFilePath != null &&
        membershipRequestModel.amPhotoFilePath != "null") {
      pickedAMFile = File(membershipRequestModel.amPhotoFilePath!);
      showAMImage = true;
      notifyListeners();
      print("set 2");
    }
    print('pickedIdFile?.path ${pickedIdFile?.path}');

    notifyListeners();
    return true;
  }

  clearPickedVideo() {
    showVideoFile = false;
    notifyListeners();
  }

  bool validatePage(
    BuildContext context,
  ) {
    bool validated = true;

    if (enableIDEdit) {
      if (pickedIdProofPath == null) {
        showCustomSnackBar("Pick a Id Proof Image", context);
        validated = false;
      }
    }
    if (enableAMImageEdit) {
      if (pickedAMFilePath == null) {
        showCustomSnackBar("Pick a AM image", context);
        validated = false;
      }
    }
    if (enableAMVideoEdit) {
      if (pickedVideoFilePath == null) {
        showCustomSnackBar("Upload Video ", context);
        validated = false;
      }
    }

    if (idController.text.isEmpty) {
      showCustomSnackBar("ID card is invalid", context);
      validated = false;
    }

    return validated;
  }

  populateToModel(BuildContext context) {
    BatchMember membershipRequestModel =
        context.read<ScrutinyMembershipEditVM>().currentMember!;
    membershipRequestModel
      ..idType = selectedIdProof
      ..amPhotoFilePath = pickedAMFilePath
      ..modifiedOn = DateTime.now().toString()
      ..idDocumentFilePath = pickedIdProofPath
      ..videoFilePath = pickedVideoFilePath
      ..documentBackPath = pickedDocumentBackFilePath
      ..idValue = idController.text;
    context
        .read<ScrutinyMembershipEditVM>()
        .setCurrentMember(membershipRequestModel);
  }
}
