// import 'package:flutter/material.dart';
// import 'package:iyc/app/modules/Home/home_controller.dart';
// import 'package:iyc/app/modules/menu/widget/grid_menu_item.dart';
// import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';
// import 'package:iyc/app/widgets/bottom_sheet/show_ro_access_bottom_sheet.dart';
// import 'package:iyc/provider/batch/batch_api_provider.dart';
// import 'package:iyc/utils/utils.dart';
// import 'package:provider/provider.dart';
// import '../../core/app_export.dart';
// import 'package:iyc/app/routes/routes_management.dart';
// import 'package:iyc/di_container.dart';
// import 'package:iyc/helper/api_config.dart';
// import 'package:iyc/provider/batch/batch_list_provider.dart';
// import 'package:iyc/provider/membership_register/membership_api_providers/membership_list_provider.dart';
// import 'package:iyc/provider/scrutiny/scrutiny_batch_vm.dart';
// import 'package:iyc/screens/ui/membership_ui/batch/batch_main.dart';
// import 'package:iyc/screens/ui/nominations/nominations_main.dart';
// import 'package:iyc/screens/ui/reports/reports_main.dart';
// import 'package:iyc/screens/ui/scrutiny/batch/scrutiny_batch_list.dart';
// import 'package:iyc/view_model/nomination/view_nomination_vm.dart';
// import 'package:iyc/view_model/report/reports_vm.dart';
// import '../../../provider/nomination/nominations_provider.dart';
// import 'package:iyc/di_container.dart' as di;

// void showElectionBottomSheet() {
//   mediaQueryData = MediaQuery.of(Get.context!);
//   Get.bottomSheet(
//       SafeArea(
//         child: Container(
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(24),
//                     topRight: Radius.circular(24))),
//             width: double.maxFinite,
//             height: 400.v,
//             child: Column(
//               children: [
//                 Container(
//                   width: double.maxFinite,
//                   margin: EdgeInsets.all(20.adaptSize),
//                   child: Row(
//                     children: [
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Membership',
//                             style: TextStyle(
//                                 color: Color(0xff244974),
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500),
//                           ),
//                           SizedBox(
//                             height: 10.v,
//                           ),
//                           Text(
//                             'Manage your membership here.',
//                             style: TextStyle(
//                                 color: Color(0xff869DB6),
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w400),
//                           )
//                         ],
//                       ),
//                       AppbarImage1(
//                         onTap: () {
//                           Get.back();
//                         },
//                         svgPath: ImageConstant.imgEpcircleclose,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Divider(),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Padding(
//                     padding: EdgeInsets.only(left: 20.h, right: 20.h),
//                     child: GridView.builder(
//                         shrinkWrap: true,
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                             // mainAxisExtent: 133.v,
//                             crossAxisCount: 3,
//                             mainAxisSpacing: 15.h,
//                             crossAxisSpacing: 15.h),
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: 6,
//                         itemBuilder: (context, index) {
//                           return [
//                             GridMenuItemWidget(
//                               "Nomination",
//                               ImageConstant.imgNomination,
//                               isSvg: true,
//                               onTap: () {
//                                 toPage(
//                                   context,
//                                   MultiProvider(providers: [
//                                     ChangeNotifierProvider(
//                                       create: (context) => NominationsProvider(
//                                           apiConfig: sl<ApiConfig>()),
//                                     ),
//                                     ChangeNotifierProvider(
//                                         create: (context) => ViewNominationVm())
//                                   ], child: NominationsMain()),
//                                 );
//                               },
//                             ),
//                             GridMenuItemWidget(
//                               "Membership",
//                               ImageConstant.imgLegalCall,
//                               isSvg: true,
//                               onTap: () {
//                                 HomeController homeController =
//                                     Get.find<HomeController>();
//                                 if (["LA", "TS", "ML", "MN"].contains(homeController
//                                     .profileController.userDetail!.stateCode)) {
//                                   RoutesManagement.goToMembershipBatchScreen();
//                                 } else {
//                                   toPage(
//                                     context,
//                                     MultiProvider(providers: [
//                                       ChangeNotifierProvider(
//                                         create: (context) =>
//                                             sl<MembershipListProvider>(),
//                                       ),
//                                       ChangeNotifierProvider(
//                                         create: (context) =>
//                                             BatchListProvider(apiConfig: sl()),
//                                       ),
//                                     ], child: BatchMain()),
//                                   );
//                                 }
//                               },
//                             ),
//                             GridMenuItemWidget(
//                               "Membership\nReport",
//                               ImageConstant.imgMembershipReport,
//                               isSvg: false,
//                               onTap: () {
//                                 toPage(
//                                     context,
//                                     ChangeNotifierProvider(
//                                       create: (context) => ReportsVM(),
//                                       child: ReportsMain(),
//                                     ));
//                               },
//                             ),
//                             GridMenuItemWidget(
//                               "Scrutiny",
//                               ImageConstant.imgScrunity,
//                               isSvg: true,
//                               onTap: () {
//                                 toPage(
//                                     context,
//                                     MultiProvider(providers: [
//                                       Provider(
//                                         create: (context) =>
//                                             di.sl<BatchApiProvider>(),
//                                       ),
//                                       ChangeNotifierProvider(
//                                         create: (context) => ScrutinyBatchVM(
//                                             scrutinyRepo: sl(),
//                                             apiConfig: sl()),
//                                       )
//                                     ], child: ScrutinyBatchList()));
//                               },
//                             ),
//                             GridMenuItemWidget(
//                                 "Complaints", ImageConstant.imgComplaints,
//                                 isSvg: true,
//                                 onTap: RoutesManagement.goToComplaintsScreen
//                                 //     () {
//                                 //   toPage(
//                                 //       context,
//                                 //       MultiProvider(providers: [
//                                 //         ChangeNotifierProvider(
//                                 //           create: (context) =>
//                                 //               ComplaintsHomeVM(),
//                                 //         )
//                                 //       ], child: ComplaintsHome()));
//                                 // },
//                                 ),
//                             GridMenuItemWidget(
//                                 "RO Access", ImageConstant.imgROAccess,
//                                 isSvg: true, onTap: showRoAccessBottomSheet),
//                           ][index];
//                         })),
//               ],
//             )),
//       ),
//       ignoreSafeArea: false);
// }
