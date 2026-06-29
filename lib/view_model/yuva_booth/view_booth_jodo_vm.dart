import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/yuva_user/booth_jodo.dart';
import 'package:iyc/app/data/resources/repository/yuva_booth_repo.dart';

import '../../di_container.dart';

class ViewBoothJodoVM extends ChangeNotifier {
  bool loadingPage = false;
  List<BoothJodo> boothJodoList = [];

  void getBoothJodos(BuildContext context) async {
    loadingPage = true;
    ApiResponse apiResponse = await sl<YuvaBoothRepo>().getBoothJodos();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        loadingPage = false;

        boothJodoList = List<BoothJodo>.from(
            responseDecoded["response"].map((x) => BoothJodo.fromJson(x)));
        final temp = boothJodoList.reversed;
        boothJodoList = temp.toList();
        notifyListeners();
      } else {
        loadingPage = false;
        notifyListeners();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }
}
