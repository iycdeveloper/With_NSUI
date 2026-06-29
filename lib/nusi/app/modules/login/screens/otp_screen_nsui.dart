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
        resizeToAvoidBottomInset: false,
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Color(0xFF1356BF),
                  Color(0xFF5B2EC4),
                  Color(0xFF2CC7E2),
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
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 24,
                              offset: const Offset(0, 12))
                        ]),
                    child: Column(
                      children: [
                        Container(
                          height: 92,
                          width: 92,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFEAF1FC), Color(0xFFF3ECFF)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFF1356BF)
                                      .withOpacity(0.18),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6))
                            ],
                          ),
                          child: Image.asset(
                            "assets/nsui/applogo/playstore.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            const Text(
                              'Verify Your Phone',
                              style: TextStyle(
                                  color: Color(0xFF1F2A44),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              'Enter the code we sent to your phone number.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13),
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
                            GestureDetector(
                              onTap: () {
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
                              child: Container(
                                width: double.infinity,
                                height: 54,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF1356BF),
                                      Color(0xFF2CC7E2)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0xFF1356BF)
                                            .withOpacity(0.35),
                                        blurRadius: 16,
                                        offset: const Offset(0, 8))
                                  ],
                                ),
                                child: const Text(
                                  "Log In",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
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
