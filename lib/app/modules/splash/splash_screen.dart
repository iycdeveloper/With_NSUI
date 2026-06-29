import 'package:flutter/material.dart';
import 'package:iyc/app/modules/splash/splash_controller.dart';

import '../../core/app_export.dart';

class SplashScreen extends GetWidget<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);

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
                padding: EdgeInsets.only(bottom: 46.v),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment(0.5, 0),
                        end: Alignment(0.5, 1),
                        colors: [
                            Color(0xFF2CC7E2),
                            Color(0xFF263DAB)
                          // theme.colorScheme.primary,
                          // appTheme.indigo700
                        ]),
                    image: DecorationImage(
                        image: AssetImage(ImageConstant.imgGroup393),
                        fit: BoxFit.cover)),
                child: Container(
                    height: 691.v,
                    width: double.maxFinite,
                    padding: EdgeInsets.only(bottom: 235.v),
                    child: Stack(alignment: Alignment.bottomCenter, children: [
                      CustomImageView(
                        fit: BoxFit.fitHeight,
                          imagePath: ImageConstant.imgImage31,
                          height: 188.v,
                          width: 229.h,
                          alignment: Alignment.bottomCenter),
                      CustomImageView(
                          imagePath: ImageConstant.imgImage32,
                          height: 77.v,
                          width: 74.h,
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.only(bottom: 26.v))
                    ]))),
            bottomNavigationBar: Container(
                height: 46.v,
                width: 277.h,
                margin: EdgeInsets.only(left: 49.h, right: 49.h, bottom: 31.v),
                child: Stack(alignment: Alignment.topCenter, children: [
                  CustomImageView(
                      imagePath: ImageConstant.imgImage3146x277,
                      height: 46.v,
                      width: 277.h,
                      alignment: Alignment.center),
                  CustomImageView(
                      imagePath: ImageConstant.imgImage33,
                      height: 24.v,
                      width: 277.h,
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 10.v))
                ]))));
  }
}
