import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/app/modules/membership/controllers/membership_member_list_controller.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/model/data_model/batch_member.dart';

class MembershipMemberListScreen extends StatelessWidget {
  const MembershipMemberListScreen();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MembershipMemberListController>(builder: (logic) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFF8FAFF),
          appBar: CustomAppBar(
            leadingWidth: 44.h,
            leading: AppbarImage(
                onTap: () {
                  Get.back();
                },
                svgPath: ImageConstant.imgBiarrowleftIndigo800,
                margin: EdgeInsets.only(left: 20.h, top: 15.v, bottom: 15.v)),
            title: AppbarSubtitle1(
                text: "${logic.batchId}", margin: EdgeInsets.only(left: 12.h)),
            styleType: Style.standard,
            actions: const [
              // logic.isSyncMembers
              //     ? SizedBox.shrink()
              //     : IconButton(
              //         onPressed: () async {
              //           var aggrId =
              //               await LocalStorageServices().getAgrIDMembership();
              //           Log.printDLog(aggrId);
              //           TextEditingController sumController =
              //               TextEditingController();
              //           var random = Random();
              //           int randomNumber1 = random.nextInt(98) + 1;
              //           int randomNumber2 = random.nextInt(98) + 1;
              //           mediaQueryData = MediaQuery.of(Get.context!);
              //           Get.bottomSheet(
              //             Container(
              //                 decoration: BoxDecoration(
              //                     color: Colors.white,
              //                     borderRadius: BorderRadius.only(
              //                         topLeft: Radius.circular(24),
              //                         topRight: Radius.circular(24))),
              //                 width: double.maxFinite,
              //                 height: 372.v,
              //                 child: SingleChildScrollView(
              //                   child: Column(children: [
              //                     Container(
              //                         decoration: BoxDecoration(
              //                             // color: Colors.white,
              //                             color: appTheme.indigo800,
              //                             borderRadius: BorderRadius.only(
              //                                 topLeft: Radius.circular(24),
              //                                 topRight: Radius.circular(24))),
              //                         width: double.maxFinite,
              //                         padding: EdgeInsets.symmetric(
              //                             horizontal: 20.h, vertical: 17.v),
              //                         // decoration: AppDecoration.heading,
              //                         child: Row(
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.spaceBetween,
              //                           children: [
              //                             Text("Verification",
              //                                 style: CustomTextStyles
              //                                     .titleMediumOnPrimaryContainer18),
              //                             AppbarImage1(
              //                               onTap: () {
              //                                 Get.back();
              //                               },
              //                               svgPath:
              //                                   ImageConstant.imgEpcircleclose,
              //                             ),
              //                           ],
              //                         )),
              //                     SizedBox(height: 33.v),
              //                     CustomImageView(
              //                         svgPath: ImageConstant.imgTrash,
              //                         height: 69.adaptSize,
              //                         width: 69.adaptSize),
              //                     SizedBox(height: 25.v),
              //                     Text("$randomNumber1 + $randomNumber2 = ?",
              //                         style: theme.textTheme.titleLarge),
              //                     SizedBox(height: 9.v),
              //                     Padding(
              //                       padding: const EdgeInsets.symmetric(
              //                           horizontal: 20.0),
              //                       child: TextField(
              //                         controller: sumController,
              //                         keyboardType: TextInputType.number,
              //                         decoration: InputDecoration(
              //                           hintText: 'Enter sum of above number',
              //                           border: OutlineInputBorder(
              //                             borderRadius: BorderRadius.circular(
              //                                 8.0), // Circular border
              //                             borderSide: BorderSide(
              //                               color: Colors.blue, // Border color
              //                               width: 2.0, // Border width
              //                             ),
              //                           ),
              //                           enabledBorder: OutlineInputBorder(
              //                             borderRadius:
              //                                 BorderRadius.circular(8.0),
              //                             borderSide: BorderSide(
              //                               color: Colors.blue,
              //                               width: 2.0,
              //                             ),
              //                           ),
              //                           focusedBorder: OutlineInputBorder(
              //                             borderRadius:
              //                                 BorderRadius.circular(8.0),
              //                             borderSide: BorderSide(
              //                               color: Colors.blue,
              //                               width: 2.0,
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                     SizedBox(height: 25.v),
              //                     CustomOutlinedButton(
              //                         width: 220.h,
              //                         text: "Submit".toUpperCase(),
              //                         buttonStyle:
              //                             CustomButtonStyles.outlinePrimary,
              //                         onTap: () {
              //                           if (sumController.text.isEmpty) {
              //                             Get.back();
              //                             CustomSnackBar.showErrorSnackBar(
              //                                 'Verification failed');
              //                           }
              //                           if (randomNumber1 + randomNumber2 ==
              //                               int.parse(sumController.text)) {
              //                             Get.back();
              //                             logic.initiateSyncMembership(context);
              //                           } else {
              //                             Get.back();
              //                             CustomSnackBar.showErrorSnackBar(
              //                                 'Verification failed');
              //                           }
              //                         }),
              //                     SizedBox(height: 5.v)
              //                   ]),
              //                 )),
              //           );
              //         },
              //         icon: Icon(
              //           Icons.sync,
              //           color: Color(0xFF244974),
              //         )),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                  const Color(0xFF2CC7E2).withOpacity(0.1),
                  Colors.white
                ])),
            child: ListView(
              children: [
                const SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Member Data',
                        style: TextStyle(
                          color: Color(
                              0xFF244974), // This is the hex code for #244974
                          fontFamily: 'Be Vietnam Pro',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.4, // This is equivalent to 140% line height
                        ),
                      ),
                      if (logic.membershipRequestList.isEmpty) ...[
                        InkWell(
                          onTap: () async {
                            final aggrId = await LocalStorageServices()
                                .getAgrIDMembership();
                            final stateCode =
                                await LocalStorageServices().getSTCode();
                            if (logic.membershipRequestList.length >= 10) {
                              CustomSnackBar.showErrorSnackBar(
                                  'Only 10 members are allowed');
                              return;
                            }
                            RoutesManagement.goToMembershipMemberCreateScreen(
                                BatchMember(
                                    memberId:
                                        (logic.membershipRequestList.length + 1)
                                                    .toString()
                                                    .length <
                                                2
                                            ? logic.batchId +
                                                "0" +
                                                (logic.membershipRequestList
                                                            .length +
                                                        1)
                                                    .toString()
                                                    .padLeft(1, "0")
                                            : logic.batchId +
                                                "0" +
                                                (logic.membershipRequestList
                                                            .length +
                                                        1)
                                                    .toString(),
                                    batchId: logic.batchId,
                                    isSync: "0",
                                    aggrId: aggrId,
                                    stateCode: stateCode),
                                isUpdate: false);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                               boxShadow: const [
                                          BoxShadow(
                                              color: Colors.grey,
                                              spreadRadius: 0.5,
                                              blurRadius: 0.5)
                                        ],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color:
                                    const Color(0xFF2CC7E2), // Cyan-Blue color
                                width: 1.0,
                              ),
                              color: const Color(0xFF0297F3), // White background
                            ),
                            child: const Text(
                              'ADD MEMBER',
                              style: TextStyle(
                                color: Colors.white, // Cyan-Blue color
                                fontFamily: 'Be Vietnam Pro',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.4, // 140% line height
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                if (logic.membershipRequestList.isEmpty) ...[
                  const SizedBox(
                    height: 50,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No record found, for the given batch no',
                        style: TextStyle(
                          color: Color(
                              0xFF244974), // This is the hex code for #244974
                          fontFamily: 'Be Vietnam Pro',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.4, // This is equivalent to 140% line height
                        ),
                      ),
                    ],
                  ),
                ],
                if (logic.membershipRequestList.isNotEmpty) ...[
                  Container(
                    height: 54.v,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFC0D5F3), // Stroke color
                        width: 1.0,
                      ),
                      color: Colors.white, // White background
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF365B85),
                            size: 20,
                          ),
                          label: Text(
                            'Search Batch-Id',
                            style: TextStyle(
                              color: Color(0xFF365B85), // Body color
                              fontFamily: 'Be Vietnam Pro',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.0, // 100% line height
                            ),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    height: 64,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      color: Color(0xFF244974),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Member Id',
                          style: titleStyle,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: Text(
                            'Sync',
                            style: titleStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFC0D5F3), // Stroke color
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      children: List.generate(
                        logic.membershipRequestList.length,
                        (index) {
                          return InkWell(
                            onTap: () {
                              RoutesManagement.goToMembershipMemberViewScreen(
                                  logic.membershipRequestList[index],
                                  isUpdate: (logic.membershipRequestList[index]
                                          .isSync ==
                                      "1"),
                                  isUpdateToDB: true);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 12),
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Color(0xFFC0D5F3), // Stroke color
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${logic.membershipRequestList[index].memberId}',
                                    style: const TextStyle(
                                      color: Color(0xFF365B85), // Body color
                                      fontFamily: 'Be Vietnam Pro',
                                      fontSize: 14,
                                      fontWeight:
                                          FontWeight.w400, // Normal font weight
                                      height: 1.6, // 160% line height
                                    ),
                                  ),
                                  Text(
                                    logic.membershipRequestList[index].isSync ==
                                            "1"
                                        ? "Completed"
                                        : "Pending",
                                    style: const TextStyle(
                                      color: Color(0xFF365B85), // Body color
                                      fontFamily: 'Be Vietnam Pro',
                                      fontSize: 14,
                                      fontWeight:
                                          FontWeight.w400, // Normal font weight
                                      height: 1.6, // 160% line height
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      );
    });
  }
}

TextStyle titleStyle = const TextStyle(
  color: Colors.white, // White color
  fontFamily: 'Be Vietnam Pro',
  fontSize: 16,
  fontWeight: FontWeight.w400, // Normal font weight
  height: 1.6, // 160% line height
);
