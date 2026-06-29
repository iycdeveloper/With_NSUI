import 'dart:convert';
import 'package:get/get.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/campaign_repo.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/campaign/campaign.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';

class SelectCampaignController extends GetxController{
  bool isLoading = true;
  String? selectedCampaign;
  List<Campaign>? campaignList;
  List<DropdownItem>? campaignDropdownItems;

  @override
  void onInit() async {
    getCampaignList();
    super.onInit();
  }

  void getCampaignList() async {
    campaignList = [];
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
        update();
      } else {
        isLoading = false;
        update();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
    }
  }

  void changeSelectedCampaign(value) {
    Log.printDLog(value);
    selectedCampaign = value;
    update();
  }
}