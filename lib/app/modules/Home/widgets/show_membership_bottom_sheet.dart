import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/image_constant.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/modules/Home/home_controller.dart';
import 'package:iyc/app/modules/Home/widgets/gridleaderboard1_item_widget_new.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';
import 'package:iyc/app/widgets/bottom_sheet/show_ro_access_bottom_sheet.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/helper/api_config.dart';
import 'package:iyc/provider/batch/batch_list_provider.dart';
import 'package:iyc/provider/membership_register/membership_api_providers/membership_list_provider.dart';
import 'package:iyc/provider/scrutiny/scrutiny_batch_vm.dart';
import 'package:iyc/screens/ui/complaints/complaints_home.dart';
import 'package:iyc/screens/ui/membership_ui/batch/batch_main.dart';
import 'package:iyc/screens/ui/nominations/nominations_main.dart';
import 'package:iyc/screens/ui/reports/reports_main.dart';
import 'package:iyc/screens/ui/scrutiny/batch/scrutiny_batch_list.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/complaints/complaints_home_vm.dart';
import 'package:iyc/view_model/nomination/view_nomination_vm.dart';
import 'package:iyc/view_model/report/reports_vm.dart';
import 'package:provider/provider.dart';

import '../../../../provider/nomination/nominations_provider.dart';

showMembershipBottomSheet(BuildContext context) {
  mediaQueryData = MediaQuery.of(Get.context!);
  final height = MediaQuery.of(Get.context!).size.height;
  Get.bottomSheet(SafeArea(
    child: GetBuilder<HomeController>(builder: (logic) {
      return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24))),
          width: double.maxFinite,
          height: height * 0.5,
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: appTheme.indigo800,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24))),
                  width: double.maxFinite,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.h, vertical: 17.v),
                  // decoration: AppDecoration.heading,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Membership',
                          style:
                              CustomTextStyles.titleMediumOnPrimaryContainer18),
                      AppbarImage1(
                        onTap: Get.back,
                        svgPath: ImageConstant.imgEpcircleclose,
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 20.h, right: 20.h),
                  child: GridView.count(
                      shrinkWrap: true,
                      childAspectRatio: ((mediaQueryData.size.width / 2) /
                          ((mediaQueryData.size.height - kToolbarHeight - 24) /
                              3.2)),
                      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 15.h,
                      crossAxisSpacing: 15.h,
                      // ),
                      physics: const NeverScrollableScrollPhysics(),
                      // itemCount: 1,
                      children: List.generate(6, (index) {
                        return [
                          GridLeaderBoardItemWidgetNew(
                            "Membership",
                            'assets/images/newuisvg/membership.svg',
                            onTap: () {
                              HomeController homeController =
                                  Get.find<HomeController>();
                              if ([
                                "LA",
                                "LK",
                                "ML",
                                "MN",
                              ].contains(homeController
                                  .profileController.userDetail!.stateCode)) {
                                RoutesManagement.goToMembershipBatchScreen();
                              } else {
                                toPage(
                                  context,
                                  MultiProvider(providers: [
                                    ChangeNotifierProvider(
                                      create: (context) =>
                                          sl<MembershipListProvider>(),
                                    ),
                                    ChangeNotifierProvider(
                                      create: (context) =>
                                          BatchListProvider(apiConfig: sl()),
                                    ),
                                  ], child: const BatchMain()),
                                );
                              }
                            },
                            boxcolor: Color(0xFFEBF7FF),
                            textboxcolor: Color(0xFFCEEBFF),
                          ),
                          GridLeaderBoardItemWidgetNew(
                            "Nomination",
                            ImageConstant.imgNomination,
                            onTap: () {
                              toPage(
                                context,
                                MultiProvider(providers: [
                                  ChangeNotifierProvider(
                                    create: (context) => NominationsProvider(
                                        apiConfig: sl<ApiConfig>()),
                                  ),
                                  ChangeNotifierProvider(
                                      create: (context) => ViewNominationVm())
                                ], child: const NominationsMain()),
                              );
                            },
                            boxcolor: Color(0xFFEEFFF2),
                            textboxcolor: Color(0xFFCDFFD8),
                          ),
                          GridLeaderBoardItemWidgetNew(
                            "Report",
                            "assets/images/newuisvg/report.svg",
                            onTap: () {
                              toPage(
                                  context,
                                  ChangeNotifierProvider(
                                    create: (context) => ReportsVM(),
                                    child: const ReportsMain(),
                                  ));
                            },
                            boxcolor: Color(0xFFF2F0FF),
                            textboxcolor: Color(0xFFE8E4FF),
                          ),
                          GridLeaderBoardItemWidgetNew(
                            "Scrutiny",
                            ImageConstant.imgScrunity,
                            onTap: () {
                              toPage(
                                  context,
                                  MultiProvider(providers: [
                                    ChangeNotifierProvider(
                                      create: (context) => ScrutinyBatchVM(
                                          scrutinyRepo: sl(), apiConfig: sl()),
                                    )
                                  ], child: const ScrutinyBatchList()));
                            },
                            boxcolor: const Color(0xFFEBF7FF),
                            textboxcolor: const Color(0xFFCEEBFF),
                          ),
                          GridLeaderBoardItemWidgetNew(
                            "Complaints",
                            ImageConstant.imgComplaints,
                            onTap: () {
                              toPage(
                                  context,
                                  MultiProvider(providers: [
                                    ChangeNotifierProvider(
                                      create: (context) => ComplaintsHomeVM(),
                                    )
                                  ], child: const ComplaintsHome()));
                              // openCampaignBottomSheet();
                              // toPage(
                              //     context,
                              //     ChangeNotifierProvider(
                              //       create: (context) =>
                              //           SelectCampaignVM(),
                              //       child: SelectCampaign(),
                              //     ));
                            },
                            boxcolor: const Color(0xFFFFF0E5),
                            textboxcolor: const Color(0xFFFFE0C9),
                          ),
                          GridLeaderBoardItemWidgetNew(
                            "RO Access",
                            ImageConstant.imgROAccess,
                            onTap: showRoAccessBottomSheet,
                            boxcolor: Color(0xFFEBF7FF),
                            textboxcolor: Color(0xFFCEEBFF),
                          ),
                        ][index];
                      })))
            ],
          ));
    }),
  ), ignoreSafeArea: false);
}
