import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/modules/select_campaign/select_campaign_controller.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/app/widgets/custom_floating_drop_down.dart';
import 'package:iyc/app/widgets/loading_widget.dart';

class SelectCampaign extends StatelessWidget {
  const SelectCampaign();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<SelectCampaignController>(builder: (logic) {
        return Scaffold(
          appBar: CustomAppBar(
              leadingWidth: 44.h,
              leading: AppbarImage(
                  onTap: Get.back,
                  svgPath: ImageConstant.imgBiarrowleftIndigo800,
                  margin: EdgeInsets.only(left: 20.h, top: 15.v, bottom: 15.v)),
              title: AppbarSubtitle1(
                  text: 'Select Campaign', margin: EdgeInsets.only(left: 12.h)),
              styleType: Style.standard),
          bottomNavigationBar: logic.selectedCampaign == null
              ? SizedBox()
              : CustomElevatedButton(
                  text: "Continue".toUpperCase(),
                  margin:
                      EdgeInsets.only(left: 20.h, right: 20.h, bottom: 10.v),
                  onTap: () {
                    RoutesManagement.goToCampaignReportScreen(logic.selectedCampaign!);
                  }),
          body: logic.isLoading
              ? LoadingWidget()
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomFloatingDropDown(
                      title: 'Select Campaign',
                      value: logic.selectedCampaign,
                      listValues: logic.campaignDropdownItems,
                      onChanged: (value) {
                        logic.changeSelectedCampaign(value);
                      }),
                  // CustomElevatedButton(
                  //     text: "Continue".toUpperCase(),
                  //     margin:
                  //     EdgeInsets.only(left: 20.h, right: 20.h, bottom: 10.v),
                  //     onTap: () {}),
                ],
              ),
        );
      }),
    );
  }
}
