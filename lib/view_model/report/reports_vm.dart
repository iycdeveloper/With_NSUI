import 'dart:convert';

import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/reports_repo.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/reports/reports_response.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/api_model/base/api_response.dart';

class ReportsVM extends ChangeNotifier {
  String? downLoadedLocation;
  bool loadingPage = false;

  List<Report> reportList = [];

  void downLoadReport(String url, BuildContext context) async {
    showNetworkLoadingDialog(context);
    String? downloadLink = await getDownloadLink(context, url);

    Log.printILog("downloadLink $downloadLink");
    if (downloadLink != null) {
      Navigator.pop(context); // loading

      ///8188910911
      await launch(downloadLink);
      // Log.printILog("Start downloading .....");
      // final result = await DownloadServices().download(downloadLink);
      // Log.printILog("End downloading ..... $result");
      // Navigator.pop(context); // loading
      // if (result is SuccessState) {
      //   downLoadedLocation = result.value;
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text("Success downloaded to : $downLoadedLocation"),
      //     action: SnackBarAction(
      //         label: "Share",
      //         onPressed: () async {
      //           // final openResult = await OpenFile.open(result.value);
      //           // if (openResult.type == ResultType.done) return;
      //           Share.shareFiles(
      //             [downLoadedLocation!],
      //           );
      //         }),
      //   ));
      //   notifyListeners();
      // }
    } else {
      Navigator.pop(context);
      Log.printILog("Something wrong in download");
      // loading
    }
  }

  getDownloadLink(BuildContext context, String url) async {
    ApiResponse apiResponse = await ReportsRepo().getDownloadLink(url);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        return responseDecoded["response"];
      } else {
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
    }
  }

  void getReports(BuildContext context) async {
    loadingPage = true;
    ApiResponse apiResponse = await ReportsRepo().getReports();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        reportList = ReportsResponse.fromJson(responseDecoded).response;
        loadingPage = false;
        notifyListeners();
      } else {
        loadingPage = false;
        notifyListeners();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
    }
  }
}
