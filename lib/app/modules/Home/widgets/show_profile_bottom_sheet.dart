import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/modules/Home/widgets/gridleaderboard1_item_widget_new.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';

showProfileBottomSheet() {
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.h, vertical: 17.v),
                    // decoration: AppDecoration.heading,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Profile',
                            style: CustomTextStyles
                                .titleMediumOnPrimaryContainer18),
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
                      children: List.generate(6, (index) {
                        return [
                          GridLeaderBoardItemWidgetNew(
                            "My Activities",
                            ImageConstant.imgPosition1,
                            // isSvg: true,
                            onTap: () {
                              Get.back();
                              RoutesManagement.goToMyActivityScreen();
                            },
                            boxcolor: Color(0xFFEBF7FF),
                            textboxcolor: Color(0xFFCEEBFF),
                          ),
                          GridLeaderBoardItemWidgetNew(
                            "My Points",
                            'assets/images/newsvg/mypoints.svg',
                            onTap: () {
                              RoutesManagement.goToStatementScreen();
                            },
                            boxcolor: Color(0xFFEEFFF2),
                            textboxcolor: Color(0xFFCDFFD8),
                          ),
                          GridLeaderBoardItemWidgetNew(
                            "My Calendar",
                            'assets/images/newsvg/mycalendar.svg',
                            onTap: () {
                              Get.back();

                              RoutesManagement.goToProgramScreen();
                            },
                            boxcolor: Color(0xFFF2F0FF),
                            textboxcolor: Color(0xFFE8E4FF),
                          ),
                          GridLeaderBoardItemWidgetNew(
                            "My Team",
                            ImageConstant.imgCoordinator,
                            // isSvg: true,
                            onTap: () {
                              Get.back();

                              RoutesManagement.goToMyTeamScreen();
                            },
                            boxcolor: const Color(0xFFEBF7FF),
                            textboxcolor: const Color(0xFFCEEBFF),
                          ),
                          GridLeaderBoardItemWidgetNew(
                            "My Profile",
                            'assets/images/newsvg/myprofile.svg',
                            // isSvg: true,
                            onTap: () {
                              Get.back();

                              RoutesManagement.goToProfileScreen(tabIndex: 0);
                            },
                            boxcolor: const Color(0xFFFFF0E5),
                            textboxcolor: const Color(0xFFFFE0C9),
                          ),
                          GridLeaderBoardItemWidgetNew(
                            "My Rewards",
                            'assets/images/newsvg/myreward.svg',
                            // isSvg: true,
                            onTap: () {
                              Get.back();
                              RoutesManagement.goToRewardsScreen();
                            },
                            boxcolor: Color(0xFFEBF7FF),
                            textboxcolor: Color(0xFFCEEBFF),
                          ),
                        ][index];
                      })),
                )
              ],
            )),
      ),
      ignoreSafeArea: false);
}
