import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/modules/membership/controllers/membership_batch_controller.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';

class MembershipLandingPage extends StatelessWidget {
  const MembershipLandingPage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: CustomAppBar(
                leadingWidth: 44.h,
                leading: AppbarImage(
                    onTap: () {
                      Get.back();
                    },
                    svgPath: ImageConstant.imgBiarrowleftIndigo800,
                    margin:
                        EdgeInsets.only(left: 20.h, top: 15.v, bottom: 15.v)),
                title: AppbarSubtitle1(
                    text: "Membership", margin: EdgeInsets.only(left: 12.h)),
                styleType: Style.standard),
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                    const Color(0xFF2CC7E2).withOpacity(0.1),
                    Colors.white
                  ])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        bottom: 20, top: 15, left: 20, right: 20),
                    width: double.infinity,
                    height: 190.v,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                            image: AssetImage(
                                "assets/nsui/banner/membershipbanner.jpeg"),
                            fit: BoxFit.fill)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome!',
                            style: theme.textTheme.bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'We have Introduced a new facility to add multiple AMs from one app. Please go through the information flyer to find out how this app will help you. Click here',
                          style: TextStyle(
                            color:
                                Color(0xFF4193D0), // Hex color to Color object
                            fontFamily: 'Be Vietnam Pro',
                            fontSize: 14,
                            fontWeight: FontWeight.w400, // Normal font weight
                            height: 1.6, // Line height as a multiplier
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        _row(
                            'WE DO NOT DISCLOSE District-wise \nMembership Closure.'),
                        const SizedBox(
                          height: 10,
                        ),
                        _row(
                            'Fees payment is accepted \nONLY for Synced data.'),
                        const SizedBox(
                          height: 10,
                        ),
                        _row(
                            'Unpaid SYNC data will be deleted after \nMembership closure.'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  // const Spacer(),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Container(
                  //       margin: const EdgeInsets.all(20),
                  //       width: mediaQueryData.size.width * 0.8,
                  //       padding: const EdgeInsets.all(10),
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10),
                  //           color: Colors.lightBlueAccent.shade100
                  //               .withOpacity(0.2)),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           const Icon(Icons.info),
                  //           SizedBox(
                  //               width: mediaQueryData.size.width * 0.6,
                  //               child: const Text(
                  //                   'You can now add multiple AMs from a single app. '))
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
            bottomNavigationBar: Container(
                padding: EdgeInsets.only(
                    left: 20.h, right: 20.h, bottom: 10.v, top: 10.v),
                decoration: AppDecoration.outlineBlue100011,
                child: CustomElevatedButton(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 0.6,
                          blurRadius: 0.6
                        )
                      ]),
                    buttonStyle: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // This creates sharp, unrounded corners
                      ),
                    ),
                    text: "Apply",
                    onTap: () => Get.find<MembershipBatchController>()
                        .getAggrId(context)))));
  }

  Widget _row(String title) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: CustomImageView(
              svgPath: ImageConstant.imgBoldArrow,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(title,
              style: theme.textTheme.bodyMedium!
                  .copyWith(color: Color(0xFF4193D0)))
        ],
      );
}
