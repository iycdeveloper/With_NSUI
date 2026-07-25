import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/size_utils.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/nusi/app/modules/login/screens/login_controller_nsui.dart';
import 'package:iyc/nusi/app/modules/login/widgets/logout_confirmation_bootom_sheet_nsui.dart';
// ignore: unused_import
import 'package:iyc/nusi/app/modules/splash/screens/splash_controller_nsui.dart';
import 'package:iyc/nusi/widgets/textfeild_with_label_nsui.dart';
import 'package:iyc/screens/widgets/textfeild_with_label.dart';

class LoginScreenNSUI extends GetWidget<LoginNSUIController> {
  const LoginScreenNSUI({Key? key}) : super(key: key);

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
                            InkWell(
                              onTap: () async {
                                // final result =
                                //     await logoutConfirmationNSUIBottomSheet(
                                //         context);
                                // if (result) {
                                //   print(result);
                                // }
                              },
                              child: const Text(
                                'Welcome !',
                                style: TextStyle(
                                    color: Color(0xFF1F2A44),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              'Login with your mobile number to continue.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Obx(
                              () => TextFieldWithLabelNSUI(
                                label: "Enter Phone Number",
                                icon: Icons.phone_outlined,
                                hintText: "Phone Number",
                                // focusNode: model.usernameFocus,
                                // nextFocus: model.lastNameFocus,

                                // readOnly: model.disableFields,
                                keyBoardType: TextInputType.number,
                                // maxLength: 10,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                controller:
                                    controller.mobileNumberController.value,
                                validation: (value) {
                                  if (value.length != 10) {
                                    return "Please enter valid phone number";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: mediaQueryData.size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: controller.onClickLogin,
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
                                  "Next",
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
                            GestureDetector(
                                onTap: () {
                                  RoutesManagement.goToRegisterScreenNSUI('');
                                },
                                child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: "Don’t have an account?",
                                          style: theme.textTheme.bodyMedium!
                                              .copyWith(color: Colors.black)),
                                      TextSpan(text: "  ".tr),
                                      TextSpan(
                                          text: "Sign Up",
                                          style: theme.textTheme.bodyMedium!
                                              .copyWith(color: Colors.orange))
                                    ]),
                                    textAlign: TextAlign.left)),
                          ],
                        ),
                        SizedBox(
                          height: mediaQueryData.size.height * 0.1,
                        ),
                      ],
                    )),
                if (controller.appVersion.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(
                    'version ${controller.appVersion}',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.75), fontSize: 12),
                  ),
                ],
              ],
            )),
      ));
    });
  }
}
