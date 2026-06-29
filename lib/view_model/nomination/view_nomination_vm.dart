import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/constant_repo.dart';
import 'package:iyc/helper/api_config.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/data_model/nomination_member.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/blocks.dart';
import 'package:iyc/model/offline_model/database/booth.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/model/offline_model/database/mandalam.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:iyc/provider/nomination/nominations_provider.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/constants.dart';
import 'package:provider/src/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../di_container.dart';
import '../../utils/utils.dart';

class ViewNominationVm extends ChangeNotifier {
  final ApiConfig apiConfig = sl<ApiConfig>();
  late NominationMember nominationMember;

  late List<DropdownItem> categoryList = [
    DropdownItem("General", "G"),
    DropdownItem("MBC", "B"),
    DropdownItem("Minority", "M"),
    DropdownItem("NT/VJNT", "V"),
    DropdownItem("OBC", "O"),
    DropdownItem("SC", "S"), //
    DropdownItem("ST", "T"), //
    DropdownItem(
        "Physically Handicapped", "PH"), //  need to upload category docment
    DropdownItem("Unknown", "U"),
  ];
  late List<Districts> districtList;
  late List<Assembly> assemblyList;
  late List<States> stateList;
  late List<Blocks> blocksList;
  late List<Mandalam>? mandalamList;
  late List<Booth> boothsList;

  bool isLoading = false;
  late String orderId;
  late String amountTobePaid;

  void setNominationData(member) async {
    try {
      isLoading = true;
      nominationMember = member;
      Log.printILog(nominationMember.stateCode);
      // stateList = await DbServices.db.getAllStates(true);
      stateList = await getStatesList();
      //
      // districtList = await DbServices.db.getDistrict(stateList.firstWhere(
      //     (element) => element.stateCode == nominationMember.stateCode));
      districtList = await getDistrictList(nominationMember.stateCode);

      if (nominationMember.assemblyCode != null) {
        assemblyList = await getAssemblyList(
            nominationMember.stateCode!, nominationMember.districtCode!);
        // assemblyList = await DbServices.db.getAllAssembly(
        //     districtList.firstWhere((element) =>
        //         element.districtCode == nominationMember.districtCode));
      }
      Log.printDLog('-----------------------------------------');
      // var test = assemblyList.firstWhere(
      //         (element) => element.assemblyCode == nominationMember.assemblyCode);
      // Log.printDLog(assemblyList.length);
      // if (nominationMember.blockCode != null &&
      //     nominationMember.blockCode != "0") {
      //   blocksList = await DbServices.db.getBlocks(districtList.firstWhere(
      //       (element) =>
      //           element.districtCode == nominationMember.districtCode));
      // }

      // if (nominationMember.mandalamCode != null &&
      //     nominationMember.mandalamCode != '') {
      //   mandalamList = await DbServices.db.getAllMandalams(
      //       assemblyList.firstWhere((element) =>
      //           element.assemblyCode == nominationMember.assemblyCode));
      // }

      boothsList = await getBoothList(nominationMember.stateCode!,
          nominationMember.districtCode!, nominationMember.assemblyCode!);
    } catch (e) {
      Log.printELog(e);
    }

    // boothsList = await DbServices.db.getBooths(blocksList.firstWhere(
    //     (element) => element.blockCode == nominationMember.blockCode));

    isLoading = false;
    notifyListeners();
  }

  getStatesList() async {
    // stateList = await DbServices.db.getAllStates(true); // true pick all states
    var result = await getStateBallots();
    if (result == null) {
      stateList = [];
    } else {
      stateList = [];
      for (var i in result) {
        stateList.add(States(
            id: 0,
            name: i['state_name'],
            stateCode: i['state_code'],
            isEnabled: ''));
      }
    }

    // selectedStateName = selectedState!.name;
    notifyListeners();
  }

  getDistrictList(String? statecode) async {
    var result = await getDistrictBallots(statecode!);
    if (result == null) {
      districtList = [];
    } else {
      districtList = [];
      for (var i in result) {
        districtList.add(Districts(
            id: 0,
            name: i['district'],
            stateCode: statecode,
            isEnabled: '',
            districtCode: i['district_code']));
      }
    }

    notifyListeners();
    return true;
  }

  getAssemblyList(String statecode, String district) async {
    // assemblyList = await DbServices.db
    //     .getAllAssembly(selectedDistrict!, stateCode: selectedState!.stateCode);

    var result = await getUniversityBallots(statecode, district);
    if (result == null) {
      assemblyList = [];
    } else {
      assemblyList = [];
      for (var i in result) {
        assemblyList!.add(Assembly(
            id: 0,
            districtCode: district,
            name: i['university'],
            stateCode: statecode,
            isEnabled: '',
            assemblyCode: i['university_code']));
      }
    }
    notifyListeners();
    return true;
  }

  getBoothList(String statecode, String district, String assembly) async {
    List<Booth> _boothList = [];
    var result = await getCollegeBallots(statecode, district, assembly);
    if (result == null) {
      _boothList = [];
    } else {
      _boothList = [];
      for (var i in result) {
        _boothList.add(Booth(
            id: 0,
            districtCode: district,
            stateCode: statecode,
            assemblyCode: assembly,
            blockCode: '',
            boothCode: i['college_code'],
            boothName: i['college']));
      }
    }

    return _boothList;
  }

  ConstantApiRepo constantApiRepo = ConstantApiRepo(dioClient: sl());

  Future<dynamic> getStateBallots() async {
    ApiResponse apiResponse = await constantApiRepo.getStateBallotApi();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        return responseDecoded["response"];
      } else {
        CustomSnackBar.showErrorSnackBar(
          "No data Found : State",
        );
        return null;
      }
    }
    CustomSnackBar.showErrorSnackBar(
      "No data Found : State",
    );
    return null;
  }

  Future<dynamic> getDistrictBallots(String statecode) async {
    ApiResponse apiResponse =
        await constantApiRepo.getDistrictBallotApi(statecode);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        return responseDecoded["response"];
      } else {
        CustomSnackBar.showErrorSnackBar(
          "No data Found : District",
        );
        return null;
      }
    }
    CustomSnackBar.showErrorSnackBar(
      "No data Found : District",
    );
    return null;
  }

  Future<dynamic> getUniversityBallots(
      String statecode, String district) async {
    ApiResponse apiResponse =
        await constantApiRepo.getUniversityBallotApi(statecode, district);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        return responseDecoded["response"];
      } else {
        CustomSnackBar.showErrorSnackBar(
          "No data Found : University",
        );
        return null;
      }
    }
    CustomSnackBar.showErrorSnackBar(
      "No data Found : University",
    );
    return null;
  }

  Future<dynamic> getCollegeBallots(
      String statecode, String district, String assembly) async {
    ApiResponse apiResponse = await constantApiRepo.getCollegeBallotApi(
        statecode, district, assembly);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        return responseDecoded["response"];
      } else {
        CustomSnackBar.showErrorSnackBar(
          "No data Found : College",
        );
        return null;
      }
    }
    CustomSnackBar.showErrorSnackBar(
      "No data Found : College",
    );
    return null;
  }

  getNominationAmount(
    BuildContext context,
  ) async {
    showNetworkLoadingDialog(context);
    var testJsonData = '''[{
       "V":"${AppConstants.nominationVersion}",
       "ORG":"${AppConstants.orgName}",
       "CHANNEL":"${AppConstants.channel}",
       "DEVICE_ID":"${await getDeviceIdentifier()}",
       "LEVEL":"${nominationMember.level}",
       "GENDER":"${nominationMember.gender}",
       "CATEGORY":"${nominationMember.category}",
       "BPL":"${nominationMember.bplCard != "No" ? "Y" : "N"}"
      }]''';
    ApiResponse apiResponse = await apiConfig.postData(
        endpointUrl: Urls.nominationAmount, jsonData: testJsonData);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        Navigator.of(context).pop();
        amountTobePaid = responseDecoded['response']['AMOUNT'].toString();
        orderId = responseDecoded['response']['ORDER_ID'].toString();

        final result = await Alert(
          context: context,
          type: AlertType.info,
          title: "",
          style: const AlertStyle(backgroundColor: Colors.white),
          desc:
              "You are applying for the Post ${nominationMember.contestingFor} and your payable amount is  ${Constants.rupeeSymbol + responseDecoded['response']['AMOUNT'].toString()}",
          buttons: [
            DialogButton(
              child: Text(
                "OKAY",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async {
                Navigator.pop(context, true);
              },
              width: 120,
            )
          ],
        ).show();

        if (result != null && result) {
          context.read<NominationsProvider>().makeNominationPayment(
              context, orderId, amountTobePaid, nominationMember);
        }
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
      }
      notifyListeners();
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(apiResponse.error.message.toString())));
    }
  }
}
