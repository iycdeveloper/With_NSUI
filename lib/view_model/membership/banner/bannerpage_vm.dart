import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/membership/banner/question.dart';
import 'package:iyc/app/data/resources/repository/banner_repo.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';

class BannerPageVM extends ChangeNotifier {
  bool loadingPage = false;

  List<Question> questionList = [];
  Map<String, dynamic> selectedAnswerList = {};

  getBannerList(BuildContext context) async {
    loadingPage = true;
    ApiResponse apiResponse = await BannerRepo().getBanners();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        questionList = List.generate(2, (idx) {
          var index = idx + 1;
          if (responseDecoded["response"][0]["question_${index}_type"] ==
              "CB") {
            selectedAnswerList.addAll({"question_${index}": []});
          } else
            selectedAnswerList.addAll({"question_${index}": null});
          return Question(
              id: responseDecoded["response"][0]["id"],
              unicornId: responseDecoded["response"][0]["unicorn_id"],
              question: responseDecoded["response"][0]["question_${index}"],
              questionType: responseDecoded["response"][0]
                  ["question_${index}_type"],
              answers: responseDecoded["response"][0]["question_${index}_ans"]
                  .toString()
                  .split(","),
              imageLink: responseDecoded["response"][0]["image_link"]);
        });

        // log(responseDecoded["response"].toString());
        // boothJodoList = List<BoothJodo>.from(
        //     responseDecoded["response"].map((x) => BoothJodo.fromJson(x)));
        loadingPage = false;
        notifyListeners();
      } else {
        loadingPage = false;
        notifyListeners();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }

  onChangeAnswer(Question question, int index, dynamic value,
      {dynamic cbName}) {
    if (question.questionType == "CB" && value is bool) {
      if (value) {
        selectedAnswerList["question_$index"].add(cbName);
      } else {
        selectedAnswerList["question_$index"].remove(cbName);
      }
      notifyListeners();
    } else {
      selectedAnswerList["question_$index"] = value;
      notifyListeners();
    }
  }

  bool validateForm(BuildContext context) {
    bool validatedSuccess = true;
    if (selectedAnswerList.values.contains("") ||
        selectedAnswerList.values.contains(null)) {
      showCustomSnackBar("Kindly Choose  Answers", context);
      validatedSuccess = false;
    }

    return validatedSuccess;
  }

  void submit(BuildContext context) async {
    showNetworkLoadingDialog(context);

    Map<String, String> data = {
      "BANNER_ID": "1",
      "ANSWER_1": "${selectedAnswerList["question_1"]}",
      "ANSWER_2": "${selectedAnswerList["question_2"]}",
      "ANSWER_3": "",
      "ANSWER_4": "",
      "ANSWER_5": "",
    };

    ApiResponse apiResponse = await BannerRepo().submitAnswers(data);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        Navigator.of(context).pop(); // loading dialog

        Navigator.of(context).pop(true); // page close

      } else {
        Navigator.of(context).pop(); //loading

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    } else {
      Navigator.of(context).pop(); // pop loading

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error)));
    }
  }
}
