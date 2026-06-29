import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/size_utils.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/custom_pin_code_text_field.dart';
import 'package:iyc/nusi/app/modules/login/screens/login_controller_nsui.dart';
// ignore: unused_import
import 'package:iyc/nusi/app/modules/splash/screens/splash_controller_nsui.dart';

class OtpScreenNSUI extends GetWidget<LoginNSUIController> {
  const OtpScreenNSUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return GetBuilder<LoginNSUIController>(builder: (controller) {
      return SafeArea(
          child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Color(0xFF4193D0),
                  Color(0xFF3367B1),
                ])),
            // padding: EdgeInsets.only(bottom: 235.v),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: mediaQueryData.size.width * 0.9,
                    // height: mediaQueryData.size.height * 0.23,
                    padding: EdgeInsets.all(mediaQueryData.size.width * 0.05),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        SizedBox(
                          width: mediaQueryData.size.width * 0.2,
                          height: mediaQueryData.size.height * 0.1,
                          child: Image.asset(
                            "assets/nsui/applogo/playstore.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            Text(
                              'Verify Your Phone',
                              style: theme.textTheme.titleLarge!.copyWith(
                                  // color: Colors.white,
                                  fontSize: mediaQueryData.size.height * 0.03),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Enter the code we  send to your phone number.',
                              style: theme.textTheme.bodyLarge!.copyWith(
                                  color: Colors.black,
                                  fontSize: mediaQueryData.size.height * 0.015),
                            ),

                            Obx(
                              () => CustomPinCodeTextField(
                                context: context,
                                margin: EdgeInsets.only(
                                  top: 26.v,
                                  right: 1.h,
                                ),
                                controller: controller.otpController.value,
                                onChanged: (val) {},
                              ),
                            ),
                            SizedBox(
                              height: mediaQueryData.size.height * 0.03,
                            ),
                            SizedBox(
                                width: mediaQueryData.size.width,
                                height: mediaQueryData.size.height * 0.05,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    onPressed: () {
                                      if (controller.otpController.value.text
                                          .isNotEmpty) {
                                        controller.verifyLoginOtp(controller
                                            .otpController.value.text
                                            .toString());
                                      } else {
                                        CustomSnackBar.showWarningSnackBar(
                                            'Please enter correct OTP');
                                      }
                                    },
                                    child: Text(
                                      "Log In",
                                      style: theme.textTheme.bodyLarge!
                                          .copyWith(color: Colors.white),
                                    ))),
                            SizedBox(
                              height: mediaQueryData.size.height * 0.05,
                            ),
                            controller.reSendOtp
                                ? SizedBox()
                                : Text(
                                    '${controller.start} s',
                                    style: CustomTextStyles.bodyLargeIndigo800,
                                  ),
                            SizedBox(height: 12.v),
                            GestureDetector(
                                onTap: controller.onClickReSendOtp,
                                child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: "Didn't receive the code?",
                                          style: theme.textTheme.bodyMedium!
                                              .copyWith(color: Colors.black)),
                                      TextSpan(text: "  ".tr),
                                      TextSpan(
                                          text: "Resend code",
                                          style: theme.textTheme.bodyMedium!
                                              .copyWith(color: Colors.orange))
                                    ]),
                                    textAlign: TextAlign.left)),
                            // Spacer(),
                            // controller.reSendOtp
                            //     ? SizedBox()
                            //     : Text(
                            //         '${controller.start} s',
                            //         style: CustomTextStyles.bodyLargeIndigo800,
                            //       ),
                            // SizedBox(height: 12.v),
                            // GestureDetector(
                            //   onTap: controller.onClickReSendOtp,
                            //   child: RichText(
                            //     text: TextSpan(
                            //       children: [
                            //         TextSpan(
                            //           text: "msg_didn_t_receive_the2".tr,
                            //           style: theme.textTheme.bodyMedium,
                            //         ),
                            //         TextSpan(
                            //           text: "lbl_resend_now".tr,
                            //           style: controller.reSendOtp
                            //               ? CustomTextStyles.bodyMediumPrimary
                            //               : theme.textTheme.bodyMedium!
                            //                   .copyWith(
                            //                   color: theme.colorScheme.primary
                            //                       .withOpacity(0.5),
                            //                 ),
                            //         ),
                            //       ],
                            //     ),
                            //     textAlign: TextAlign.left,
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: mediaQueryData.size.height * 0.1,
                        ),
                      ],
                    )),
              ],
            )),
      ));
    });
  }
}
