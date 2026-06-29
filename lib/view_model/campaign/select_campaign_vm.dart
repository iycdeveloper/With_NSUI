import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/campaign/campaign.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/app/data/resources/repository/campaign_repo.dart';

class SelectCampaignVM extends ChangeNotifier {
  bool isLoading = false;
  String? selectedCampaign;
  List<Campaign>? campaignList;
  List<DropdownItem>? campaignDropdownItems;
  bool showLeaderBoard = false;

  getCampaignList(BuildContext context) async {
    campaignList = [];
    isLoading = true;

    ApiResponse apiResponse = await CampaignRepo().getCampaignList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      var responseDecoded =
          jsonDecode(utf8.decode(base64.decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        campaignList = List<Campaign>.from(
            responseDecoded["response"].map((x) => Campaign.fromJson(x)));
        campaignDropdownItems = List.generate(
            campaignList!.length,
            (index) => DropdownItem(
                campaignList![index].name, campaignList![index].id));
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }
String? title;
  changeSelectedCampaign(value) {
    selectedCampaign = value;
    title=campaignList!.where((test)=>selectedCampaign==test.id).toString();
    // showLeaderBoard = true;
    notifyListeners();
  }

  bool isEnglish = true;
  void changeLanguage(BuildContext context) {
    if (isEnglish) {
      isEnglish = false;
    } else {
      isEnglish = true;
    }
    notifyListeners();
  }
}
