import 'package:flutter_svg/svg.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/custom_icon_button.dart';
import 'package:iyc/app/widgets/custom_outlined_button.dart';

import '../../../core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingFourScreen extends StatelessWidget {
  const OnboardingFourScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            backgroundColor: appTheme.indigo700,
            body: SizedBox(
                height: mediaQueryData.size.height,
                width: double.maxFinite,
                child: Stack(alignment: Alignment.bottomLeft, children: [
                  Align(
                      alignment: Alignment.center,
                      child: Container(
                          padding: EdgeInsets.all(20.h),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(ImageConstant.imgGroup5),
                                  fit: BoxFit.cover)),
                          child: CustomOutlinedButton(
                              height: 26.v,
                              width: 62.h,
                              text: "lbl_skip".tr,
                              buttonStyle: CustomButtonStyles.outlineBlue,
                              buttonTextStyle:
                              CustomTextStyles.bodyMediumIndigo500,
                              onTap: () {
                                onTapSkip();
                              }))),
                  CustomImageView(
                      imagePath: ImageConstant.imgOPrimary,
                      height: 414.v,
                      width: 297.h,
                      alignment: Alignment.bottomLeft),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 20.h, right: 20.h, bottom: 30.v),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.h, vertical: 12.v),
                          decoration: const BoxDecoration(
                              color: Colors.transparent
                          ),
                          child: Stack(
                            children: [
                              CustomImageView(svgPath: ImageConstant.imgGroup3076,fit: BoxFit.cover),
                              Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(height: 8.v),
                                    Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                            height: 6.v,
                                            child: AnimatedSmoothIndicator(
                                                activeIndex: 0,
                                                count: 4,
                                                effect: ScrollingDotsEffect(
                                                    spacing: 12,
                                                    activeDotColor:
                                                    appTheme.blue80001,
                                                    dotColor: appTheme.blue10001,
                                                    dotHeight: 6.v,
                                                    dotWidth: 24.h)))),
                                    Container(
                                        width: 255.h,
                                        margin:
                                        EdgeInsets.only(top: 16.v, right: 39.h),
                                        child: Text("msg_create_and_lead".tr,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.titleLarge!
                                                .copyWith(height: 1.40))),
                                    Container(
                                        width: 284.h,
                                        margin:
                                        EdgeInsets.only(top: 6.v, right: 10.h),
                                        child: Text("msg_choose_your_promises".tr,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.bodyLarge!
                                                .copyWith(height: 1.60))),
                                    SizedBox(height: 3.v),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                            height: 76.adaptSize,
                                            width: 76.adaptSize,
                                            padding: EdgeInsets.all(8.h),
                                            decoration: AppDecoration.outline
                                                .copyWith(
                                                borderRadius: BorderRadiusStyle
                                                    .roundedBorder20),
                                            child: CustomIconButton(
                                                height: 60.adaptSize,
                                                width: 60.adaptSize,
                                                padding: EdgeInsets.all(20.h),
                                                decoration: IconButtonStyleHelper
                                                    .outlineCyan,
                                                alignment: Alignment.center,
                                                onTap: () {
                                                  onTapBtnIconButton();
                                                },
                                                child: CustomImageView(
                                                    svgPath:
                                                    ImageConstant.imgGroup17))))
                                  ]),
                            ],
                          )))
                ]))));
  }

  /// Navigates to the registerOneScreen when the action is triggered.

  /// When the action is triggered, this function uses the [Get] package to
  /// push the named route for the registerOneScreen.
  onTapSkip() {
    // Get.toNamed(
    //   AppRoutes.registerOneScreen,
    // );
  }

  /// Navigates to the loginOneScreen when the action is triggered.

  /// When the action is triggered, this function uses the [Get] package to
  /// push the named route for the loginOneScreen.
  onTapBtnIconButton() {
    RoutesManagement.goToBoardingScreen();
  }
}
