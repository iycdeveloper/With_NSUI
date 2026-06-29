import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/custom_icon_button.dart';

import '../../../core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore_for_file: must_be_immutable
class OnboardingOneScreen extends StatelessWidget {
  const OnboardingOneScreen({Key? key})
      : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: mediaQueryData.size.height,
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgO,
                height: 812.v,
                width: 375.h,
                alignment: Alignment.center,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 20.h,
                      right: 20.h,
                      bottom: 30.v,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.h,
                      vertical: 12.v,
                    ),
                    decoration: const BoxDecoration(
                        color: Colors.transparent
                    ),
                    child: Stack(
                      children: [
                        CustomImageView(svgPath: ImageConstant.imgGroup3076,fit: BoxFit.cover),
                        Column(
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
                                  count: 3,
                                  effect: ScrollingDotsEffect(
                                    spacing: 12,
                                    activeDotColor: appTheme.blue80001,
                                    dotColor: appTheme.blue10001,
                                    dotHeight: 6.v,
                                    dotWidth: 24.h,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 256.h,
                              margin: EdgeInsets.only(
                                top: 16.v,
                                right: 38.h,
                              ),
                              child: Text(
                                "msg_join_us_to_empower".tr,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleLarge!.copyWith(
                                  height: 1.40,
                                ),
                              ),
                            ),
                            Container(
                              width: 273.h,
                              margin: EdgeInsets.only(
                                top: 6.v,
                                right: 21.h,
                              ),
                              child: Text(
                                "msg_let_s_build_an_india".tr,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyLarge!.copyWith(
                                  height: 1.60,
                                ),
                              ),
                            ),
                            SizedBox(height: 3.v),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 76.adaptSize,
                                width: 76.adaptSize,
                                padding: EdgeInsets.all(8.h),
                                decoration: AppDecoration.outline.copyWith(
                                  borderRadius: BorderRadiusStyle.roundedBorder20,
                                ),
                                child: CustomIconButton(
                                  onTap: (){
                                    RoutesManagement.goToOnboardingTwoScreen();
                                  },
                                  height: 60.adaptSize,
                                  width: 60.adaptSize,
                                  padding: EdgeInsets.all(20.h),
                                  decoration: IconButtonStyleHelper.outlineCyan,
                                  alignment: Alignment.center,
                                  child: CustomImageView(
                                    svgPath: ImageConstant.imgGroup17,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
