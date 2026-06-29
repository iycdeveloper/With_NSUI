import 'package:flutter/cupertino.dart';
import 'package:iyc/model/api_model/batch/batch_data_model.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/model/offline_model/database/nominations.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:iyc/app/data/resources/db_provider/membership/batch_db_repo.dart';
import 'package:iyc/app/data/resources/db_provider/membership/membership_db_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';

import '../../di_container.dart';

class SelectIncNominationVM extends ChangeNotifier {
  final MembershipMemberDB membershipDbRepo = sl<MembershipMemberDB>();

  bool isLoading = false;
  late BatchMember incMember;

  List<Nomination> statePresidentNominationsList = [];
  List<Nomination> stateGeneralSecretaryNominationsList = [];

  List<Nomination> districtNominationsList = [];
  List<Nomination> assemblyNominationsList = [];
  States? selectedState;
  Districts? selectedDistrict;
  Assembly? selectedAssembly;

  late List<Districts> districtList;
  late List<Assembly> assemblyList;
  late List<States> stateList;

  String? selectedStatePresidentNominations;

  String? selectedStateGSNominations;
  String? selectedDistrictNominations;
  String? selectedAssemblyNominations;

  void setInitialMember(BatchMember incMember, BuildContext context) async {
    isLoading = true;
    this.incMember = incMember;
    stateList = await DbServices.db.getAllStates();
    districtList = await DbServices.db.getDistricts(stateList
        .firstWhere((element) => element.stateCode == incMember.stateCode));
    assemblyList = await DbServices.db.getAssembly(districtList.firstWhere(
        (element) => element.districtCode == incMember.districtCode));

    selectedState = stateList
        .firstWhere((element) => element.stateCode == incMember.stateCode);
    selectedDistrict = districtList.firstWhere(
        (element) => element.districtCode == incMember.districtCode);
    selectedAssembly = assemblyList
            .any((element) => element.assemblyCode == incMember.assemblyCode)
        ? assemblyList.firstWhere(
            (element) => element.assemblyCode == incMember.assemblyCode)
        : null;

    final result = await Future.wait([
      searchForStatePresidentNominations(context),
      searchForStateGeneralSecreNominations(context),
      searchForDistrictNominations(context),
    ]);
    print(result);
    isLoading = false;
    notifyListeners();
  }

  Future searchForStatePresidentNominations(BuildContext context) async {
    ///getting selected state/district/assembly code

    ///get state data list from db
    statePresidentNominationsList = await DbServices.db
        .searchForStateNominations(
            stateCode: selectedState!.stateCode,
            contestingFor: "State President");
    statePresidentNominationsList.add(Nomination(
        id: 123456789,
        name: "NO Vote",
        csn: 0,
        firstName: "No Vote",
        lastName: ""));
    return statePresidentNominationsList.length;
    // notifyListeners();
  }

  Future searchForStateGeneralSecreNominations(BuildContext context) async {
    ///getting selected state/district/assembly code

    ///get state data list from db
    stateGeneralSecretaryNominationsList = await DbServices.db
        .searchForStateNominations(
            stateCode: selectedState!.stateCode,
            contestingFor: "State General Secretary");
    stateGeneralSecretaryNominationsList.add(Nomination(
        id: 123456789,
        name: "NO Vote",
        csn: 0,
        firstName: "No Vote",
        lastName: ""));
    return stateGeneralSecretaryNominationsList.length;
    //  notifyListeners();
  }

  Future searchForDistrictNominations(BuildContext context) async {
    districtNominationsList = await DbServices.db.searchForDistrictNominations(
        stateCode: selectedState!.stateCode,
        districtCode: selectedDistrict!.districtCode,
        contestingFor: "District");
    if (districtNominationsList.isEmpty) {
      districtNominationsList = [
        Nomination(
            id: 123456789,
            name: "NO Nomination",
            csn: 999,
            firstName: "No Nomination",
            lastName: "")
      ];
    } else {
      districtNominationsList.add(Nomination(
          id: 123456789,
          name: "NO Vote",
          csn: 0,
          firstName: "No Vote",
          lastName: ""));
    }
    return 0;
    // notifyListeners();
  }

  changeStateNomination(String val) {
    selectedStatePresidentNominations = val;
    notifyListeners();
  }

  changeStateGSNomination(String val) {
    selectedStateGSNominations = val;
    notifyListeners();
  }

  changeDistrictNomination(String val) {
    selectedDistrictNominations = val;
    notifyListeners();
  }

  changeAssemblyNomination(String val) {
    selectedAssemblyNominations = val;
    notifyListeners();
  }

  populateToModel() {
    incMember
      ..statePresidentCandidate = selectedStatePresidentNominations ?? ""
      ..stateGSCandidate = selectedStateGSNominations ?? ""
      ..districtCandidate = selectedDistrictNominations ?? ""
      ..assemblyCandidate = selectedAssemblyNominations ?? "";
  }

  onSubmit(BuildContext context) async {
    if (false) {
      /// is update
      await membershipDbRepo.updateMembershipTable(incMember);
    } else {
      await membershipDbRepo.insertData(incMember);
      final list = await membershipDbRepo.getData(incMember.batchId!);
      int count = list.length;
      await sl<BatchDBRepo>().updateAMCount(
          BatchDataModel(batchId: incMember.batchId!, countAM: count));

      Navigator.of(context)
          .popUntil((route) => route.settings.name == "members_list");
    }
  }
}
