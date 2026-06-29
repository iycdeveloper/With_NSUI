import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/campaign/campaign_user.dart';
import 'package:iyc/app/data/resources/repository/campaign_repo.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';

import '../../model/api_model/base/api_response.dart';

class LeaderboardCampaignVM extends ChangeNotifier {
  bool isLoading = false;
  List<CampaignUser> campaignList = [];

  dynamic responseDecoded;
  getUserPoints(BuildContext context, String selectedCampaign) async {
    isLoading = true;
    ApiResponse apiResponse =
        await CampaignRepo().getCampaignLeaderboard(selectedCampaign);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        isLoading = false;
        campaignList = List<CampaignUser>.from(
            responseDecoded["response"].map((x) => CampaignUser.fromJson(x)));
      } else {
        isLoading = false;
        showCustomSnackBar(responseDecoded["response"], context);
      }
      notifyListeners();
    }
    notifyListeners();
  }
}
