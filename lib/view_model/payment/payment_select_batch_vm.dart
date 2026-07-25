import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';
import 'package:iyc/app/data/resources/repository/batch_repo.dart';
import 'package:iyc/app/modules/membership/controllers/membership_batch_controller.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/batch/batch_data_model.dart';
import 'package:iyc/app/data/resources/db_provider/membership/batch_db_repo.dart';
import 'package:iyc/app/data/resources/repository/payment_repo.dart';
import 'package:iyc/model/api_model/batch/batch_download_model.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/screens/ui/payment/payment_amount_page.dart';
import 'package:iyc/screens/ui/payment/payment_screen.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/payment/payment_amount_vm.dart';
import 'package:iyc/view_model/payment/payment_screen_vm.dart';
import 'package:provider/provider.dart';

class PaymentSelectBatchVM extends ChangeNotifier {
  bool isLoading = false;
  int? paymentFee;
  int? totalAmount;
  String? transactionId;
  bool isSelectedAll = false;
  List<BatchDataModel> membershipBatchList = [];

  Future getAllBatchFees(BuildContext context) async {
    ApiResponse apiResponse = await sl<PaymentRepo>().getAllPaymentBatches({});
    print(apiResponse.response);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        /// add api membership data to local db

        paymentFee = responseDecoded["response"];
        return paymentFee;
      } else {
        return paymentFee;
        //  Navigator.of(context).pop();
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
      }
    } else {
      //  Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
  }

  // batch.countAM is the batch's stored server-side quota, which can be
  // stale/inflated relative to how many members are actually synced and
  // shown for that batch (the same batch-quota-vs-real-members mismatch
  // fixed on the Membership Batch List screen). Charge for the members
  // actually visible/selectable here instead.
  int _realMemberCount(String batchId) =>
      memberList?.where((m) => m.batchId == batchId).length ?? 0;

  initiatePayment(BuildContext context) async {
    showNetworkLoadingDialog(context);
    final selectedBatches =
        membershipBatchList.where((element) => element.selected).toList();
    ApiResponse apiResponse = await sl<PaymentRepo>().initiatePayment(
        selectedBatches
            .map((e) => {
                  "AMOUNT": paymentFee! * _realMemberCount(e.batchId),
                  "BATCH_NO": e.batchId
                })
            .toList());
    totalAmount = selectedBatches
        .map((e) => _realMemberCount(e.batchId) * paymentFee!)
        .toList()
        .reduce((value, element) => value + element);

    print(apiResponse.response);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        /// add api membership data to local db

        isLoading = false;
        transactionId = responseDecoded["response"]["TRANSACTION_ID"];
        Navigator.of(context).pop();

        /// close networl loading
        await toPage(
            context,
            ChangeNotifierProvider(
                create: (context) => PaymentAmountVM(),
                child: PaymentAmountPage(
                  amount: totalAmount!,
                  transactionId: transactionId!,
                  batchList: membershipBatchList,
                )));
        Navigator.of(context).pop();
      } else {
        isLoading = false;
        notifyListeners();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
      }
      notifyListeners();
    } else {
      //  Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
  }

  // "Select All" must only touch the batches actually visible in the list
  // (synced + still Pending) — looping over the raw, unfiltered
  // membershipBatchList would also select already-paid/unsynced batches the
  // user never saw or intended to pay for.
  toggleSelectAll() {
    isSelectedAll = !isSelectedAll;
    for (final element in membershipBatchList) {
      if (element.syncStatus == "1" && element.paymentStatus == "Pending") {
        element.selected = isSelectedAll;
      }
    }
    notifyListeners();
  }

  // Takes the BatchDataModel itself (same object reference as in
  // membershipBatchList) rather than a list index — the screen renders a
  // *filtered* list, so a raw index into membershipBatchList[index] could
  // silently toggle a completely different, invisible batch whenever any
  // batch ahead of it had been filtered out (already paid, unsynced).
  changeCheckBox(BatchDataModel batch) {
    batch.selected = !batch.selected;
    notifyListeners();
  }

  // Future getMembershipBatchList(BuildContext context, {bool? reload}) async {
  //   isLoading = true;
  //   await downloadExistingBatch(context: context);
  //   if (reload != null && reload) {
  //     notifyListeners();
  //   }

  //   // membershipBatchList = await sl<BatchDBRepo>().getData();
  //   membershipBatchList = membershipBatchList
  //       .where((element) => element.paymentStatus != "PAID")
  //       .toList();
  //   paymentFee = paymentFee ?? await getAllBatchFees(context);
  //   isLoading = false;
  //   notifyListeners();
  // }
  List<BatchMember>? memberList = [];
  Future getMembershipBatchList(BuildContext context,
      {bool? reload, BatchDataModel? data}) async {
    isLoading = true;
    if (reload != null && reload) {
      notifyListeners();
    }
    // if (data != null) {
    //   membershipBatchList.add(data);
    // } else {
    membershipBatchList = await sl<BatchDBRepo>().getData();
    membershipBatchList = membershipBatchList
        .where((element) => element.paymentStatus != "PAID")
        .toList();
    // print(membershipBatchList.length);
    final allMembers = Get.find<MembershipBatchController>().memberList!;

    memberList = membershipBatchList
        .expand(
          (batch) => allMembers.where(
            (member) => member.batchId == batch.batchId,
          ),
        )
        .toList();
    print(membershipBatchList.length);

    print(memberList!.length);
    print(Get.find<MembershipBatchController>().memberList!.length);

    // }

    paymentFee = paymentFee ?? await getAllBatchFees(context);
    isLoading = false;
    notifyListeners();
  }

  downloadExistingBatch({
    required BuildContext context,
  }) async {
    // ProgressDialogUtils.showProgressIndicator();
    ApiResponse apiResponse = await sl<BatchRepo>().downloadExistingBatch();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        BatchDownloadResponse batchDownloadResponse =
            BatchDownloadResponse.fromJson(responseDecoded);

        // List<BatchDataModel> _membershipBatchList = await batchDBRepo.getData();

        /// add to batch list db
        await Future.forEach(batchDownloadResponse.response.batches,
            (element) async {
          membershipBatchList.add(
            BatchDataModel(
                countAM: int.parse(element.totalAm!),
                batchId: element.batchNo!,
                districtCode: element.districtCode,
                stateCode: element.stateCode,
                paymentStatus: element.paymentStatus == null
                    ? "Pending"
                    : element.paymentStatus == "PAID"
                        ? element.paymentStatus
                        : "Pending",
                syncStatus: '1'),
          );
        });

        // ProgressDialogUtils.closeDialog();
      } else {
        // ProgressDialogUtils.closeDialog();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
      }
      notifyListeners();
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
  }
}
