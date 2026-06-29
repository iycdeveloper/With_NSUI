import 'package:flutter/material.dart';
import 'package:iyc/app/modules/check-in/check_in_controller.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/app/widgets/custom_floating_drop_down.dart';
import 'package:iyc/app/widgets/custom_floating_text_field.dart';
import 'package:iyc/app/widgets/drop_down/state_picker_drop_down.dart';
import '../../../core/app_export.dart';

void addCheckInBottomSheet() {
  mediaQueryData = MediaQuery.of(Get.context!);
  Get.bottomSheet(
    GetBuilder<CheckInController>(builder: (logic) {
      return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24))),
          width: double.maxFinite,
          height: MediaQuery.of(Get.context!).size.height*0.7,
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          // color: Colors.white,
                          color: appTheme.indigo800,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24))),
                      width: double.maxFinite,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                      // decoration: AppDecorationeading,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Check-IN",
                              style: CustomTextStyles
                                  .titleMediumOnPrimaryContainer18),
                          AppbarImage1(
                            onTap: () {
                              Get.back();
                            },
                            svgPath: ImageConstant.imgEpcircleclose,
                          ),
                        ],
                      )),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text('Purpose of Visit',
                        style: theme.textTheme.titleLarge),
                  ),
                  CustomFloatingTextField(
                    margin: EdgeInsets.only(left: 20, top: 24, right: 20),
                    controller: logic.purposeController,
                    labelText: 'Purpose of visit',
                    labelStyle: theme.textTheme.bodyMedium!,
                    hintText: "e.g. Attending conference".tr,
                    hintStyle: theme.textTheme.bodyMedium!,
                    textInputAction: TextInputAction.done,
                    // contentPadding: EdgeInsets.fromLTRB(16, 15, 16, 70),
                  ),
                  StateDropDrown(
                      title: 'State',
                      value:logic.selectedState,
                      listValues:logic.stateList,
                      onChanged: (value) {
                        logic.onChangeState(value);
                      }),
                  CustomFloatingDropDown(
                      title: 'District',
                      value: logic.selectedDistrict,
                      listValues: logic.districtDropdownItems,
                      onChanged: (value) {
                        Log.printDLog(value);
                        logic.changeDistrict(value);
                      }),
                  SizedBox(height: 5),
                  CustomElevatedButton(
                      text: 'submit now'.toUpperCase(),
                      margin: EdgeInsets.only(left: 20, top: 24, right: 20),
                      onTap: logic.onClickCheckIn),
                  SizedBox(height: 10)
                ]),
          ));
    }),
  );
}

void checkInSuccessBottomSheet() {
  mediaQueryData = MediaQuery.of(Get.context!);
  Get.bottomSheet(
    GetBuilder<CheckInController>(builder: (logic) {
      return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24))),
          width: double.maxFinite,
          height: 266,
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                  decoration: BoxDecoration(
                      // color: Colors.white,
                      color: appTheme.indigo800,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24))),
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                  // decoration: AppDecorationeading,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Check-IN",
                          style:
                              CustomTextStyles.titleMediumOnPrimaryContainer18),
                      AppbarImage1(
                        onTap: () {
                          Get.back();
                        },
                        svgPath: ImageConstant.imgEpcircleclose,
                      ),
                    ],
                  )),
              SizedBox(height: 33),
              CustomImageView(
                svgPath: ImageConstant.imgTicket,
                height: 72.adaptSize,
                width: 72.adaptSize,
              ),
              SizedBox(height: 16),
              Text(
                "msg_check_in_event_success".tr,
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 5),
              SizedBox(height: 5)
            ]),
          ));
    }),
  );
}
