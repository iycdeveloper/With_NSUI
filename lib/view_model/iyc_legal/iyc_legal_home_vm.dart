import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iyc/helper/upload_document.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/iyc_legal/legal_cell_member.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/app/data/resources/repository/legal_cell_repo.dart';
import 'package:iyc/screens/ui/membership_ui/membership.dart';
import 'package:iyc/screens/ui/payment/payment_screen.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/membership/membership_vm.dart';
import 'package:iyc/view_model/payment/payment_screen_vm.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../di_container.dart';

class IycLegalHomeVM extends ChangeNotifier {
  bool showLegalCell = true; // by default every body can access legal cell
  bool isLoadingHome = false;
  bool isLoadingLegalCell = false;

  List<LegalCellMember> legalCellList = [];

  onTapAddMember(BuildContext context) async {
    /// goto membership flow and come back with member data
    showNetworkLoadingDialog(context, willPopScope: false);
    bool isSuccessLegalCellReg = false;
    final result = await toPage(
        context,
        ChangeNotifierProvider(
            create: (context) => MembershipVM(),
            child: MemberShip(
              member:
                  BatchMember(isLegalCell: true, memberId: "Legal Cell Member"),
              isLegalCell: true,
            )));
    if (result != null && (result is BatchMember)) {
      isLoadingHome = true;
      notifyListeners();
      ApiResponse apiResponse = await sl<LegalCellRepo>().addLegalCell(result);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        final responseDecoded =
            jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
        print(responseDecoded);
        if (responseDecoded['status'] == "SUCCESS") {
          //{"ORDER_ID":"LC62E8FBF83CA68","LEGEL_CELL_MEMBER_ID":"IYCLCCG1659436024","AMOUNT":100}
          Map memberDetailsResponse = responseDecoded["response"];
          final imageResult =
              await s3uploadAllMemberImages(result, memberDetailsResponse);
          if (imageResult) {
            final result = await toPage(
                context,
                ChangeNotifierProvider(
                  create: (context) => PaymentScreenVM(),
                  child: PaymentScreen(
                    transactionId: memberDetailsResponse["ORDER_ID"],
                    source: "LC",
                    amount: memberDetailsResponse["AMOUNT"].toString(),
                  ),
                ));

            if (result is TransactionStatus) {
              if (result == TransactionStatus.success)
                isSuccessLegalCellReg = true;
            }
          }
          Navigator.of(context).pop(); // loading indicator
          isLoadingHome = false;
          notifyListeners();
          getLegalCellList(context, true);
        } else {
          Navigator.of(context).pop(); // loading indicator
          isLoadingHome = false;
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseDecoded['response'])));
        }
      } else {
        Navigator.of(context).pop(); // loading indicator
        isLoadingHome = false;
        notifyListeners();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(apiResponse.error)));
      }
    } else {
      /// back button membership page
      Navigator.of(context).pop(); // loading indicator
    }
    if (isSuccessLegalCellReg) {
      await Alert(
        context: context,
        type: AlertType.success,
        onWillPopActive: true,
        title: "SUCCESS",
        desc: "IYC Legal Cell Member Added",
        buttons: [
          DialogButton(
            child: Text(
              "OKAY",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.of(context).pop(),
            width: 120,
          )
        ],
      ).show();
    } else {
      await Alert(
        context: context,
        type: AlertType.error,
        onWillPopActive: true,
        title: "Failed",
        desc: "IYC Legal Cell Member Registration Not Completed",
        buttons: [
          DialogButton(
            child: Text(
              "OKAY",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.of(context).pop(),
            width: 120,
          )
        ],
      ).show();
    }
  }

  //MEMBERID_ID.jpg and MEMBERID_BC.jpg ... bucket path : ycea.22/legalCell/MEMBERID/

  s3uploadAllMemberImages(BatchMember member, Map memberDetailsResponse) async {
    bool? returnValue;

    //MEMBERID_ID.jpg and MEMBERID_BC.jpg ... bucket path : ycea.22/legalCell/MEMBERID/

    final uploadResult = await Future.wait([
      uploadDocument(
          member.amPhotoFilePath,
          "${"LEGALCELL/${memberDetailsResponse["LEGEL_CELL_MEMBER_ID"]}"}",
          "${memberDetailsResponse["LEGEL_CELL_MEMBER_ID"]}_P.${member.amPhotoFilePath?.split(".").last}"),
      uploadDocument(
          member.idDocumentFilePath,
          "${"LEGALCELL/${memberDetailsResponse["LEGEL_CELL_MEMBER_ID"]}"}",
          "${memberDetailsResponse["LEGEL_CELL_MEMBER_ID"]}_D.${member.idDocumentFilePath?.split(".").last}"),
      uploadDocument(
          member.documentBackPath,
          "${"LEGALCELL/${memberDetailsResponse["LEGEL_CELL_MEMBER_ID"]}"}",
          "${memberDetailsResponse["LEGEL_CELL_MEMBER_ID"]}_D_BACK.${member.documentBackPath?.split(".").last}"),
      uploadDocument(
          member.barIdPath,
          "${"LEGALCELL/${memberDetailsResponse["LEGEL_CELL_MEMBER_ID"]}"}",
          "${memberDetailsResponse["LEGEL_CELL_MEMBER_ID"]}_BC.${member.barIdPath?.split(".").last}"),
    ]);
    if (uploadResult.contains(false)) {
      returnValue = false;
    } else if (returnValue == null || returnValue) {
      returnValue = true;
    }

    return returnValue;
  }

  void checkLegalAvailability(BuildContext context) async {
    isLoadingHome = true;
    ApiResponse apiResponse =
        await sl<LegalCellRepo>().getLegalCellAvailability();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        isLoadingHome = false;
        // showLegalCell = true;

        notifyListeners();
        getLegalCellList(context);
      } else {
        // showLegalCell = false;
        isLoadingHome = false;
        notifyListeners();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    } else {
      // showLegalCell = false;
      isLoadingHome = false;
      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error)));
    }
  }

  void getLegalCellList(BuildContext context, [bool? refresh]) async {
    isLoadingLegalCell = true;
    if (refresh != null && refresh) notifyListeners();
    ApiResponse apiResponse = await sl<LegalCellRepo>().getLegalCellList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        isLoadingLegalCell = false;
        legalCellList =
            legalCellMembersListFromJson(responseDecoded["response"])
                .reversed
                .toList();
        notifyListeners();
      } else {
        isLoadingLegalCell = false;
        notifyListeners();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    } else {
      isLoadingLegalCell = false;
      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error)));
    }
  }
}
