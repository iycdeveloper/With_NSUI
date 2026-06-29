import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/batch/batch_data_model.dart';
import 'package:iyc/view_model/scrutiny/member/scrutiny_members_list_vm.dart';
import 'package:iyc/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../../../di_container.dart';
import '../scrutiny_members_list.dart';

class ScrutinyBatchListCard extends StatelessWidget {
  const ScrutinyBatchListCard({Key? key, required this.batch})
      : super(key: key);
  final BatchDataModel batch;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // ///fetch membership data
        // await Provider.of<ScrutinyMembersVM>(context, listen: false)
        //     .getMembershipList(context, batch.batchId);
        await toPage(
          context,
          // MembershipMain(
          //   batchId: batch.batchId,
          //   syncStatus: batch.syncStatus! == "1" ? true : false,
          // )
          // ChangeNotifierProvider(
          //   create: (context) =>
          //     ScrutinyMembersVM(
          //     scrutinyDBProvider:Provider.of<ScrutinyMembershipDBProvider>(context, listen: false),
          //     membershipRepo:Provider.of<ScrutinyRepo>(context, listen: false)),
          // child:

          // ChangeNotifierProvider(
          //   create: (context) => sl<ScrutinyMembersVM>(),
          //   child:
          ChangeNotifierProvider(
            create: (context) => ScrutinyMembersListVM(
              scrutinyRepo: sl(),
            ),
            child: ScrutinyMembersList(
              batchId: batch.batchId,
              syncStatus: batch.syncStatus! == "1" ? true : false,
            ),
          ),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.065,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.primaries[5].shade700)),
        child: Row(
          children: [
            Expanded(
              child: Text(
                batch.batchId,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800),
              ),
              flex: 2,
            ),
            Expanded(
              child: Text(
                batch.countAM.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
              ),
              flex: 1,
            ),
            // Expanded(
            //   child: Text(
            //     batch.syncStatus! == "1" ? "Completed" : "PENDING",
            //   ),
            //   flex: 1,
            // ),
            Expanded(
              child: Text(batch.onhold ?? "0",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.deepOrange, fontWeight: FontWeight.bold)),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
