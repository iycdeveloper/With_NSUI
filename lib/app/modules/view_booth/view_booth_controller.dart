import 'dart:convert';

import 'package:get/get.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/yuva_booth_repo.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/yuva_user/booth_jodo.dart';

class ViewBoothController extends GetxController {
  bool loadingPage = true;
  List<BoothJodo> boothJodoList = [];

  int currentIndex = -1;
  @override
  void onInit() {
    getBoothJodoList();
    super.onInit();
  }

  void updateIndex(int index){
    if(currentIndex == index){
      currentIndex = -1;
    }
    else{
      currentIndex = index;
    }
    update();
  }

  void getBoothJodoList() async {
    ApiResponse apiResponse = await YuvaBoothRepo().getBoothJodos();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        loadingPage = false;
        boothJodoList = List<BoothJodo>.from(
            responseDecoded["response"].map((x) => BoothJodo.fromJson(x)));
        final temp = boothJodoList.reversed;
        boothJodoList = temp.toList();
        update();
      } else {
        loadingPage = false;
        update();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
    }
  }
}
