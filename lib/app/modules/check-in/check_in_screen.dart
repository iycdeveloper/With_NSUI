import 'package:iyc/app/modules/check-in/check_in_controller.dart';
import 'package:iyc/app/modules/check-in/widget/add_check_in_bottom_sheet.dart';
import 'package:iyc/app/modules/check-in/widget/listmeeting_item_widget.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/utils/constants.dart';
import '../../core/app_export.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class CheckInScreen extends StatelessWidget {
  const CheckInScreen({Key? key})
      : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Constants.themeGradients[0],
            title: Text(
              "Report",
              // "MB-005-00-16",
              style: Constants.appbarTitleTextStyle,
            ),),
        // CustomAppBar(
        //   leadingWidth: 44.h,
        //   leading: AppbarImage(
        //     onTap: Get.back,
        //     svgPath: ImageConstant.imgBiarrowleftIndigo800,
        //     margin: EdgeInsets.only(
        //       left: 20.h,
        //       top: 15.v,
        //       bottom: 15.v,
        //     ),
        //   ),
        //   title: AppbarSubtitle1(
        //     text: "lbl_checkin_history".tr,
        //     margin: EdgeInsets.only(left: 12.h),
        //   ),
        //   styleType: Style.standard,
        // ),
        floatingActionButton: CustomElevatedButton(
            height: 50.v,
            width: 130.h,
            text: 'Add Check-in',
            buttonStyle: CustomButtonStyles.fillPrimaryTL8,
            buttonTextStyle: CustomTextStyles.bodyLargeOnPrimaryContainer,
            onTap:() {
              Get.find<CheckInController>().clearData();
              addCheckInBottomSheet();},
            alignment: Alignment.bottomRight),
        body: GetBuilder<CheckInController>(
          builder: (logic) {
            return SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 20.h,
                        top: 24.v,
                        right: 20.h,
                      ),
                      child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (
                              context,
                              index,
                              ) {
                            return SizedBox(
                              height: 16.v,
                            );
                          },
                          itemCount: logic.eventList.length,
                          itemBuilder: (context, index) {
                            var model = logic.eventList[index];
                            return CheckInTile(checkInData: model);
                          },
                        ),
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
