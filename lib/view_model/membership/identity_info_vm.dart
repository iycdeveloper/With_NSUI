import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iyc/app/core/utils/logger.dart';
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/modules/live_camera/new_liveliness/new_liveness_check.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/app/data/resources/repository/membership_repo.dart';
import 'package:iyc/app/data/resources/services/image_services.dart';
import 'package:iyc/screens/widgets/button/upload_button.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:iyc/utils/app_constants.dart';
// import 'package:liveness_cam/liveness_cam.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:iyc/app/core/app_export.dart';

import 'membership_vm.dart';

class IdentityInfoVM extends ChangeNotifier {
  bool epicIdValidated = false;

  bool eVoterIdValidated = false;
  bool addharIdValidated = false;

  String? selectedIdProof;
  String? membershipId;
  String? pickedAMFilePath;
  String? pickedDocumentBackFilePath;
  String? pickedBarCounsilIdFilePath;
  String? pickedIdProofPath;
//
  String? pickedAdhaarBackFilePath;
  String? pickedAdhaarFrontFilePath;
  String? pickedEvoterIdFrontProofPath;
  String? pickedEvoterIdBackProofPath;

  List<DropdownItem> idProofList = [
    // DropdownItem("Passport", "PP"),
    DropdownItem("Voter ID Card", "EI"),
    DropdownItem("E Voter ID", "EV"),

    // DropdownItem("Adhar Card", "AC"),
    // DropdownItem("Driving Licence", "LD"),
  ];

  File? pickedIdFile;
  File? pickedAMFile;
  File? pickedDocumentBack;
  File? pickedBarCounsilIdFile;

  //
  File? pickedDocumentEvoterFront;
  File? pickedDocumentEvoterBack;
  File? pickedDocumentAdhaarFront;
  File? pickedDocumentAdhaarBack;

  bool showIdImage = false;
  bool showAMImage = false;
  bool showBarIdImage = false;
  bool showDocumentBack = false;
  //
  bool showEvoterDocumentFront = false;
  bool showEvoterocumentBack = false;
  bool showAdhaarDocumentFront = false;
  bool showAdhaarDocumentBack = false;

  bool enableMediaEdit = false;
  bool disableFields = false;
  List<String> scrutinyCodeList = [];
  File? pickedVideoFile;
  String? pickedVideoFilePath;
  bool showVideoFile = false;
  bool showVideoOptional = false;

  TextEditingController idController = TextEditingController();
  TextEditingController barIdController = TextEditingController();
  //
  TextEditingController evoterIdController = TextEditingController();
  TextEditingController adhaarIdController = TextEditingController();

  MembershipRepo membershipRepo = MembershipRepo(dioClient: sl());

  void init(BuildContext context) {
    Log.printILog('${context.read<MembershipVM>().currentMember!.idValue}');

    if (context.read<MembershipVM>().currentMember!.idValue == null) {
      epicIdValidated = false;
      eVoterIdValidated = false;
    }
    if (idController.text.isNotEmpty) {
      epicIdValidated = true;
    }
    if (evoterIdController.text.isNotEmpty) {
      eVoterIdValidated = true;
    }
    // notifyListeners();
  }

  clearPickedVideo() {
    showVideoFile = false;
    notifyListeners();
  }

  validateEpicId(BuildContext context) async {
    if (selectedIdProof == 'EV' && evoterIdController.text.trim() == '') {
      CustomSnackBar.showErrorSnackBar("E Voter ID number Required..!!");
      return;
    }
    if (selectedIdProof == 'EI' && idController.text.trim() == '') {
      CustomSnackBar.showErrorSnackBar("Voter ID Card Number Required..!!");
      return;
    }

    ProgressDialogUtils.showProgressIndicator();

    var stateCode = context.read<MembershipVM>().currentMember!.stateCode!;
    bool returnValue = false;
    ApiResponse apiResponse = await membershipRepo.validateEpicId(stateCode,
        selectedIdProof == 'EV' ? evoterIdController.text : idController.text);
    ProgressDialogUtils.closeDialog();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        epicIdValidated = true;
        eVoterIdValidated = true;
        notifyListeners();
      } else {
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
      notifyListeners();
    } else {
      CustomSnackBar.showErrorSnackBar(apiResponse.error.toString());
    }

    return returnValue;
  }

  saveVideo(File result) async {
    File image;
    image = File(result.path);
    final Directory extDir = await getApplicationDocumentsDirectory();
    String dirPath = extDir.path;

    final String filePath = '$dirPath/${p.basename(result.path)}';
    final File newImage = await image.copy(filePath);
    File _image = newImage;

    pickedVideoFile = _image;
    pickedVideoFilePath = _image.path;
    Log.printELog(pickedVideoFilePath);
    showVideoFile = true;
    notifyListeners();
  }

  changeIdProof(String val) {
    selectedIdProof = val;
    notifyListeners();
  }

  checkpreFillData(BuildContext context) async {
    /// for edit mode fetch data from table
    BatchMember membershipRequestModel =
        context.read<MembershipVM>().currentMember!;
    selectedIdProof = membershipRequestModel.idType ?? "EI";
    idController.text = membershipRequestModel.idValue != null
        ? (selectedIdProof == 'EI' ? membershipRequestModel.idValue! : '')
        : '';
    evoterIdController.text =
        selectedIdProof == 'EV' ? membershipRequestModel.idValue! : '';
    adhaarIdController.text =
        selectedIdProof == 'EV' ? membershipRequestModel.adhaarNumber! : '';
//
    pickedIdProofPath = selectedIdProof == 'EI'
        ? membershipRequestModel.idDocumentFilePath
        : null;
    pickedEvoterIdFrontProofPath = selectedIdProof == 'EV'
        ? membershipRequestModel.idDocumentFilePath
        : null;
    pickedAdhaarFrontFilePath = selectedIdProof == 'EV'
        ? membershipRequestModel.adhaarIdFrontPath
        : null;

    pickedAMFilePath = membershipRequestModel.amPhotoFilePath ?? '';

    if (membershipRequestModel.videoFilePath != null) {
      pickedVideoFilePath = membershipRequestModel.videoFilePath;
      pickedVideoFile = File(membershipRequestModel.videoFilePath!);
      showVideoFile = true;
    }
    print(
        "state code : ${context.read<MembershipVM>().currentMember!.stateCode}");
    if (AppConstants.nonVideoVerificationStates
        .contains(context.read<MembershipVM>().currentMember!.stateCode)) {
      showVideoOptional = true;
    }
    //
    pickedDocumentBackFilePath = selectedIdProof == 'EI'
        ? membershipRequestModel.documentBackPath
        : null;
    pickedEvoterIdBackProofPath = selectedIdProof == 'EV'
        ? membershipRequestModel.documentBackPath
        : null;
    pickedAdhaarBackFilePath = selectedIdProof == 'EV'
        ? membershipRequestModel.adhaarIdBackPath
        : null;
    print("start");
    if (membershipRequestModel.scrutinyCode != null) {
      scrutinyCodeList = membershipRequestModel.scrutinyCode!.split(';');
      scrutinyCodeList.forEach((element) {
        if (element == "2") {
          enableMediaEdit = true;
          disableFields = true;
        }
        if (element == "9") {
          disableFields = true;
        }
        if (element == "1") {
          disableFields = true;
        }
      });
    }

    if (membershipRequestModel.idType == 'EI' &&
        (membershipRequestModel.idDocumentFilePath != null &&
            membershipRequestModel.idDocumentFilePath != '')) {
      pickedIdFile = File(membershipRequestModel.idDocumentFilePath!);
      showIdImage = true;
      notifyListeners();
      print("set 1");
    } else {
      showIdImage = false;
      notifyListeners();
    }
    if (membershipRequestModel.amPhotoFilePath != null &&
        membershipRequestModel.amPhotoFilePath != '') {
      pickedAMFile = File(membershipRequestModel.amPhotoFilePath!);
      showAMImage = true;
      notifyListeners();
      print("set 2");
    } else {
      showAMImage = false;
      notifyListeners();
    }
    if (membershipRequestModel.idType == 'EI' &&
        (membershipRequestModel.documentBackPath != null &&
            membershipRequestModel.documentBackPath != '')) {
      pickedDocumentBack = File(membershipRequestModel.documentBackPath!);
      showDocumentBack = true;
      notifyListeners();
      print("set 3");
    } else {
      showDocumentBack = false;
      notifyListeners();
    }
//
    if (membershipRequestModel.idType == 'EV' &&
        (membershipRequestModel.idDocumentFilePath != null &&
            membershipRequestModel.idDocumentFilePath != '')) {
      pickedDocumentEvoterFront =
          File(membershipRequestModel.idDocumentFilePath!);
      showEvoterDocumentFront = true;
      notifyListeners();
      print("set 4");
    } else {
      showEvoterDocumentFront = false;
      notifyListeners();
    }
    if (membershipRequestModel.idType == 'EV' &&
        (membershipRequestModel.adhaarIdFrontPath != null &&
            membershipRequestModel.adhaarIdFrontPath != '')) {
      pickedDocumentAdhaarFront =
          File(membershipRequestModel.adhaarIdFrontPath!);
      showAdhaarDocumentFront = true;
      notifyListeners();
      print("set 5");
    } else {
      showAdhaarDocumentFront = false;
      notifyListeners();
    }

    if (membershipRequestModel.idType == 'EV' &&
        (membershipRequestModel.documentBackPath != null &&
            membershipRequestModel.documentBackPath != '')) {
      pickedDocumentEvoterBack = File(membershipRequestModel.documentBackPath!);
      showEvoterocumentBack = true;
      notifyListeners();
      print("set 6");
    } else {
      showEvoterocumentBack = false;
      notifyListeners();
    }
    if (membershipRequestModel.idType == 'EV' &&
        (membershipRequestModel.adhaarIdBackPath != null &&
            membershipRequestModel.adhaarIdBackPath != '')) {
      pickedDocumentAdhaarBack = File(membershipRequestModel.adhaarIdBackPath!);
      showAdhaarDocumentBack = true;
      notifyListeners();
      print("set 7");
    } else {
      showAdhaarDocumentBack = false;
      notifyListeners();
    }
    print(pickedIdFile?.path);

    notifyListeners();
    return true;
  }

  bool validatePage(BuildContext context) {
    // return true;
    bool isLegalCellFieldsPopulated =
        true; // initial value as true for membership
    if (context.read<MembershipVM>().currentMember!.isLegalCell) {
      /// checking legal cell fields populated or not
      isLegalCellFieldsPopulated =
          barIdController.text.isNotEmpty && pickedBarCounsilIdFile != null;
    }

    if (selectedIdProof == null) {
      showCustomSnackBar("Select an Id Proof", context);
      return false;
    } else if (selectedIdProof == 'EI') {
      if (pickedIdProofPath == null ||
          pickedDocumentBackFilePath == null ||
          pickedAMFilePath == null ||
          (pickedVideoFilePath == null &&
              !showVideoOptional &&
              !context.read<MembershipVM>().currentMember!.isLegalCell) ||
          !isLegalCellFieldsPopulated) {
        showCustomSnackBar("Upload all documents", context);
        return false;
      } else {
        return selectedIdProof != null &&
            pickedIdProofPath != null &&
            pickedDocumentBackFilePath != null &&
            pickedAMFilePath != null &&
            isLegalCellFieldsPopulated &&
            ((pickedVideoFilePath != null || showVideoOptional) ||
                context.read<MembershipVM>().currentMember!.isLegalCell);
      }
    } else {
      if (adhaarIdController.text.trim().isEmpty) {
        showCustomSnackBar("AADHAR number required", context);
        return false;
      }
      if (adhaarIdController.text.trim().length < 12) {
        showCustomSnackBar("Enter valid AADHAR number", context);
        return false;
      }
      if (selectedIdProof == null ||
          (pickedAdhaarBackFilePath == null ||
              pickedAdhaarBackFilePath == '') ||
          (pickedAdhaarFrontFilePath == null ||
              pickedAdhaarFrontFilePath == '') ||
          (pickedEvoterIdFrontProofPath == null ||
              pickedEvoterIdFrontProofPath == '') ||
          (pickedEvoterIdBackProofPath == null ||
              pickedEvoterIdBackProofPath == '') ||
          (pickedAMFilePath == null || pickedAMFilePath == '') ||
          ((pickedVideoFilePath == null || pickedVideoFilePath == '') &&
              !showVideoOptional &&
              !context.read<MembershipVM>().currentMember!.isLegalCell) ||
          !isLegalCellFieldsPopulated) {
        showCustomSnackBar("Upload all documents", context);
        return false;
      } else {
        return selectedIdProof != null &&
            pickedAdhaarBackFilePath != null &&
            pickedAdhaarFrontFilePath != null &&
            pickedEvoterIdFrontProofPath != null &&
            pickedEvoterIdBackProofPath != null &&
            pickedAMFilePath != null &&
            isLegalCellFieldsPopulated &&
            ((pickedVideoFilePath != null || showVideoOptional) ||
                context.read<MembershipVM>().currentMember!.isLegalCell);
      }
    }
    // return true;
  }

  populateToModel(BuildContext context) {
    BatchMember membershipRequestModel =
        context.read<MembershipVM>().currentMember!;
    membershipRequestModel
      ..idType = selectedIdProof
      ..amPhotoFilePath = pickedAMFilePath
      ..modifiedOn = DateTime.now().toString()
      ..isSync = "0"
      ..isEditedScrutiny = "0"
      ..idDocumentFilePath = selectedIdProof == 'EI'
          ? pickedIdProofPath
          : pickedEvoterIdFrontProofPath
      ..adhaarIdFrontPath =
          selectedIdProof == 'EV' ? pickedAdhaarFrontFilePath : null
      ..adhaarIdBackPath =
          selectedIdProof == 'EV' ? pickedAdhaarBackFilePath : null
      ..adhaarNumber = selectedIdProof == 'EV' ? adhaarIdController.text : ''
      ..videoFilePath = pickedVideoFilePath
      ..documentBackPath = selectedIdProof == 'EI'
          ? pickedDocumentBackFilePath
          : pickedEvoterIdBackProofPath
      ..idValue =
          selectedIdProof == 'EI' ? idController.text : evoterIdController.text
      ..barCouncilId = barIdController.text
      ..referrerId = ""
      ..barIdPath = pickedBarCounsilIdFilePath;
    context.read<MembershipVM>().setCurrentMember(membershipRequestModel);
  }

  pickDocument(ImageSource imageSource, String? pickedFilePath,
      DocumentType documentType, BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();

    final result =
        await ImageServices().pickImage(imageSource, cropimage: false);
    if (result != null) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      File image;
      image = File(result.path);
      final Directory extDir = await getApplicationDocumentsDirectory();
      String dirPath = extDir.path;
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
        case DocumentType.evoderidFront:
          pickedDocumentEvoterFront = _image;
          pickedEvoterIdFrontProofPath = pickedDocumentEvoterFront!.path;
          showEvoterDocumentFront = true;
          break;
        case DocumentType.evoderidBack:
          pickedDocumentEvoterBack = _image;
          pickedEvoterIdBackProofPath = pickedDocumentEvoterBack!.path;
          showEvoterocumentBack = true;
          break;
        case DocumentType.adhaaridFront:
          // String filePath =
          //     '$dirPath/MEMBER_ID_A.${result.path.split('.').last}';
          // final File newImage = await image.copy(filePath);
          // File _image = newImage;
          //
          pickedDocumentAdhaarFront = _image;
          pickedAdhaarFrontFilePath = pickedDocumentAdhaarFront!.path;
          showAdhaarDocumentFront = true;
          break;
        case DocumentType.adhaaridBack:
          // String filePath =
          //     '$dirPath/MEMBER_ID_A_BACK.${result.path.split('.').last}';
          // final File newImage = await image.copy(filePath);
          // File _image = newImage;
          //
          pickedDocumentAdhaarBack = _image;
          pickedAdhaarBackFilePath = pickedDocumentAdhaarBack!.path;
          showAdhaarDocumentBack = true;
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
          break;
        case DocumentType.barCouncilId:
          pickedBarCounsilIdFile = _image;
          pickedBarCounsilIdFilePath = pickedBarCounsilIdFile!.path;
          showBarIdImage = true;

          break;
        case DocumentType.studentid:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
      notifyListeners();
    } else {
      print("file picked not");
      return null;
    }
  }

  // void clickLivePhoto() async {
  //   final _livenessCam = LivenessCam();

  //   File? result;
  //   _livenessCam.start(Get.context!).then((value) {
  //     if (value != null) {
  //       result = value;
  //       Log.printILog(result!.path);
  //       if (result == null) {
  //         CustomSnackBar.showErrorSnackBar('No live person detected.');
  //       } else {
  //         pickedAMFilePath = result!.path;
  //         pickedAMFile = File(pickedAMFilePath!);
  //         showAMImage = true;
  //         notifyListeners();
  //       }
  //     }
  //   });
  // }

  void clickLivePhotoNew(BuildContext context) async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      XFile? result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NewLivenessCheckPage(),
        ),
      );
      // XFile? result = await Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const LiveDataPage(),
      //   ),
      // );
      if (result == null) {
        CustomSnackBar.showErrorSnackBar('No live person detected.');
      } else {
        pickedAMFilePath = result.path;
        pickedAMFile = File(pickedAMFilePath!);
        showAMImage = true;
        notifyListeners();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera not active!')),
      );
    }
  }
}
