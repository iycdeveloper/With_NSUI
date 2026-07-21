import 'dart:convert';

import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/bpyc_repo.dart';
import 'package:iyc/app/data/resources/repository/payment_repo.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';

class PaymentHistoryController extends GetxController {
bool loadingData = true;
  List<dynamic> transactionList = [];
  List<dynamic> filterpanchayatData = [];

  @override
  void onInit() async {
    historyData();
    super.onInit();
  }

  Future<void> historyData() async {
    loadingData = true;
    update();
       var aggrId = await LocalStorageServices().getAgrIDMembership();

   ApiResponse apiResponse =
          await sl<PaymentRepo>().paymentHistory(aggrId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        transactionList = responseDecoded['response'];
        filterpanchayatData = transactionList;
        update();
      } else {
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
    } else {
      CustomSnackBar.showErrorSnackBar(apiResponse.error);
    }
    loadingData = false;
    update();
  }

  
  
}
