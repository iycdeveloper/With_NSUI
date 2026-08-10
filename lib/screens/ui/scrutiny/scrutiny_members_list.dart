import 'package:iyc/screens/ui/scrutiny/widgets/scrutiny_theme.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:iyc/view_model/scrutiny/member/scrutiny_members_list_vm.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:provider/provider.dart';

import 'scrunity_members_list_card.dart';

class ScrutinyMembersList extends StatefulWidget {
  const ScrutinyMembersList({
    Key? key,
    required this.batchId,
    required this.syncStatus,
  }) : super(key: key);

  final String batchId;
  final bool syncStatus;

  @override
  _ScrutinyMembersListState createState() => _ScrutinyMembersListState();
}

class _ScrutinyMembersListState extends State<ScrutinyMembersList> {
  @override
  void initState() {
    context.read<ScrutinyMembersListVM>().scrutinyDownloadBatchMembers(
        context: context, batchId: widget.batchId);

    // ///fetch membership data
    // context
    //     .read<ScrutinyMembersVM>()
    //     .getMembershipList(context, widget.batchId);
    super.initState();
  }

  // @override

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Log.printILog("On Will Pop");
        await context.read<ScrutinyMembersListVM>().getScrutinyMembersList(context, widget.batchId);
        if (!context.read<ScrutinyMembersListVM>().checkScrutinyListSynced()) {
          Log.printILog("On Will Pop");
          showCustomSnackBar("Kindly Sync batches before close page", context);
          return false;
        }
        return true;
      },
      child: Container(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.white,
            title: Text('${widget.batchId}',
                style: const TextStyle(
                    color: ScrutinyTheme.brand,
                    fontSize: 19,
                    fontWeight: FontWeight.bold)),
            leading: IconButton(
                onPressed: () async {
                  if (!context
                      .read<ScrutinyMembersListVM>()
                      .checkScrutinyListSynced()) {
                    showCustomSnackBar(
                        "Kindly Sync batches before close page", context);
                    return;
                  }
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back,
                    color: ScrutinyTheme.brand)),
            actions: [
              IconButton(
                  onPressed: () async {
                    await context
                        .read<ScrutinyMembersListVM>()
                        .syncScrutinyBatch(context);
                    // final result = await AwsUploadServices().uploadFile(
                    //     file: File(context
                    //         .read<ScrutinyMembersVM>()
                    //         .scrutinyMemberstList
                    //         .first
                    //         .amPhotoFilePath!),
                    //     destDir: "MEMBERSHIP/TS/OM/TS90400054901",
                    //     filename: "TS90400054902_CATEGORY_DOC.jpg");
                    // print(result);
                  },
                  icon: const Icon(
                    Icons.sync_rounded,
                    color: ScrutinyTheme.brand,
                  ))
            ],
          ),
          // floatingActionButton: FloatingActionButton(
          //   child: Center(
          //       child: Icon(
          //     CupertinoIcons.plus,
          //     size: 30,
          //     color: Constants.themeGradients[1],
          //   )),
          //   backgroundColor: Constants.themeGradients[0],
          //   foregroundColor: Colors.white,
          //   elevation: 1,
          //   onPressed: () async {
          //     /// create new membership
          //
          //     await Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context1) => ChangeNotifierProvider(
          //               create: (context) => MembershipVM(),
          //               child: MemberShip(
          //                 member: BatchMember(
          //                     memberId: (context
          //                                         .read<ScrutinyMembersVM>()
          //                                         .membershipRequestList
          //                                         .length +
          //                                     1)
          //                                 .toString()
          //                                 .length <
          //                             2
          //                         ? widget.batchId +
          //                             (context
          //                                         .read<ScrutinyMembersVM>()
          //                                         .membershipRequestList
          //                                         .length +
          //                                     1)
          //                                 .toString()
          //                                 .padLeft(1, "0")
          //                         : widget.batchId +
          //                             (context
          //                                         .read<ScrutinyMembersVM>()
          //                                         .membershipRequestList
          //                                         .length +
          //                                     1)
          //                                 .toString(),
          //                     batchId: widget.batchId,
          //                     isSync: "0"),
          //               ),
          //             )));
          //     context
          //         .read<ScrutinyMembersVM>()
          //         .getMembershipList(context, widget.batchId);
          //   },
          // ),
          body: ScrutinyPageBackground(
            child: Consumer<ScrutinyMembersListVM>(
            builder: (_, val, __) => val.loading
                ? NetworkLoading()
                : val.scrutinyMemberstList.isNotEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            const ScrutinyHero(
                              icon: Icons.groups_2_rounded,
                              title: 'Members',
                              subtitle: 'Review and correct flagged records ✍️',
                            ),
                            const SizedBox(height: 6),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: Text('AM ID',
                            //           style: TextStyle(
                            //               color: Colors.black45,
                            //               fontSize: 12,
                            //               fontWeight: FontWeight.w500)),
                            //     ),
                            //     // Expanded(
                            //     //   child: Text('Sync',
                            //     //       style: TextStyle(
                            //     //           color: Colors.black45,
                            //     //           fontSize: 12,
                            //     //           fontWeight: FontWeight.w500)),
                            //     // ),
                            //   ],
                            // ),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: val.scrutinyMemberstList.length,
                                itemBuilder: (context, index) =>
                                    ScrutinyMembersListCard(
                                        provider:
                                            Provider.of<ScrutinyMembersListVM>(
                                                context,
                                                listen: false),
                                        member:
                                            val.scrutinyMemberstList[index])),
                            const SizedBox(height: 24),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 80),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: ScrutinyTheme.brand.withOpacity(0.08),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.group_off_outlined,
                                  size: 34, color: ScrutinyTheme.brand),
                            ),
                            const SizedBox(height: 16),
                            const Text("No members in this batch",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: ScrutinyTheme.ink)),
                          ],
                        ),
                      ),
          ),
          ),
        ),
      ),
    );
  }
}
