import 'dart:convert';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/rewards_repo.dart';
import 'package:iyc/model/api_model/base/api_response.dart';

class RewardsController extends GetxController {

  bool isLoading = true;

  List<dynamic> rewardsData = [];

  @override
  void onInit() async {
    await getRewardsDetails();
    super.onInit();
  }

  Future<void> getRewardsDetails() async {
    ApiResponse apiStarResponse = await RewardsRepo().getRewardsDetail();
    if (apiStarResponse.response != null &&
        apiStarResponse.response!.statusCode == 200) {
      var responseDecoded =
      jsonDecode(utf8.decode(base64.decode(apiStarResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {

        rewardsData = responseDecoded['response'];
        Log.printDLog(rewardsData);
        isLoading = false;
        update();
      }else {
        isLoading = false;
        update();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }

    }
  }
}
