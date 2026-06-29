import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/category.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:iyc/app/data/resources/repository/membership_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import '../../di_container.dart';

class SearchIncMemberVM extends ChangeNotifier {
  bool loadingPage = false;
  bool showINCMember = false;
  late BatchMember incMember;
  late List<Category> categoryList;
  late List<Districts> districtList;
  late List<Assembly> assemblyList;
  late List<States> stateList;
  final membersRepo = sl<MembershipRepo>();
  searchMember(BuildContext context, String memberId, String batchId) async {
    categoryList = await DbServices.db.getAllCategory();
    stateList = await DbServices.db.getAllStates();

    loadingPage = true;
    showINCMember = false;
    notifyListeners();

    NewApiResponse result = await membersRepo.getINCUserDetails(memberId);

    print(result.data);
    if (result.data != null) {
      print("not nu;");
      print(result.data);
      loadingPage = false;
      incMember = BatchMember.fromINCJson(result.data[0]);
      incMember.isIncMember = true;
      incMember.batchId = batchId;
      incMember.memberId = batchId + "01";
      incMember.aggrId = "${await LocalStorageServices().getAgrIDMembership()}";

      categoryList = await DbServices.db.getAllCategory();
      districtList = await DbServices.db.getDistricts(stateList
          .firstWhere((element) => element.stateCode == incMember.stateCode));
      assemblyList = await DbServices.db.getAssembly(districtList.firstWhere(
          (element) => element.districtCode == incMember.districtCode));
      showINCMember = true;
      notifyListeners();
    } else {
      loadingPage = false;
      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result.error.toString())));
    }
  }
}
