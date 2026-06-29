import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/size_utils.dart';
import 'package:iyc/nusi/app/modules/splash/screens/splash_controller_nsui.dart';

class SplashScreenNSUI extends GetWidget<SplashNSUIController> {
  const SplashScreenNSUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: mediaQueryData.size.width * 0.5,
                height: mediaQueryData.size.height * 0.23,
                child: Image.asset(
                  "assets/nsui/applogo/playstore.png",
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                children: [
                  Text(
                    'Welcome to the NSUI',
                    style: theme.textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                        fontSize: mediaQueryData.size.height * 0.03),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'National Student’s Union of India',
                    style: theme.textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontSize: mediaQueryData.size.height * 0.025),
                  ),
                ],
              ),
              SizedBox(
                width: mediaQueryData.size.width,
                height: mediaQueryData.size.height * 0.5,
                child: Image.asset(
                  "assets/nsui/applogo/logo2.png",
                  fit: BoxFit.cover,
                ),
              )
            ],
          )),
    ));
  }
}
