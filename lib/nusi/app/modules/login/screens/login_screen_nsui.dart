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
                        CircleAvatar(
                          child: Image.asset(
                            "assets/nsui/applogo/playstore.png",
                            fit: BoxFit.cover,
                          ),
                          radius: mediaQueryData.size.height*0.05,
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
                              child: Text(
                                'Welcome !',
                                style: theme.textTheme.titleLarge!.copyWith(
                                    // color: Colors.white,
                                    fontSize:
                                        mediaQueryData.size.height * 0.03),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Login with your mobile number to continue.',
                              style: theme.textTheme.bodyLarge!.copyWith(
                                  color: Colors.black,
                                  fontSize: mediaQueryData.size.height * 0.015),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Obx(
                              () => TextFieldWithLabelNSUI(
                                label: "Enter Phone Number",
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
                            SizedBox(
                                width: mediaQueryData.size.width,
                                height: mediaQueryData.size.height * 0.05,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    onPressed: controller.onClickLogin,
                                    child: Text(
                                      "Next",
                                      style: theme.textTheme.bodyLarge!
                                          .copyWith(color: Colors.white),
                                    ))),
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
              ],
            )),
      ));
    });
  }
}
