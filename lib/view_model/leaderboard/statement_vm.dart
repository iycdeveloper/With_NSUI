import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';import 'package:iyc/app/data/resources/repository/leaderboard_repo.dart';

class StatementVM extends ChangeNotifier {
  DioClient dioClient = sl();

  List<dynamic>? pointStatement;

  bool isLoading = true;

  String selectedMonth = '${DateTime.now().month}';
  int selectedYear = DateTime.now().year;

  List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  List<int> monthsNumber = [1,2,3,4,5,6,7,8,9,10,11,12];

  List<int> years = List.generate(10, (index) => DateTime.now().year - index);

  initPage() async {
    getPointStatement();
  }

  getPointStatement() async {

    ApiResponse apiRatingResponse = await LeaderBoardRepo().getPointStatement(selectedMonth, '$selectedYear');
    if (apiRatingResponse.response != null &&
        apiRatingResponse.response!.statusCode == 200) {
      var responseDecoded =
      jsonDecode(utf8.decode(base64.decode(apiRatingResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        pointStatement = responseDecoded['response'];
      }else{
        pointStatement = [];
      }
    }
    notifyListeners();
  }


  void showDropdown(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Month'),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(months.length, (index) =>InkWell(
                  onTap: (){
                    selectedMonth = '${monthsNumber[index]}';
                    notifyListeners();
                    Navigator.pop(context);
                    pointStatement = null;
                    notifyListeners();
                    getPointStatement();
                  },
                    child: Card(child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('${monthsNumber[index]}: ${months[index]}'),
                    ))),

                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showDropdownYear(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Year'),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(years.length, (index) =>InkWell(
                    onTap: (){
                      selectedYear = years[index];
                      notifyListeners();
                      Navigator.pop(context);
                      pointStatement = null;
                      notifyListeners();
                      getPointStatement();
                    },
                    child: Card(child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('${years[index]}'),
                    ))),

                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
