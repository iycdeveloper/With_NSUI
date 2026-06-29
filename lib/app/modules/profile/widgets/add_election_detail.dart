import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/modules/profile/profile_controller.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/app/widgets/custom_floating_drop_down.dart';
import 'package:iyc/app/widgets/custom_floating_text_field.dart';
import 'package:iyc/app/widgets/upload_button/upload_image_button.dart';
import 'package:iyc/utils/constants.dart';

class AddElectionDetail extends StatefulWidget {
  const AddElectionDetail();

  @override
  State<AddElectionDetail> createState() => _AddElectionDetailState();
}

class _AddElectionDetailState extends State<AddElectionDetail> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<ProfileController>(builder: (logic) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: appTheme.gray5001,
          appBar: CustomAppBar(
              leadingWidth: 44.h,
              leading: AppbarImage(
                  onTap: () {
                    Get.back(result: 1);
                  },
                  svgPath: ImageConstant.imgBiarrowleftIndigo800,
                  margin: EdgeInsets.only(left: 20.h, top: 15.v, bottom: 15.v)),
              title: AppbarSubtitle1(
                  text: "Add Election Detail",
                  margin: EdgeInsets.only(left: 12.h)),
              styleType: Style.standard),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CustomFloatingTextField(
                //   readOnly: true,
                //   textInputType: TextInputType.text,
                //   // controller: logic.dateController,
                //   // margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                //   labelText: 'Program Date',
                //   labelStyle: theme.textTheme.bodyLarge!,
                //   hintText: 'Program Date',
                //   hintStyle: theme.textTheme.bodyLarge!,
                //   onTap: () async {
                //     final datePick = await showDatePicker(
                //       context: Get.context!,
                //       initialDate: DateTime.now(),
                //       firstDate:
                //           DateTime.now().subtract(const Duration(days: 365)),
                //       lastDate: DateTime.now().add(const Duration(days: 365)),
                //       builder: (BuildContext? context, Widget? child) {
                //         return Theme(
                //           data: ThemeData.dark().copyWith(
                //             colorScheme: ColorScheme.dark(
                //               primary: Constants.themeGradients[1],
                //               onPrimary: Colors.black87,
                //               surface: Constants.themeGradients[0],
                //               onSurface: Constants.themeGradients[1],
                //             ),
                //             dialogBackgroundColor: Constants.themeGradients[0],
                //           ),
                //           child: child!,
                //         );
                //       },
                //     );
                //     // if (datePick != null && datePick != logic.selectedDate2) {
                //     //   logic.onChangeDate(datePick);
                //     // }
                //   },
                // ),
                SizedBox(
                  height: 10,
                ),
                CustomFloatingDropDown(
                  title: 'Level of Election Contest',
                  value: logic.selectedElectionLevel,
                  listValues: logic.electionLevel,
                  onChanged: (value) {
                    logic.onChangeElectionLevel(value);
                  },
                  defaultMargin: false,
                ),
                // SizedBox(
                //   height: 10,
                // ),
                // CustomFloatingTextField(
                //   readOnly: true,
                //   textInputType: TextInputType.text,
                //   // controller: logic.dateController,
                //   // margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                //   labelText: 'Contesting Post',
                //   labelStyle: theme.textTheme.bodyLarge!,
                //   hintText: 'Contesting Post',
                //   hintStyle: theme.textTheme.bodyLarge!,

                // ),
                CustomFloatingTextField(
                  // textInputType: TextInputType.number,
                  textInputType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    // LengthLimitingTextInputFormatter(10)
                  ],
                  controller: logic.noOfVoteObtain,
                  margin: const EdgeInsets.only(top: 10),
                  labelText: 'Number of Votes Obtained',
                  labelStyle: theme.textTheme.bodyLarge!,
                  hintText: 'Number of Votes Obtained',
                  hintStyle: theme.textTheme.bodyLarge!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter no of vote obtain";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                CustomFloatingDropDown(
                  title: 'Year',
                  value: logic.selectedYear,
                  listValues: logic.year,
                  onChanged: (value) {
                    logic.onChangeYear(value);
                  },
                  defaultMargin: false,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomFloatingDropDown(
                  title: 'Result',
                  value: logic.selectedResult,
                  listValues: logic.result,
                  onChanged: (value) {
                    logic.onChangeResult(value);
                  },
                  defaultMargin: false,
                ),
                SizedBox(
                  height: 10,
                ),
                UploadButtonImage(
                  defaultPadding: true,
                  onTap: (str) {
                    logic.pickVoterDocument(str, logic.pickedVoterPath,
                        DocumentType.amImage, context);
                  },
                  showImage: logic.pickedVoterPath != null,
                  pickedFile: logic.pickedVoter,
                  buttonTextLabel: "Photo of the Election Result",
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
              padding: EdgeInsets.only(
                  left: 20.h, right: 20.h, bottom: 10.v, top: 10.v),
              decoration: AppDecoration.outlineBlue100011,
              child: CustomElevatedButton(
                  text: 'SUBMIT',
                  onTap: () {
                    logic.onSubmit(context);
                    // Get.back();
                  })),
          // bottomNavigationBar: CustomElevatedButton(
          //     onTap: (){
          //       logic.onSubmit();
          //       Get.back();
          //     },
          //     text: 'Submit',
          //     margin: EdgeInsets.only(left: 20.h, right: 20.h, bottom: 19.v)),
        );
      }),
    );
  }
}
