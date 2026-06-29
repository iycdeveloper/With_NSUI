import 'package:flutter/cupertino.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/data/resources/services/iyc_db_services.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/app/data/resources/db_provider/scrutiny/scrutiny_members_db_repo.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../../di_container.dart';

class ScrutinyMembershipEditVM extends ChangeNotifier {
  late Database database;
  late ScrutinyMembershipDBRepo _scrutinyMembershipDBRepo;

  Future<void> onInit() async {
    database = await IycDbServices.db.database as Database;
    _scrutinyMembershipDBRepo = ScrutinyMembershipDBRepo(database);

  }

  // _scrutinyMembershipDBRepo = ScrutinyMembershipDBRepo(database);
  // ScrutinyMembershipEditVM();

  BatchMember? currentMember;
  bool isLoading = false;

  // getCurrentMember(String memberId) async {
  //   memberId = memberId;
  //   isLoading = true;
  //   /// for edit mode fetch data from table
  //   await MembershipSaveSqlProvider(databaseSql: sl())
  //       .getDatabaseRow(memberId)
  //       .then((value) {
  //     currentMember =
  //         value.firstWhere((element) => element.membershipId == memberId);
  //     isLoading = false;
  //     notifyListeners();
  //   });
  // }

  setCurrentMember(BatchMember membershipRequestModel) {
    currentMember = membershipRequestModel;
  }

  scrutinyMemberSaveToDB(BuildContext context, bool isUpdate) async {
    if (isUpdate) {
      Log.printILog(currentMember!.isEditedScrutiny = "1");
      currentMember!.isEditedScrutiny = "1";
      await _scrutinyMembershipDBRepo.updateMembershipTable(currentMember!);
      notifyListeners();
    } else
      await _scrutinyMembershipDBRepo.insertData(currentMember!);
  }
}
