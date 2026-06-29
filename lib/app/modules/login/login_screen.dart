import 'package:flutter/services.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:iyc/app/modules/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';

class LoginScreen extends GetWidget<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return GetBuilder<LoginController>(builder: (controller) {
      return SafeArea(
          child: Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              body: Container(
                  width: mediaQueryData.size.width,
                  height: mediaQueryData.size.height,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment(0.5, 0),
                          end: Alignment(0.5, 1),
                          colors: [
                            Color(0xFF2CC7E2),
                            Color(0xFF263DAB)
                        // theme.colorScheme.primary,
                        // appTheme.indigo500,
                        
                      ])),
                  child: SizedBox(
                      height: 768.v,
                      width: double.maxFinite,
                      child:
                          Stack(alignment: Alignment.bottomCenter, children: [
                        Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                                width: double.maxFinite,
                                margin: EdgeInsets.only(bottom: 200.v),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40.h, vertical: 198.v),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            ImageConstant.imgGroup393),
                                        fit: BoxFit.fitHeight)),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          height: 113.v,
                                          width: 88.h,
                                          margin: EdgeInsets.only(bottom: 59.v),
                                          child: Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: [
                                                CustomImageView(
                                                    fit: BoxFit.fitHeight,
                                                    imagePath: ImageConstant
                                                        .imgImage31113x88,
                                                    height: 113.v,
                                                    width: 88.h,
                                                    alignment:
                                                        Alignment.center),
                                                CustomImageView(
                                                    imagePath: ImageConstant
                                                        .imgImage32,
                                                    height: 46.v,
                                                    width: 44.h,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    margin: EdgeInsets.only(
                                                        bottom: 15.v))
                                              ])),
                                      CustomImageView(
                                          imagePath: ImageConstant.imgImage48,
                                          height: 114.v,
                                          width: 206.h,
                                          margin: EdgeInsets.only(bottom: 58.v))
                                    ]))),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                decoration: AppDecoration.white.copyWith(
                                    borderRadius:
                                        BorderRadiusStyle.customBorderTL32),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20.h),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 22.v),
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      
                                                                    },
                                                                    child: Text(
                                                                        "lbl_login"
                                                                            .tr,
                                                                        style: theme
                                                                            .textTheme
                                                                            .titleLarge),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          6.v),
                                                                  Text(
                                                                      "msg_welcome_back_login"
                                                                          .tr,
                                                                      style: CustomTextStyles
                                                                          .bodyMediumBluegray70001_2)
                                                                ]))),
                                                    Container(
                                                        height: 57.v,
                                                        width: 54.h,
                                                        margin: EdgeInsets.only(
                                                            left: 17.h,
                                                            bottom: 16.v),
                                                        decoration: BoxDecoration(
                                                            color: theme
                                                                .colorScheme
                                                                .primary
                                                                .withOpacity(
                                                                    0.1),
                                                            borderRadius: BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        32.h),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        27.h))))
                                                  ]))),
                                      Container(
                                          width: 335.h,
                                          margin: EdgeInsets.only(
                                              left: 20.h,
                                              top: 20.v,
                                              right: 20.h),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.h,
                                          ),
                                          decoration: AppDecoration.strokeWhite
                                              .copyWith(
                                                  borderRadius:
                                                      BorderRadiusStyle
                                                          .roundedBorder12),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 16.v,
                                                ),
                                                Text("lbl_phone_number".tr,
                                                    style: theme
                                                        .textTheme.bodyMedium),
                                                Obx(
                                                  () => TextField(
                                                    controller: controller
                                                        .mobileNumberController
                                                        .value,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    // maxLength: 10,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          10)
                                                    ],
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            "msg_enter_your_phone"
                                                                .tr,
                                                        hintStyle: CustomTextStyles
                                                            .bodyLargeIndigo100,
                                                        border:
                                                            InputBorder.none),
                                                  ),
                                                ),
                                              ])),
                                      CustomElevatedButton(
                                          text: "lbl_login2".tr.toUpperCase(),
                                          margin: EdgeInsets.only(
                                              left: 20.h,
                                              top: 20.v,
                                              right: 20.h),
                                          onTap: controller.onClickLogin),
                                      SizedBox(height: 23.v),
                                      GestureDetector(
                                          onTap: () {
                                            RoutesManagement.goToRegisterScreen(
                                                '');
                                          },
                                          child: RichText(
                                              text: TextSpan(children: [
                                                TextSpan(
                                                    text:
                                                        "msg_don_t_have_an_account2"
                                                            .tr,
                                                    style: theme
                                                        .textTheme.bodyMedium),
                                                TextSpan(text: "  ".tr),
                                                TextSpan(
                                                    text: "lbl_register2".tr,
                                                    style: CustomTextStyles
                                                        .bodyMediumPrimary)
                                              ]),
                                              textAlign: TextAlign.left)),
                                      SizedBox(height: 32.v)
                                    ])))
                      ])))));
    });
  }
}
