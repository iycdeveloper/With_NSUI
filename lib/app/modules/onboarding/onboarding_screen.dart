import 'package:flutter/material.dart';
import 'package:iyc/app/modules/onboarding/onboarding_controller.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';

import '../../core/app_export.dart';

// ignore_for_file: must_be_immutable
class OnboardingScreen extends GetWidget<OnboardingController> {
  const OnboardingScreen({Key? key})
      : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
          padding: EdgeInsets.only(bottom: 48.v),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                ImageConstant.imgGroup387,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: 32.h,
              vertical: 25.v,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6.v),
                CustomImageView(
                  imagePath: ImageConstant.imgLogowhite2,
                  height: 48.v,
                  width: 48.h,
                  fit: BoxFit.contain,
                ),
                Spacer(),
                SizedBox(
                  width: 311.h,
                  child: Text(
                    "msg_join_to_empower".tr,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall!.copyWith(
                      height: 1.40,
                    ),
                  ),
                ),
                SizedBox(height: 40.v,)
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomElevatedButton(
          height: 48.v,
          text: "lbl_get_started".tr.toUpperCase(),
          margin: EdgeInsets.only(
            left: 32.h,
            right: 32.h,
            bottom: 40.v,
          ),
          buttonStyle: CustomButtonStyles.fillPrimary,
          onTap:controller.onClickGetStarted
        ),
      ),
    );
  }
}
