import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/modules/contributions/contributions_controller.dart';
import 'package:iyc/app/modules/contributions/local_widget/donation_success_bottom_sheet.dart';
import 'package:iyc/app/modules/contributions/local_widget/leaderboard_tile.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/app/widgets/custom_floating_drop_down.dart';
import 'package:iyc/app/widgets/custom_floating_text_field.dart';

class ContributionsScreen extends StatelessWidget {
  const ContributionsScreen();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          leadingWidth: 44.h,
          leading: AppbarImage(
            onTap: Get.back,
            svgPath: ImageConstant.imgBiarrowleftIndigo800,
            margin: EdgeInsets.only(
              left: 20.h,
              top: 15.v,
              bottom: 15.v,
            ),
          ),
          title: AppbarSubtitle1(
            text: "Contributions",
            margin: EdgeInsets.only(left: 12.h),
          ),
          styleType: Style.standard,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 20),
          child: GetBuilder<ContributionsController>(
            builder: (logic) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomImageView(
                      radius: BorderRadius.circular(16),
                      imagePath: ImageConstant.imgDonationBanner,
                      height: 160.v,
                      width: double.maxFinite,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Donate For Desh',
                      style: TextStyle(
                          color: Color(0xff244974),
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'The campaign aims at empowering the party to create an India rich in equal resource distribution and opportunities.',
                      style: TextStyle(
                          color: Color(0xff244974),
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    CustomFloatingDropDown(
                      defaultMargin: false,
                        title: 'Select a Campaign',
                        value: logic.selectedGender,
                        listValues: logic.genders,
                        onChanged: (value) {
                          logic.onChangeGender(value);
                        }),
                    SizedBox(
                      height: 16,
                    ),
                    CustomFloatingTextField(
                        controller: logic.donationController,
                        labelText: 'Donate Amount',
                        labelStyle: theme.textTheme.bodyLarge!,
                        hintText: 'Enter your donation',
                        hintStyle: theme.textTheme.bodyLarge!,
                        validator: (value) {
                          if (value!.length < 3) {
                            return "Please enter valid text";
                          }
                          return null;
                        }),
                    SizedBox(
                      height: 24,
                    ),
                    CustomElevatedButton(
                        text: "donate".toUpperCase(),
                        onTap: donationSuccessBottomSheet),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Leaderboard',
                      style: TextStyle(
                          color: Color(0xff244974),
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 24.v),
                    Container(
                        height: 46.v,
                        width: 335.h,
                        decoration: BoxDecoration(
                            color: theme.colorScheme.onPrimaryContainer
                                .withOpacity(1),
                            borderRadius: BorderRadius.circular(12.h)),
                        child: TabBar(
                            onTap: logic.updateCurrentIndexForPointSystem,
                            controller: logic.tabviewControllerForPointSystem,
                            labelPadding: EdgeInsets.zero,
                            labelColor: theme.colorScheme.onPrimaryContainer
                                .withOpacity(1),
                            labelStyle: TextStyle(
                                fontSize: 14.fSize,
                                fontFamily: 'Be Vietnam Pro',
                                fontWeight: FontWeight.w400),
                            unselectedLabelColor: appTheme.indigo800,
                            unselectedLabelStyle: TextStyle(
                                fontSize: 14.fSize,
                                fontFamily: 'Be Vietnam Pro',
                                fontWeight: FontWeight.w400),
                            indicatorPadding: EdgeInsets.all(7.0.h),
                            indicator: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(12.h)),
                            tabs: [
                              Tab(child: Text("lbl_state".tr)),
                              Tab(child: Text("lbl_district".tr)),
                              Tab(child: Text("lbl_assembly".tr))
                            ])),
                    SizedBox(height: 24.v),
                    LeaderboardTile(),
                    LeaderboardTile(),
                    LeaderboardTile(),
                    LeaderboardTile(),
                    LeaderboardTile(),
                    LeaderboardTile(),
                    LeaderboardTile(),
                    LeaderboardTile(),
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
