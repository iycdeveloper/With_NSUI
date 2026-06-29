import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/provider/scrutiny/member/scrutiny_member_edit_vm.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/scrutiny/member/scrutiny_members_list_vm.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'members/scrutiny_members_edit_home.dart';

class ScrutinyMembersListCard extends StatelessWidget {
  const ScrutinyMembersListCard(
      {Key? key, required this.member, required this.provider})
      : super(key: key);
  final BatchMember member;
  final ScrutinyMembersListVM provider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Alert(
          context: context,
          style: AlertStyle(backgroundColor: Colors.white),
          type: AlertType.info,
          title: "WITH IYC",
          desc: member.reason!.replaceAll(";", " ").trimRight(),
          buttons: [
            DialogButton(
              color: Constants.themeGradients[0],
              child: Text(
                "OKAY",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              onPressed: () async {
                Navigator.pop(context);
                // toPage(
                //     context,
                //     ChangeNotifierProvider(
                //       create: (context) => ScrutinyMembershipEditVM(),
                //       child: ScrutinyMembershipEditHomePage(
                //         scrutinyMembersListVM: provider,
                //         member: member,
                //         isUpdate: true,
                //       ),
                //     ));
                var result = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                          create: (context) => ScrutinyMembershipEditVM(),
                          child: ScrutinyMembershipEditHomePage(
                            scrutinyMembersListVM: provider,
                            member: member,
                            isUpdate: true,
                          ),
                        )));
                Log.printILog(result);
                context
                    .read<ScrutinyMembersListVM>()
                    .getScrutinyMembersList(context, member.batchId!);
              },
              width: 120,
            )
          ],
        ).show();
        await provider.getScrutinyMembersList(context, member.batchId!);
      },
      child: Container(
        height: 60,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: (member.isSync == "1" && member.isEditedScrutiny == "1")
                ? Colors.greenAccent.withOpacity(0.3)
                : member.isEditedScrutiny == "1"
                    ? Colors.redAccent.withOpacity(0.3)
                    : Colors.white,
            border: Border.all(color: Colors.primaries[5].shade700)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(member.firstName!,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    Text(
                      member.memberId!,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800),
                    ),
                  ]),
              flex: 1,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                child: Text(
                  "Details",
                ),
                onTap: () async {
                  await Alert(
                    context: context,
                    style: AlertStyle(backgroundColor: Colors.white),
                    type: AlertType.info,
                    title: "WITH IYC",
                    desc: member.reason!.replaceAll(";", " "),
                    buttons: [
                      DialogButton(
                        color: Constants.themeGradients[0],
                        child: Text(
                          "OKAY",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ScrutinyMembershipEditHomePage(
                                    scrutinyMembersListVM: provider,
                                    member: member,
                                    isUpdate: true,
                                  )));
                          context
                              .read<ScrutinyMembersListVM>()
                              .getScrutinyMembersList(context, member.batchId!);
                        },
                        width: 120,
                      )
                    ],
                  ).show();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
