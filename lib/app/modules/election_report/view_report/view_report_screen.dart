import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/modules/election_report/view_report/view_report_controller.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/app/widgets/custom_floating_drop_down.dart';
import 'package:iyc/app/widgets/drop_down/state_picker_drop_down.dart';

class ViewReportScreen extends StatelessWidget {
  const ViewReportScreen();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<ViewReportController>(builder: (logic) {
        return Scaffold(
            appBar: CustomAppBar(
                leadingWidth: 44.h,
                leading: AppbarImage(
                    onTap: Get.back,
                    svgPath: ImageConstant.imgBiarrowleftIndigo800,
                    margin:
                        EdgeInsets.only(left: 20.h, top: 15.v, bottom: 15.v)),
                title: AppbarSubtitle1(
                    text: logic.reportData['report_name'],
                    margin: EdgeInsets.only(left: 12.h)),
                styleType: Style.standard),
            body: Column(
              children: [
                StateDropDrown(
                    title: 'State',
                    value: logic.selectedState,
                    listValues: logic.stateList,
                    onChanged: (value) {
                      logic.onChangeState(value);
                    }),
                CustomFloatingDropDown(
                    title: 'Month',
                    value: logic.selectedMonth,
                    listValues: logic.monthDropdownItems,
                    onChanged: (value) {
                      logic.onChangeMonth(value);
                    }),
                CustomFloatingDropDown(
                    title: 'Year',
                    value: logic.selectedYear,
                    listValues: logic.yearsDropdownItems,
                    onChanged: (value) {
                      logic.onChangeYear(value);
                    }),
              ],
            ),
            bottomNavigationBar: Container(
                padding: EdgeInsets.only(
                    left: 20.h, right: 20.h, bottom: 16.v, top: 16.v),
                decoration: AppDecoration.outlineBlue100011,
                child: CustomElevatedButton(
                    text: 'Get Report',
                    onTap: () {
                      if (logic.validateForm()) {
                        logic.getElectionUnitReport();
                      }
                    })));
      }),
    );
  }
}
