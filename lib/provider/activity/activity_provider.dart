import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/app/data/resources/repository/activity_repo.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';

class ActivityApiProvider  {
  final ActivityRepo activityRepo;

  ActivityApiProvider({required this.activityRepo});

  void userActivity({
    required BuildContext context,
    required String postId, required String postType
  }) async {
    showNetworkLoadingDialog(context);
    ApiResponse apiResponse = await activityRepo.userActivity(postId: postId,
    postType: postType);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
      jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        Navigator.of(context).pop();

      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
      }

    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
  }
}
