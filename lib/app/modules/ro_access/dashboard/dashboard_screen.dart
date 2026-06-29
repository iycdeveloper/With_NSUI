import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/modules/ro_access/dashboard/dashboard_controller.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/app/widgets/custom_floating_drop_down.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<DashboardController>(builder: (logic) {
        return Scaffold(
          appBar: CustomAppBar(
              leadingWidth: 44.h,
              leading: AppbarImage(
                  onTap: Get.back,
                  svgPath: ImageConstant.imgBiarrowleftIndigo800,
                  margin: EdgeInsets.only(left: 20.h, top: 15.v, bottom: 15.v)),
              title: AppbarSubtitle1(
                  text: 'Dashboard', margin: EdgeInsets.only(left: 12.h)),
              styleType: Style.standard),
          body: Padding(
            padding: EdgeInsets.all(0),
            child: Column(
              children: [
                CustomFloatingDropDown(
                    title: 'Options',
                    value: logic.selectedOptions,
                    listValues: logic.options,
                    onChanged: (value) {
                      logic.onChangeOptions(value);
                    }),
                if (logic.selectedOptions != null)...[
                  if(logic.selectedOptions == '0')
                  selfDetails(logic.self!),
                  if(logic.selectedOptions == '1')
                  selfDetails(logic.total!),
                  if(logic.selectedOptions == '2')...[
                    SizedBox(height: 20,),
                    teamDetails(logic.team!)
                  ]
                ]
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget selfDetails(Map<String, dynamic> data) => Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Assigned'),
                Text('${data['Total_Assigned']}')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Correct Count'),
                Text('${data['Correct_Count']}')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Incorrect Count'),
                Text('${data['Incorrect_Count']}')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pending Count'),
                Text('${data['Pending_Count']}')
              ],
            ),
          ],
        ),
      );

  Widget teamDetails(List<dynamic> teamDetails) {
    return Container(
      child: Expanded(
        child: ListView(
            children: List.generate(teamDetails.length, (index) {
          Map<String, dynamic> data = teamDetails[index] as Map<String, dynamic>;
          return Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Name'),
                    Text('${data['first_name']}')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Assigned'),
                    Text('${data['Total_Assigned']}')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Correct Count'),
                    Text('${data['Correct_Count']}')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Incorrect Count'),
                    Text('${data['Incorrect_Count']}')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pending Count'),
                    Text('${data['Pending_Count']}')
                  ],
                ),
              ],
            ),
          );
        })),
      ),
    );
  }
}
