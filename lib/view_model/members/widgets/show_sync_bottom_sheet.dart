import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/image_constant.dart';
import 'package:iyc/app/modules/Home/home_controller.dart';
import 'package:iyc/app/modules/Home/widgets/gridleaderboard1_item_widget_new.dart';
import 'package:iyc/app/modules/Home/widgets/show_shakti_bottom_sheet.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';

 showSyncBottomSheet(BuildContext context) {
  mediaQueryData = MediaQuery.of(context);
  final height = MediaQuery.of(context).size.height;
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
                padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 17.v),
                // decoration: AppDecoration.heading,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Alert',
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
                      // itemCount: 3,
                      children: List.generate(1, (index) {
                        return [
                          GridLeaderBoardItemWidgetNew(
                            "Shakti Club",
                            ImageConstant.imgIndividual,
                            onTap: () {
                              Get.back();
                             showShaktiBottomSheet();
                            },
                            boxcolor: Color(0xFFEBF7FF),
                            textboxcolor: Color(0xFFCEEBFF),
                          ),
                          // GridLeaderBoardItemWidgetNew(
                          //   "Youth Club",
                          //   "assets/images/img_boothjodo.svg",
                          //   onTap: () {
                          //     Get.back();
                          //     showYouthClubBottomSheet();
                          //   },
                          //   boxcolor: Color(0xFFEEFFF2),
                          //   textboxcolor: Color(0xFFCDFFD8),
                          // ),
                          
                        ][index];
                      })))
            ],
          ));
    }),
  ), ignoreSafeArea: false);
}
