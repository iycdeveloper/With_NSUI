import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/batch/batch_data_model.dart';
import 'package:iyc/app/data/resources/db_provider/membership/batch_db_repo.dart';
import 'package:iyc/app/data/resources/repository/payment_repo.dart';
import 'package:iyc/screens/ui/payment/payment_screen.dart';
import 'package:iyc/screens/ui/payment/widgets/payment_bootom_sheet_nsui.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/payment/payment_screen_vm.dart';
import 'package:provider/provider.dart';

import '../../di_container.dart';

class PaymentAmountVM extends ChangeNotifier {
  bool isLoading = false;
  checkTransactionStatus(
    BuildContext context,
    String transactionId,
    List<BatchDataModel> membershipBatchList,
  ) async {
    showNetworkLoadingDialog(context, willPopScope: false);
    ApiResponse apiResponse =
        await sl<PaymentRepo>().checkPaymentStatusAggregator(transactionId);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS" &&
          responseDecoded["response"] == "1") {
        await Future.forEach(
            membershipBatchList.where((element) => element.selected).toList(),
            (e) async {
          e as BatchDataModel;
          e.paymentStatus = "PAID";
          await sl<BatchDBRepo>().updateData(e);
        });

        Navigator.of(context).pop(); // close net work loading dialog
        // await Alert(
        //   context: context,
        //   type: AlertType.success,
        //   onWillPopActive: true,
        //   title: "SUCCESS",
        //   desc: "",
        //   buttons: [
        //     DialogButton(
        //       child: Text(
        //         "OKAY",
        //         style: TextStyle(color: Colors.white, fontSize: 20),
        //       ),
        //       onPressed: () => Navigator.of(context).pop(),
        //       width: 120,
        //     )
        //   ],
        // ).show();
        await memberhshipPaymenNSUIBottomsheet(
            'Alert', 'Payment Successful!', context);
      } else {
        /// payment failed status display
        Navigator.of(context).pop();

        /// close net work loading dialog
        // await Alert(
        //   context: context,
        //   type: AlertType.error,
        //   title: "ERROR!",
        //   onWillPopActive: true,
        //   desc: responseDecoded["msg"] ?? " Error!!",
        //   buttons: [
        //     DialogButton(
        //       child: Text(
        //         "Okay",
        //         style: TextStyle(color: Colors.white, fontSize: 20),
        //       ),
        //       onPressed: () => Navigator.of(context).pop(),
        //       width: 120,
        //     )
        //   ],
        // ).show();
        await memberhshipPaymenNSUIBottomsheet(
            'Alert', 'Payment is not Complete.', context);
      }
    }

    Navigator.of(context).pop();

    /// page close

    isLoading = false;
    notifyListeners();
  }

  checkPaymentAmountMatching(
    Map<String, dynamic> transactionData,
    BuildContext context,
    List<BatchDataModel> batchList,
  ) async {
    showNetworkLoadingDialog(
      context,
    );

    ApiResponse apiResponse =
        await sl<PaymentRepo>().checkTransactionId(transactionData);

    /// close net work loading dialog

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded = jsonDecode(utf8.decode(
          base64Decode(apiResponse.response!.data.toString().trimLeft())));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        final result = await toPage(
            context,
            ChangeNotifierProvider(
              create: (context) => PaymentScreenVM(),
              child: PaymentScreen(
                transactionId: transactionData["transaction_id"],
                source: "M",
                amount: transactionData["amount"],
              ),
            ));

        if (result is TransactionStatus) {
          Navigator.of(context).pop();

          checkTransactionStatus(
              context, transactionData["transaction_id"], batchList);
        }
      } else {
        Navigator.of(context).pop();

        /// loading
        Navigator.of(context).pop();

        ///page

        /// payment failed status display
      }
    }
  }
}
