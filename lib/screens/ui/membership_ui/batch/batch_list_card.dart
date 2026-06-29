import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/batch/batch_data_model.dart';
import 'package:iyc/provider/batch/batch_list_provider.dart';
import 'package:iyc/provider/membership_register/membership_api_providers/membership_list_provider.dart';
import 'package:iyc/screens/ui/members/members_list.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/members/members_list_vm.dart';
import 'package:provider/provider.dart';

import '../../../../di_container.dart';

class BatchListCard extends StatelessWidget {
  const BatchListCard({Key? key, required this.batch}) : super(key: key);
  final BatchDataModel batch;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        ///fetch membership data
        await Provider.of<MembershipListProvider>(context, listen: false)
            .getMembershipList( batch.batchId);
        await toPage(
            context,
            // MembershipMain(
            //   batchId: batch.batchId,
            //   syncStatus: batch.syncStatus! == "1" ? true : false,
            // )
            ChangeNotifierProvider(
              create: (context) => MembersListVM(apiConfig: sl()),
              child: MembersList(
                  batchId: batch.batchId,
                  syncStatus: batch.syncStatus! == "1" ? true : false),
            ),
            routeSettingName: "members_list");
        context
            .read<BatchListProvider>()
            .getMembershipBatchList(context, reload: true);
      },
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.065,
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.primaries[5].shade700)),
            child: Row(
              children: [
                Expanded(
                  child: Text(batch.batchId),
                  flex: 3,
                ),
                Expanded(
                  child: Text(batch.countAM.toString()),
                  flex: 1,
                ),
                Expanded(
                  child:
                      Text(batch.paymentStatus == "PAID" ? "Paid" : "Pending"),
                  flex: 2,
                ),
                Expanded(
                  child: Text(
                    batch.syncStatus! == "1" ? "Completed" : "Pending",
                  ),
                  flex: 2,
                ),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
