import 'package:flutter/material.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/screens/ui/membership_ui/membership.dart';
import 'package:iyc/view_model/members/member_page_vm.dart';
import 'package:iyc/view_model/members/members_list_vm.dart';
import 'package:iyc/view_model/membership/membership_vm.dart';
import 'package:provider/provider.dart';

import 'member_page.dart';

class MembersListCard extends StatefulWidget {
  const MembersListCard({Key? key, required this.member}) : super(key: key);
  final BatchMember member;

  @override
  State<MembersListCard> createState() => _MembersListCardState();
}

class _MembersListCardState extends State<MembersListCard> {
  // MembersListVM? _myProvider;
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
// void didChangeDependencies() {
//   super.didChangeDependencies();
//   _myProvider ??= Provider.of<MembersListVM>(context); // Save reference once
// }

// // @override
// // void dispose() {
// //   _myProvider?.cleanup(); // Use saved reference
// //   super.dispose();
// // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!widget.member.isIncMember!) {
          final data = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => widget.member.isSync == "1"
                  ? ChangeNotifierProvider(
                      child: MemberPage(
                        member: widget.member,
                      ),
                      create: (context) => MemberPageVM(),
                    )
                  : ChangeNotifierProvider(
                      create: (context) => MembershipVM(),
                      child: MemberShip(
                        member: widget.member,
                        isUpdate: true,
                      ))));
          context
              .read<MembersListVM>()
              .getMembershipList(context, widget.member.batchId!);
          if (data.toString().toLowerCase().contains('completed')) {
            context.read<MembersListVM>().setautoSync();
            context.read<MembersListVM>().initiateSyncMembership(
                context.read<MembersListVM>().scaffoldKey.currentContext!);
          } else {
            context
                .read<MembersListVM>()
                .getMembershipList(context, widget.member.batchId!);
            context.read<MembersListVM>().manualSync(context);
          }
        } else {}
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.065,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.primaries[5].shade700)),
        child: Row(
          children: [
            Expanded(
              child: Text(widget.member.memberId!),
              flex: 1,
            ),
            Expanded(
              child:
                  Text(widget.member.isSync == "1" ? "Completed" : "Pending"),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
