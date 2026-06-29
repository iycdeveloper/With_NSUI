import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';
import 'package:iyc/nusi/widgets/custom_elevated_button_nsui.dart';
import 'package:iyc/utils/constants.dart';

Future<dynamic> nominationNSUIPaymentConfirmationBottomSheet(
    String? name, String amount, BuildContext context) {
  mediaQueryData = MediaQuery.of(context);
  return Get.bottomSheet(
    Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        width: double.maxFinite,
        height: mediaQueryData.size.height * 0.38,
        child: Column(children: [
          Container(
              decoration: BoxDecoration(
                  // color: Colors.white,
                  color: appTheme.indigo800,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24))),
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 17.v),
              // decoration: AppDecoration.heading,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Nomination",
                      style: CustomTextStyles.titleMediumOnPrimaryContainer18),
                  AppbarImage1(
                    onTap: () {
                      Get.back();
                    },
                    svgPath: ImageConstant.imgEpcircleclose,
                  ),
                ],
              )),
                   SizedBox(height: 25.v),

          SizedBox(
            width: mediaQueryData.size.width * 0.8,
            child: Text(
                textAlign: TextAlign.center,
                "You are applying for the Post $name and your payable amount is  ${Constants.rupeeSymbol + amount}",
                style: theme.textTheme.titleLarge),
          ),
         
          Spacer(),
          CustomElevatedButtonNSUI(
              width: mediaQueryData.size.width * 0.7,
              buttonStyle: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue)),
              text: 'Okay',
              onTap: () {
                Navigator.of(context).pop(true);
                // RoutesManagement.goToHomeScreenNSUI();
              }),
          SizedBox(height: 35.v),
        ])),
  );
}
