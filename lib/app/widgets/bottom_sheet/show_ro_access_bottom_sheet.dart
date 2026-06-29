import 'package:flutter/material.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';
import '../../core/app_export.dart';
import 'package:iyc/app/routes/routes_management.dart';


void showRoAccessBottomSheet(){
  mediaQueryData = MediaQuery.of(Get.context!);
  Get.bottomSheet(
    SafeArea(
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))
          ),
          width: double.maxFinite,
          height: 280.v,
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.all(20.adaptSize),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RO Access',
                          style: TextStyle(
                              color: Color(0xff244974),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10.v,
                        ),
                        Text(
                          'Ro Access Home',
                          style: TextStyle(
                              color: Color(0xff869DB6),
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    AppbarImage1(
                      onTap:(){
                        Get.back();
                      },
                      svgPath: ImageConstant.imgEpcircleclose,
                    ),
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 20,),
              Padding(
                  padding: EdgeInsets.only(left: 20.h, right: 20.h),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: (){
                          Get.back();
                          RoutesManagement.goToROAccessScreen();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                          margin: const EdgeInsets.only(bottom: 8),
                          // height: 75,
                          width: mediaQueryData.size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE6E6E6), width: 1)),
                          child: SizedBox(
                            height: 39,
                            child: Row(
                              children: [
                                Text(
                                  'Nomination',
                                  style: const TextStyle(
                                    color: Color(0xff244974),
                                    fontFamily: 'Roboto',
                                    fontSize: 15.0,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xff869DB6),)
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Get.back();
                          RoutesManagement.goToMembershipRoAccess();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                          margin: const EdgeInsets.only(bottom: 8),
                          // height: 75,
                          width: mediaQueryData.size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE6E6E6), width: 1)),
                          child: SizedBox(
                            height: 39,
                            child: Row(
                              children: [
                                Text(
                                  'Membership',
                                  style: const TextStyle(
                                    color: Color(0xff244974),
                                    fontFamily: 'Roboto',
                                    fontSize: 15.0,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xff869DB6),)
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          )
      ),
    ),
    ignoreSafeArea: false
  );
}