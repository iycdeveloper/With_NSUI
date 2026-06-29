import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/app/data/resources/repository/auth_repo.dart';

class LeaderBoardListVM extends ChangeNotifier {
  bool loadingPage = false;
  List<dynamic> pointsList = [];
  List<dynamic> filteredPointsList = [];
  int currentIndex = 0;
  final FocusNode searchFocus = FocusNode();

  TextEditingController searchController = TextEditingController();
  String? selectedLeaderBoard = "S";
  Map<String, String> options = {
    // "ALL": "ALL",
    "S": "STATE",
    "D": "DISTRICT",
    "A": "ASSEMBLY"
  };

  void getLeaderboard(BuildContext context, {bool isRefresh = false}) async {
    loadingPage = true;
    if (isRefresh) notifyListeners();
    ApiResponse apiResponse =
        await sl<AuthRepo>().getLeaderBoard(selectedLeaderBoard!);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        loadingPage = false;
        pointsList = await decodeData(responseDecoded);
        filteredPointsList = pointsList;
        // boothJodoList = List<BoothJodo>.from(
        //     responseDecoded["response"].map((x) => BoothJodo.fromJson(x)));

        notifyListeners();
      } else {
        loadingPage = false;
        pointsList = [];
        notifyListeners();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }

  decodeData(dynamic responseDecoded) async {
    var result = responseDecoded["response"].map((x) => x).toList();
    return result;
  }

  void changeLeaderBoardType(
    BuildContext context,
    int? val,
  ) {
    if (val == null) return;
    currentIndex = val;
    selectedLeaderBoard = options.keys.toList()[currentIndex];
    notifyListeners();
    getLeaderboard(context, isRefresh: true);
  }

  bool showSearchOption = false;

  void toggleShowSearch(BuildContext context) async {
    showSearchOption = !showSearchOption;
    if (!showSearchOption) {
      filteredPointsList = pointsList;
    }
    notifyListeners();
    // await Alert(
    //   context: context,
    //   title: "Search ",
    //   content: Builder(builder: (context1) {
    //     return ChangeNotifierProvider.value(
    //       value: context.read<LeaderBoardListVM>(),
    //       child: Column(
    //         children: [
    //           Container(
    //             height: 200,
    //             padding: EdgeInsets.all(5),
    //             margin: EdgeInsets.all(20),
    //             decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(20),
    //                 border: Border.all()),
    //             child: TextFormField(
    //               textInputAction: TextInputAction.done,
    //               decoration: InputDecoration.collapsed(
    //                 hintText: "search By Name....",
    //               ),
    //               maxLines: null,
    //               controller: searchController,
    //             ),
    //           ),
    //         ],
    //       ),
    //     );
    //   }),
    //   buttons: [
    //     DialogButton(
    //       child: Text(
    //         "OKAY",
    //         style: TextStyle(color: Colors.white, fontSize: 20),
    //       ),
    //       onPressed: () async {
    //         Navigator.pop(context);
    //       },
    //       width: 120,
    //     )
    //   ],
    // ).show();
  }

  void searchUserByname(BuildContext context, String str) {
    filteredPointsList = pointsList
        .where((element) =>
            element["name"].toUpperCase().contains(str.toUpperCase()))
        .toList();
    notifyListeners();
  }

  void clearFilterList() {
    filteredPointsList = pointsList;
    showSearchOption = false;
    notifyListeners();
  }
}
