import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/campaign/campaign_data.dart';
import 'package:iyc/app/data/resources/repository/campaign_repo.dart';

class ViewCampaignDataVM extends ChangeNotifier {
  bool isLoading = false;
  List<CampaignData> campaignList = [];

  getCampaignDataList(BuildContext context, String campaignId) async {
    isLoading = true;

    ApiResponse apiResponse =
        await CampaignRepo().getCampaignDataList(campaignId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      var responseDecoded =
          jsonDecode(utf8.decode(base64.decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        campaignList = List<CampaignData>.from(
            responseDecoded["response"].map((x) => CampaignData.fromJson(x)));
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }
}
