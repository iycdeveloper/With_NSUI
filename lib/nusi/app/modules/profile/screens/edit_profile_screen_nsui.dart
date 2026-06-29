import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/custom_floating_drop_down_nsui.dart';
import 'package:iyc/app/widgets/drop_down/assembly_picker_drop_down.dart';
import 'package:iyc/app/widgets/drop_down/district_picker_drop_down_nsui.dart';
import 'package:iyc/nusi/app/modules/home/screens/home_controller_nsui.dart';
import 'package:iyc/nusi/app/modules/profile/screens/profile_controller_nsui.dart';
import 'package:iyc/nusi/app/modules/profile/widgets/profile_success_bootom_sheet_nsui.dart';
import 'package:iyc/nusi/widgets/common_dropdown_nsui.dart';
import 'package:iyc/nusi/widgets/custom_elevated_button_nsui.dart';
import 'package:iyc/screens/widgets/dropdown/assembly_picker_dropdown_nsui.dart';

class EditProfilescreenNSUI extends GetWidget<HomeNSUIController> {
  const EditProfilescreenNSUI({super.key});

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return GetBuilder<ProfileNSUIController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('Edit Profile',
                style: theme.textTheme.titleLarge!.copyWith(
                    color: appTheme.indigo800, fontWeight: FontWeight.bold)),
            elevation: 0,
            leading: AppbarImage(
                onTap: () {
                  Get.back();
                },
                svgPath: ImageConstant.imgBiarrowleftIndigo800,
                margin: EdgeInsets.only(left: 20.h, top: 15.v, bottom: 15.v)),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.only(
                left: mediaQueryData.size.width * 0.05,
                right: mediaQueryData.size.width * 0.05),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                  Color(0xFF2CC7E2).withOpacity(0.1),
                  Colors.white
                ])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                DistrictDropDrownNSUI(
                  labelcolor: theme.textTheme.bodyLarge!.color,
                  readOnly: false,
                  title: 'Choose District',
                  value: controller.selectedDistrict,
                  listValues: controller.districtList,
                  onChanged: (value) {
                    controller.onChangeDistrict(value);
                  },
                  lable: 'District',
                ),
                CustomFloatingDropDownNSUI(
                  labelcolor: theme.textTheme.bodyLarge!.color,
                  // readOnly: logic.isUpdate,
                  title: 'Select University',
                  value: controller.selectedAssembly,
                  listValues: controller.assemblyDropdownItems,
                  onChanged: (value) {
                    controller.onChangeAssembly(value);
                  },
                  defaultMargin: false,
                  labelText: 'University',
                ),
                CustomFloatingDropDownNSUI(
                  labelcolor: theme.textTheme.bodyLarge!.color,
                  // readOnly: logic.isUpdate,
                  title: 'Select a College',
                  value: controller.selectedCollege,
                  listValues: controller.boothDropdownItems,
                  onChanged: (value) {
                    controller.onchangecollege(value);
                  },
                  defaultMargin: false,
                  labelText: 'College',
                ),
                Spacer(),
                CustomElevatedButtonNSUI(
                    buttonStyle: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.blue)),
                    text: 'Submit',
                    onTap: () {
                      controller.updateProfile();
                    }),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
