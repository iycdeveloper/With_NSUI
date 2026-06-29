
import 'package:flutter/material.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/screens/ui/members/members_list_card.dart';
import 'package:iyc/screens/ui/membership_ui/membership.dart';
import 'package:iyc/screens/widgets/network_loading.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/view_model/members/members_list_vm.dart';
import 'package:iyc/view_model/membership/membership_vm.dart';
import 'package:provider/provider.dart';

class MembersList extends StatefulWidget {
  const MembersList({Key? key, required this.batchId, required this.syncStatus})
      : super(key: key);

  final String batchId;
  final bool syncStatus;

  @override
  _MembersListState createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  @override
  void initState() {
    context.read<MembersListVM>().getMembershipList(context, widget.batchId);
    context.read<MembersListVM>().manualSync(context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: context.read<MembersListVM>().scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.batchId, style: Constants.appbarTitleTextStyle),
        backgroundColor: Constants.themeGradients[0],
        actions: [
          // widget.syncStatus
          //     ? const SizedBox.shrink()
          //     : Consumer<MembersListVM>(
          //         builder: (_, model, __) => model.isSyncMembers
          //             ? const SizedBox.shrink()
          //             : IconButton(
          //                 onPressed: () async {
          //                   if (model.membershipRequestList.isEmpty) {
          //                     CustomSnackBar.showErrorSnackBar(
          //                         'Create Atleast One Member');
          //                     return;
          //                   }

          //                   var aggrId = await LocalStorageServices()
          //                       .getAgrIDMembership();
          //                   Log.printDLog(aggrId);
          //                   TextEditingController sumController =
          //                       TextEditingController();
          //                   var random = Random();
          //                   int randomNumber1 = random.nextInt(98) + 1;
          //                   int randomNumber2 = random.nextInt(98) + 1;
          //                   mediaQueryData = MediaQuery.of(Get.context!);
          //                   Get.bottomSheet(
          //                     Container(
          //                         decoration: const BoxDecoration(
          //                             color: Colors.white,
          //                             borderRadius: BorderRadius.only(
          //                                 topLeft: Radius.circular(24),
          //                                 topRight: Radius.circular(24))),
          //                         width: double.maxFinite,
          //                         height: 372.v,
          //                         child: SingleChildScrollView(
          //                           child: Column(children: [
          //                             Container(
          //                                 decoration: BoxDecoration(
          //                                     // color: Colors.white,
          //                                     color: appTheme.indigo800,
          //                                     borderRadius:
          //                                         const BorderRadius.only(
          //                                             topLeft:
          //                                                 Radius.circular(24),
          //                                             topRight:
          //                                                 Radius.circular(24))),
          //                                 width: double.maxFinite,
          //                                 padding: EdgeInsets.symmetric(
          //                                     horizontal: 20.h, vertical: 17.v),
          //                                 // decoration: AppDecoration.heading,
          //                                 child: Row(
          //                                   mainAxisAlignment:
          //                                       MainAxisAlignment.spaceBetween,
          //                                   children: [
          //                                     Text("Verification",
          //                                         style: CustomTextStyles
          //                                             .titleMediumOnPrimaryContainer18),
          //                                     AppbarImage1(
          //                                       onTap: () {
          //                                         Get.back();
          //                                       },
          //                                       svgPath: ImageConstant
          //                                           .imgEpcircleclose,
          //                                     ),
          //                                   ],
          //                                 )),
          //                             SizedBox(height: 33.v),
          //                             CustomImageView(
          //                                 svgPath: ImageConstant.imgTrash,
          //                                 height: 69.adaptSize,
          //                                 width: 69.adaptSize),
          //                             SizedBox(height: 25.v),
          //                             Text(
          //                                 "$randomNumber1 + $randomNumber2 = ?",
          //                                 style: theme.textTheme.titleLarge),
          //                             SizedBox(height: 9.v),
          //                             Padding(
          //                               padding: const EdgeInsets.symmetric(
          //                                   horizontal: 20.0),
          //                               child: TextField(
          //                                 controller: sumController,
          //                                 keyboardType: TextInputType.number,
          //                                 decoration: InputDecoration(
          //                                   hintText:
          //                                       'Enter sum of above number',
          //                                   border: OutlineInputBorder(
          //                                     borderRadius:
          //                                         BorderRadius.circular(
          //                                             8.0), // Circular border
          //                                     borderSide: const BorderSide(
          //                                       color:
          //                                           Colors.blue, // Border color
          //                                       width: 2.0, // Border width
          //                                     ),
          //                                   ),
          //                                   enabledBorder: OutlineInputBorder(
          //                                     borderRadius:
          //                                         BorderRadius.circular(8.0),
          //                                     borderSide: const BorderSide(
          //                                       color: Colors.blue,
          //                                       width: 2.0,
          //                                     ),
          //                                   ),
          //                                   focusedBorder: OutlineInputBorder(
          //                                     borderRadius:
          //                                         BorderRadius.circular(8.0),
          //                                     borderSide: const BorderSide(
          //                                       color: Colors.blue,
          //                                       width: 2.0,
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ),
          //                             ),
          //                             SizedBox(height: 25.v),
          //                             CustomOutlinedButton(
          //                                 width: 220.h,
          //                                 text: "Submit".toUpperCase(),
          //                                 buttonStyle:
          //                                     CustomButtonStyles.outlinePrimary,
          //                                 onTap: () {
          //                                   if (sumController.text.isEmpty) {
          //                                     Get.back();
          //                                     CustomSnackBar.showErrorSnackBar(
          //                                         'Verification failed');
          //                                   }
          //                                   if (randomNumber1 + randomNumber2 ==
          //                                       int.parse(sumController.text)) {
          //                                     Get.back();
          //                                     context
          //                                         .read<MembersListVM>()
          //                                         .initiateSyncMembership(
          //                                             context);
          //                                   } else {
          //                                     Get.back();
          //                                     CustomSnackBar.showErrorSnackBar(
          //                                         'Verification failed');
          //                                   }
          //                                 }),
          //                             SizedBox(height: 5.v)
          //                           ]),
          //                         )),
          //                   );
          //                 },
          //                 icon: Icon(
          //                   Icons.sync,
          //                   color: Constants.themeGradients[1],
          //                 )),
          //       )
        ],
      ),
      floatingActionButton: Consumer<MembersListVM>(
          builder: (_, vm, __) => vm.loadingPage
              ? const SizedBox.shrink()
              :
              // (!widget.syncStatus && vm.showAddOption)
              vm.membershipRequestList.isEmpty
                  ? Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          URoundButton(
                            title: "Create Member",
                            onTap: () async {
                              /// create new membership
                              final aggrId = await LocalStorageServices()
                                  .getAgrIDMembership();
                              final stateCode =
                                  await LocalStorageServices().getSTCode();
                              print("aggrid is : $aggrId");
                              final data =
                                  await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder:
                                              (context1) =>
                                                  ChangeNotifierProvider(
                                                    create: (context) =>
                                                        MembershipVM(),
                                                    child: MemberShip(
                                                      member: BatchMember(
                                                          memberId: (context.read<MembersListVM>().membershipRequestList.length +
                                                                          1)
                                                                      .toString()
                                                                      .length <
                                                                  2
                                                              ? widget.batchId +
                                                                  "0" +
                                                                  (context.read<MembersListVM>().membershipRequestList.length +
                                                                          1)
                                                                      .toString()
                                                                      .padLeft(
                                                                          1,
                                                                          "0")
                                                              : widget.batchId +
                                                                  "0" +
                                                                  (context.read<MembersListVM>().membershipRequestList.length +
                                                                          1)
                                                                      .toString(),
                                                          batchId:
                                                              widget.batchId,
                                                          isSync: "0",
                                                          aggrId: aggrId,
                                                          stateCode: stateCode),
                                                    ),
                                                  )));
                              context.read<MembersListVM>().getMembershipList(
                                  context, widget.batchId,
                                  reload: true);
                              if (data
                                  .toString()
                                  .toLowerCase()
                                  .contains('completed')) {
                                context.read<MembersListVM>().setautoSync();
                                await Future.delayed(Duration(seconds: 2));
                                context.read<MembersListVM>().getMembershipList(
                                      context,
                                      widget.batchId,
                                    );
                                context
                                    .read<MembersListVM>()
                                    .initiateSyncMembership(context);
                              } else {
                                context
                                    .read<MembersListVM>()
                                    .getMembershipList(context, widget.batchId);
                                context
                                    .read<MembersListVM>()
                                    .manualSync(context);
                              }
                            },
                            color: Constants.themeGradients[0],
                            labelColor: Constants.themeGradients[1],
                            svgIcon: "assets/icons/plus_icon.svg",
                            width: MediaQuery.of(context).size.width * 0.44,
                            height: MediaQuery.of(context).size.height * 0.07,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink()),
      body: Consumer<MembersListVM>(
        builder: (_, val, __) => val.loadingPage
            ? const NetworkLoading()
            : Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(5),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text('Member ID',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Expanded(
                          child: Text('Sync',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ),
                  val.membershipRequestList.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: val.membershipRequestList.length,
                              itemBuilder: (context, index) => MembersListCard(
                                  member: val.membershipRequestList[index])),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          alignment: Alignment.center,
                          child: const Center(
                            child:
                                Text("No Members found for the given Batch Id"),
                          ),
                        )
                ],
              ),
      ),
    );
  }
}

class VerificationDialog extends StatelessWidget {
  VerificationDialog({this.rand1, this.rand2, required this.model});
  int? rand1;
  int? rand2;
  MembersListVM model;
  TextEditingController sumController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Verification'),
      content: Container(
        height: 90,
        child: Column(
          children: [
            Text('$rand1 + $rand2 = ?'),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: sumController,
              decoration: const InputDecoration(
                hintText: 'Enter sum of above number',
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
            CustomSnackBar.showErrorSnackBar('Verification failed');
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            int sum = int.parse(sumController.text);
            if ((rand1! + rand2!) == sum) {
              Navigator.of(context).pop();
              // CustomSnackBar.showSuccessSnackBar('Verification Successful');
              context.read<MembersListVM>().initiateSyncMembership(context);
            } else {
              Navigator.of(context).pop();
              CustomSnackBar.showErrorSnackBar('Verification failed');
            }
          },
        ),
      ],
    );
  }
}
