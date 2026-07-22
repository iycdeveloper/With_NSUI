import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/widgets/bottom_sheet/new_success_bottomshhet.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/app/data/resources/repository/complaints_repo.dart';
import 'package:iyc/app/data/resources/services/aws_upload_services.dart';
import 'package:iyc/app/data/resources/services/image_services.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/screens/ui/payment/payment_screen.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/payment/payment_screen_vm.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../di_container.dart';

class ComplaintDetailsVm extends ChangeNotifier {
  TextEditingController detailsController = TextEditingController();
  bool isLoadingPage = false;

  String? complaintBy;
  File? pickedSupportingDocument1;
  File? pickedSupportingDocument2;
  File? pickedSupportingDocument3;

  String? pickedSupportingDocument1Path;
  String? pickedSupportingDocument2Path;
  String? pickedSupportingDocument3Path;
  bool showPickedSupportingDocument1 = false;
  bool showPickedSupportingDocument2 = false;
  bool showPickedSupportingDocument3 = false;

  String? complaintDoc1Name;
  String? complaintDoc2Name;
  String? complaintDoc3Name;
  String? userStateCode;

  Map? candidateData;
  String? userMemberId;
  void init(BuildContext context, Map candidateData, String userMemberId,
      String userMemberState) async {
    this.userMemberId = userMemberId;
    userStateCode = userMemberState;
    isLoadingPage = true;
    complaintBy = await LocalStorageServices().getUserProfileName();
    this.candidateData = candidateData;
    isLoadingPage = false;
    notifyListeners();
  }

  Completer<void>? updateDialogCompleter;

  // void handleUpdateBox() {
  //   if (updateDialogCompleter != null) return;

  //   updateDialogCompleter = Completer();
  //   CustomSnackBar.showUpdateAppBox();
  // }

  pickSupportingDocument(
      ImageSource imageSource, String? pickedFilePath) async {
    final result = await ImageServices().pickImage(imageSource,cropimage: false);
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

      if (pickedFilePath == pickedSupportingDocument1Path) {
        pickedSupportingDocument1 = _image;
        pickedSupportingDocument1Path = pickedSupportingDocument1!.path;
        showPickedSupportingDocument1 = true;
      } else if (pickedFilePath == pickedSupportingDocument2Path) {
        pickedSupportingDocument2 = _image;
        pickedSupportingDocument2Path = pickedSupportingDocument2!.path;
        showPickedSupportingDocument2 = true;
      } else if (pickedFilePath == pickedSupportingDocument3Path) {
        pickedSupportingDocument3 = _image;
        pickedSupportingDocument3Path = pickedSupportingDocument3!.path;
        showPickedSupportingDocument3 = true;
      }
      notifyListeners();
    } else {
      return null;
      print("file picked not");
    }
  }

  Future initiateUploadFiles() async {
    complaintDoc1Name = pickedSupportingDocument1Path != null
        ? "${candidateData!["MEMBER_ID"]}_${Random().nextInt(9999)}_1.jpg"
        : "";

    complaintDoc2Name = pickedSupportingDocument2Path != null
        ? "${candidateData!["MEMBER_ID"]}_${Random().nextInt(9999)}_2.jpg"
        : "";

    complaintDoc3Name = pickedSupportingDocument3Path != null
        ? "${candidateData!["MEMBER_ID"]}_${Random().nextInt(9999)}_3.jpg"
        : "";
    final result = await Future.wait([
      uploadDocument(pickedSupportingDocument1Path,
          "MEMBERSHIP/$userStateCode/OM/$userMemberId", complaintDoc1Name!),
      uploadDocument(pickedSupportingDocument2Path,
          "MEMBERSHIP/$userStateCode/OM/$userMemberId", complaintDoc2Name!),
      uploadDocument(pickedSupportingDocument3Path,
          "MEMBERSHIP/$userStateCode/OM/$userMemberId", complaintDoc3Name!)
    ]);
    return result.contains(true);
  }

//"MEMBERSHIP/${member.stateCode}/OM/${member.memberId}"
  //${member.memberId}_P.${member.amPhotoFilePath?.split(".").last}
  Future<bool> uploadDocument(
      String? filePath, String destinationDirectory, String fileName) async {
    if (filePath == null) {
      return false;
    }
    String? result = await AwsUploadServices().uploadFile(
        file: File(filePath),
        destDir: destinationDirectory,
        filename: fileName);

    if (result is String) {
      return true;
    } else {
      return false;
    }
  }

  addComplaint(BuildContext context, String candidatePost) async {
    FocusScope.of(context).unfocus();

    if (detailsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(" Kindly fill complaint")));
      return false;
    }
    showNetworkLoadingDialog(context);
    await initiateUploadFiles();
    ApiResponse apiResponse = await sl<ComplaintsRepo>().addComplaint(
        candidatePost,
        candidateData!,
        [complaintDoc1Name!, complaintDoc2Name!, complaintDoc3Name!],
        detailsController.text,
        userMemberId!);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        Navigator.of(context).pop();
        makeComplaintsPayment(context, responseDecoded["response"]["ORDER_ID"],
            responseDecoded["response"]["AMOUNT"]);
      } else {
        Navigator.of(context).pop();

        /// payment failed status display
        
         if (responseDecoded['error_code'] == 1001) {
          // handleUpdateBox();
        } else if (responseDecoded['error_code'] == 9999) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                " ERROR.  ${responseDecoded["response"] ?? "add complaint failed"}")));
        } else {}
      }
    }
  }

  makeComplaintsPayment(
    BuildContext context,
    String orderId,
    String amount,
  ) async {
    showNetworkLoadingDialog(context);

    final result = await toPage(
        context,
        ChangeNotifierProvider(
          create: (context) => PaymentScreenVM(),
          child: PaymentScreen(
            transactionId: orderId,
            source: "C",
            amount: amount,
          ),
        ));

    if (result is TransactionStatus) {
      ApiResponse apiResponse = await sl<ComplaintsRepo>()
          .checkPaymentStatusComplaints(orderId, amount);

      Navigator.of(context).pop();

      /// close net work loading dialog

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        final responseDecoded =
            jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
        print(responseDecoded);
        if (responseDecoded['status'] == "SUCCESS") {
          await newSuccessBotttomSheet('Complaints',
              'Thank you. Your Complaints is successful', '', 'Ok', onTap: () {
            Navigator.of(context)
                .popUntil((route) => route.settings.name == "/home");
          });
          // await showDialog(
          //     context: context,
          //     barrierDismissible: false,
          //     builder: (context) => AlertDialog(
          //           title: Text("Thank you. Your Complaints is successful"),
          //           actions: [
          //             TextButton(
          //                 onPressed: () => Navigator.of(context).popUntil(
          //                     (route) => route.settings.name == "/home"),
          //                 child: Text("Okay"))
          //           ],
          //         ));
        } else {
          /// payment failed status display

          if (responseDecoded['error_code'] == 1001) {
            // handleUpdateBox();
          } else if (responseDecoded['error_code'] == 9999) {
            await newSuccessBotttomSheet(
                'Error', 'Complaint failed to submit', '', 'Ok', onTap: () {
              Navigator.pop(context);
            }, failed: true, buttonicon: false);
          } else {}
          // await Alert(
          //   context: context,
          //   style: const AlertStyle(backgroundColor: Colors.white),
          //   type: AlertType.error,
          //   title: "Error",
          //   desc: "Complaint failed to submit",
          //   buttons: [
          //     DialogButton(

          //       color: Constants.themeGradients[0],
          //       child: Text(
          //         "OKAY",
          //         style: TextStyle(color: Colors.black, fontSize: 20),
          //       ),
          //       onPressed: () async {
          //         Navigator.pop(context);
          //       },
          //       width: 120,
          //     )
          //   ],
          // ).show();
        }
      }
    }
  }
}
