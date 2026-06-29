import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/image_constant.dart';
import 'package:iyc/app/modules/Home/widgets/gridleaderboard1_item_widget_new.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';

void showShaktiBottomSheet() {
  mediaQueryData = MediaQuery.of(Get.context!);
  final height = MediaQuery.of(Get.context!).size.height;
  Get.bottomSheet(
      SafeArea(
        child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24))),
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
                padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 17.v),
                // decoration: AppDecoration.heading,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shakti Club',
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
                            // mainAxisExtent: 133.v,
                            crossAxisCount: 3,
                            mainAxisSpacing: 15.h,
                            crossAxisSpacing: 15.h,
                            // ),
                        physics: const NeverScrollableScrollPhysics(),
                        // itemCount: 6,
                        children: List.generate(6, (index)  {
                          return [
                            GridLeaderBoardItemWidgetNew(
                              "Leaderboard",
                              ImageConstant.imgPosition1,
                              onTap: () {
                                RoutesManagement.goToLeaderBoardScreen();
                              },
                              boxcolor: Color(0xFFEBF7FF),
                              textboxcolor: Color(0xFFCEEBFF),
                            ),
                            GridLeaderBoardItemWidgetNew(
                              "Create a Club",
                              'assets/images/newuisvg/lets-icons_group-light.svg',
                              onTap: () {
                                RoutesManagement.goToCreateClubScreen();
                              },
                              boxcolor: Color(0xFFEEFFF2),
                              textboxcolor: Color(0xFFCDFFD8),
                            ),
                            GridLeaderBoardItemWidgetNew(
                              "View Club",
                              'assets/images/newuisvg/streamline.svg',
                              // isSvg: true,
                              onTap: () {
                                RoutesManagement.goToViewClubScreen();
                              },
                              boxcolor: Color(0xFFF2F0FF),
                              textboxcolor: Color(0xFFE8E4FF),
                            ),
                            GridLeaderBoardItemWidgetNew(
                              "Co-ordinator",
                              'assets/images/newuisvg/hugeicons_manager.svg',
                              // isSvg: true,
                              onTap: () {
                                RoutesManagement.goToCoordinatorScreen();
                              },
                              boxcolor: const Color(0xFFEBF7FF),
                              textboxcolor: const Color(0xFFCEEBFF),
                            ),
                            GridLeaderBoardItemWidgetNew(
                              "Add Member",
                              'assets/images/newuisvg/lets-add-light.svg',
                              onTap: () {
                                RoutesManagement
                                    .goToAddIndividualMemberScreen();
                              },
                              boxcolor: const Color(0xFFFFF0E5),
                              textboxcolor: const Color(0xFFFFE0C9),
                            ),
                            GridLeaderBoardItemWidgetNew(
                              "Shakti\nProgram",
                              'assets/images/newuisvg/grommet-verified.svg',
                              onTap: () {
                                RoutesManagement.goToNewShaktiProgramHistory();
                              },
                              boxcolor: Color(0xFFEBF7FF),
                              textboxcolor: Color(0xFFCEEBFF),
                            ),
                          ][index];
                        }))),
              ],
            )),
      ),
      ignoreSafeArea: false);
}
