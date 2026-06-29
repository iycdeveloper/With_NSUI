import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/membership/membership_download.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/app/data/resources/db_provider/membership/membership_db_repo.dart';
import 'package:iyc/app/data/resources/repository/membership_repo.dart';
import 'package:iyc/screens/ui/membership_ui/batch/batch_main.dart';

import '../../../di_container.dart';

class MembershipListProvider extends ChangeNotifier {
  final MembershipRepo membershipRepo;
  final MembershipMemberDB membershipDbRepo = sl<MembershipMemberDB>();
  MembershipListProvider({
    required this.membershipRepo,
  });

  List<BatchMember> _membershipRequestList = [];

  List<BatchMember> get membershipRequestList => _membershipRequestList;
  bool loading = true;

  Future<bool> willPopCallback(BuildContext context, String batchId) async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => BatchMain()));
    return true;
  }

  getMembershipList( String batchId) async {
    //  await agrDownloadMembers(context: context, batchId: batchId);
    _membershipRequestList = await membershipDbRepo.getData(batchId);
    loading = false;
    notifyListeners();
  }

  Future<bool> agrDownloadMembers({
    required BuildContext context,
    required String batchId,
  }) async {
    bool returnValue = false;
    ApiResponse apiResponse = await membershipRepo.downloadMembers(batchId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        /// add api membership data to local db
        MembershipDownloadResponse memberData =
            MembershipDownloadResponse.fromJson(responseDecoded);
        memberData.response.batchMember!.forEach((element) async {
          element.isSync = "1";
          await membershipDbRepo.insertData(element);

          /// add batch am count
          // Provider.of<BatchListProvider>(context, listen: false)
          //     .updateAMCount(
          //     context: context,
          //     data:
          //     BatchDataModel(batchId: batchId, countAM: value + 1));

          ///update batch list
          // Provider.of<MembershipListProvider>(context, listen: false)
          //     .getMembershipList(context, batchId);

          returnValue = true;
        });
        //  Navigator.of(context).pop();

      } else {
        //  Navigator.of(context).pop();
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
        returnValue = false;
      }
      notifyListeners();
    } else {
      //  Navigator.of(context).pop();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
      returnValue = false;
    }

    return returnValue;
  }
}
