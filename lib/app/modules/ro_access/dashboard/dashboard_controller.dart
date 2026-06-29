import 'dart:convert';

import 'package:get/get.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/ro_repo.dart';
import 'package:iyc/app/modules/ro_access/membership/membership_ro_controller.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';
import 'package:iyc/app/data/resources/remote/dio/logging_interceptor.dart';
import 'package:iyc/app/data/resources/urls.dart';

class DashboardController extends GetxController {
  SharedPreferences? sharedPreferences;
  late final RoRepo roRepo;
  Map<dynamic, dynamic>? roStats;
  Map<String, dynamic>? self;
  Map<String, dynamic>? total;
  List<dynamic>? team;

  String? selectedOptions;
  List<DropdownItem> options = [
    DropdownItem("Self", "0"),
    DropdownItem("Total", "1"),
    DropdownItem("Team", "2"),
  ];

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    roRepo = RoRepo();
    roRepo.dioClient = DioClient(Urls.baseUrl, Dio(),
        loggingInterceptor: LoggingInterceptor(),
        sharedPreferences: sharedPreferences!);
    await getRoStats();
    super.onInit();
  }

  void onChangeOptions(String value) {
    selectedOptions = value;
    update();
  }

  Future<void> getRoStats() async {
    ProgressDialogUtils.showProgressIndicator();
    ApiResponse apiResponse =
        await roRepo.getRoStats(roId: Get.find<MemberShipRoController>().roId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        roStats = responseDecoded["response"];
        self = roStats!['SELF'][0] as Map<String, dynamic>;
        total = roStats!['TOTAL'][0] as Map<String, dynamic>;
        team = roStats!['TEAM'] as List<dynamic>;
        Log.printDLog(roStats!['SELF'][0]);
        ProgressDialogUtils.closeDialog();
        update();
      } else {
        ProgressDialogUtils.closeDialog();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
    }
  }
}
