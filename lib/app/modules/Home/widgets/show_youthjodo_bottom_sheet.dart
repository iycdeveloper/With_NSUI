import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/image_constant.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/modules/Home/home_controller.dart';
import 'package:iyc/app/modules/Home/widgets/gridleaderboard1_item_widget_new.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';

void showYouthJodoBottomSheet() {
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
              // Container(
              //   width: double.maxFinite,
              //   margin: EdgeInsets.all(20.adaptSize),
              //   child: Row(
              //     children: [
              //       Column(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             'Youth Jodo',
              //             style: theme.textTheme.titleLarge!
              //                 .copyWith(fontWeight: FontWeight.bold),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
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
                    Text('Youth Jodo',
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
                ((mediaQueryData.size.height - kToolbarHeight - 24) / 3.2)),
                      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          // mainAxisExtent: 133.v,
                          crossAxisCount: 3,
                          mainAxisSpacing: 15.h,
                          crossAxisSpacing: 15.h,
                          // ),
                      physics: const NeverScrollableScrollPhysics(),
                      // itemCount: 3,
                      children: List.generate(3, (index) {
                        return [
                          GridLeaderBoardItemWidgetNew(
                            "Chalo\nPanchayat",
                            'assets/images/newuisvg/pepicons-circle.svg',
                            onTap: () {
                              Get.back();
                              RoutesManagement.goToYouthJodo("CP");
                            },
                            boxcolor: Color(0xFFEBF7FF),
                            textboxcolor: Color(0xFFCEEBFF),
                          ),
                          GridLeaderBoardItemWidgetNew(
                            "Protest/Rally",
                            ImageConstant.imgViewBooth,
                            onTap: () {
                              Get.back();
                              RoutesManagement.goToYouthJodo("PT");
                            },
                            boxcolor: Color(0xFFEEFFF2),
                            textboxcolor: Color(0xFFCDFFD8),
                          ),
                          GridLeaderBoardItemWidgetNew(
                            "Community Initiatives",
                            ImageConstant.imgEarth,
                            // isSvg: true,
                            onTap: () {
                              Get.back();
                              RoutesManagement.goToYouthJodo("CI");
                            },
                            boxcolor: Color(0xFFF2F0FF),
                            textboxcolor: Color(0xFFE8E4FF),
                          ),
                          // GridLeaderBoardItemWidgetNew(
                          //   "Booth Jodo",
                          //   ImageConstant.imgBoothJodo,
                          //   // isSvg: true,
                          //   onTap: () {
                          //     Get.back();
                          //     if (logic.yuvaUser == null) {
                          //       CustomSnackBar.showErrorSnackBar(
                          //           'User data not found or is not Active');
                          //     } else {
                          //       // RoutesManagement.goToBoothJodoScreen();
                          //     }
                          //   },
                          //    boxcolor: Color(0xFFEBF7FF),
                          //   textboxcolor: Color(0xFFCEEBFF),
                          // ),
                        ][index];
                      })))
            ],
          ));
    }),
  ), ignoreSafeArea: false);
}
