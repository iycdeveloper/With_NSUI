import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/app/data/resources/repository/ro_repo.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';

import '../../di_container.dart';
import '../../model/api_model/base/api_response.dart';

class RoHomeVM extends ChangeNotifier {
  bool loadingPage = false;
  bool showRoSearch = false;

  List<dynamic> batchMapList = [];
  void getRoDetails(BuildContext context) async {
    loadingPage = true;
    ApiResponse apiResponse = await sl<RoRepo>().getRoDetails();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        loadingPage = false;
        showRoSearch = true;

        notifyListeners();
      } else {
        showRoSearch = false;
        loadingPage = false;
        notifyListeners();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }

  void searchRoPaymentStatus(BuildContext context, String str) async {
    showNetworkLoadingDialog(context);

    ApiResponse apiResponse = await sl<RoRepo>().checkRoPayment(str);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        Navigator.of(context).pop();
        batchMapList = responseDecoded["response"];
        print(batchMapList.length);
        notifyListeners();
      } else {
        Navigator.of(context).pop();
        notifyListeners();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }
}
