import 'package:iyc/app/modules/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_6.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/app/widgets/custom_pin_code_text_field.dart';
import 'package:iyc/utils/constants.dart';

// ignore_for_file: must_be_immutable
class OtpScreen extends GetWidget<LoginController> {
  const OtpScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Constants.themeGradients[0],
            title: Text(
              "lbl_otp".tr,
              // "MB-005-00-16",
              style: Constants.appbarTitleTextStyle,
            ),),
        
        // CustomAppBar(
        //   leadingWidth: 40.h,
        //   leading: AppbarImage(
        //     onTap: () {
        //       Get.back();
        //     },
        //     svgPath: ImageConstant.imgBiarrowleft,
        //     margin: EdgeInsets.only(
        //       left: 20.h,
        //       top: 18.v,
        //       bottom: 16.v,
        //     ),
        //   ),
        //   title: AppbarSubtitle6(
        //     text: "lbl_otp".tr,
        //     margin: EdgeInsets.only(left: 12.h),
        //   ),
        //   styleType: Style.bgFill,
        // ),
        body: SizedBox(
          width: double.maxFinite,
          child: GetBuilder<LoginController>(builder: (logic) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.h,
                      vertical: 32.v,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "msg_we_have_sent_a_verification".tr,
                          style: CustomTextStyles.bodyMediumBluegray70001_2,
                        ),
                        SizedBox(height: 12.v),
                        Text(
                          '+91-${controller.mobileNumberController.value.text}',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Obx(
                          () => CustomPinCodeTextField(
                            context: context,
                            margin: EdgeInsets.only(
                              top: 26.v,
                              right: 1.h,
                            ),
                            controller: controller.otpController.value,
                            onChanged: controller.verifyLoginOtp,
                          ),
                        ),
                        Spacer(),
                        logic.reSendOtp
                            ? SizedBox()
                            : Text(
                                '${logic.start} s',
                                style: CustomTextStyles.bodyLargeIndigo800,
                              ),
                        SizedBox(height: 12.v),
                        GestureDetector(
                          onTap: logic.onClickReSendOtp,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "msg_didn_t_receive_the2".tr,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                TextSpan(
                                  text: "lbl_resend_now".tr,
                                  style: logic.reSendOtp
                                      ? CustomTextStyles.bodyMediumPrimary
                                      : theme.textTheme.bodyMedium!.copyWith(
                                          color: theme.colorScheme.primary
                                              .withOpacity(0.5),
                                        ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 12.v),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
