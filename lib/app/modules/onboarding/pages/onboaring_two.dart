import 'package:iyc/app/widgets/custom_outlined_button.dart';

import '../../../core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore_for_file: must_be_immutable
class OnboardingTwoScreen extends StatelessWidget {
  const OnboardingTwoScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.indigo700,
        body: SizedBox(
          height: mediaQueryData.size.height,
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: mediaQueryData.size.height,
                  width: double.maxFinite,
                  padding: EdgeInsets.all(20.h),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        ImageConstant.imgGroup15,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),

                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: CustomOutlinedButton(
                  margin: EdgeInsets.all(20),
                  height: 26.v,
                  width: 62.h,
                  text: "lbl_skip".tr,
                  buttonStyle: CustomButtonStyles.outlineBlue,
                  buttonTextStyle: CustomTextStyles.bodyMediumIndigo500,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 300.v,
                  margin: EdgeInsets.only(
                    left: 20.h,
                    right: 20.h,
                    bottom: 30.v,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.h,
                    // vertical: 12.v,
                  ),
                  decoration: const BoxDecoration(
                      color: Colors.transparent
                  ),
                  child: Stack(
                    children: [
                      CustomImageView(svgPath: ImageConstant.imgGroup3076,fit: BoxFit.cover),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.v),
                          SizedBox(
                            height: 6.v,
                            child: AnimatedSmoothIndicator(
                              activeIndex: 1,
                              count: 4,
                              effect: ScrollingDotsEffect(
                                spacing: 12,
                                activeDotColor: appTheme.blue80001,
                                dotColor: appTheme.blue10001,
                                dotHeight: 6.v,
                                dotWidth: 24.h,
                              ),
                            ),
                          ),
                          Container(
                            width: 289.h,
                            margin: EdgeInsets.only(
                              top: 16.v,
                              right: 5.h,
                            ),
                            child: Text(
                              "msg_climb_the_leaderboard".tr,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleLarge!.copyWith(
                                height: 1.40,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 281.h,
                              margin: EdgeInsets.only(
                                top: 6.v,
                                right: 13.h,
                              ),
                              child: Text(
                                "msg_earn_rewards_by".tr,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyLarge!.copyWith(
                                  height: 1.60,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 3.v),
                          Container(
                            height: 76.adaptSize,
                            width: 76.adaptSize,
                            padding: EdgeInsets.all(8.h),
                            decoration: AppDecoration.outline1.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder20,
                            ),
                            child: CustomImageView(
                              height: 60.adaptSize,
                              width: 60.adaptSize,
                              svgPath: ImageConstant.imgOnboardingIcon,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
