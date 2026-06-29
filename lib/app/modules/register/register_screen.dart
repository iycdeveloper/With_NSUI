import 'dart:io';

import 'package:flutter/services.dart';
import 'package:iyc/app/modules/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/validation_functions.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/app/widgets/custom_floating_drop_down.dart';
import 'package:iyc/app/widgets/custom_floating_text_field.dart';
import 'package:iyc/app/widgets/drop_down/assembly_picker_drop_down.dart';
import 'package:iyc/app/widgets/drop_down/district_picker_drop_down.dart';
import 'package:iyc/app/widgets/drop_down/state_picker_drop_down.dart';
import 'package:iyc/app/widgets/upload_button/upload_image_button.dart';
import 'package:iyc/screens/widgets/dropdown/category_picker_new_dropdown.dart';
import 'package:iyc/utils/constants.dart';

// ignore_for_file: must_be_immutable
class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(child: GetBuilder<RegisterController>(builder: (logic) {
      return Scaffold(
          resizeToAvoidBottomInset: true,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
                key: logic.formKey,
                child: SizedBox(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          SizedBox(
                              height: 160.v,
                              width: double.maxFinite,
                              child: Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: [
                                    CustomImageView(
                                        imagePath: ImageConstant.imgImage16,
                                        height: 160.v,
                                        width: 375.h,
                                        alignment: Alignment.center),
                                    Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Container(
                                            width: 287.h,
                                            margin: EdgeInsets.only(
                                                left: 20.h, bottom: 17.v),
                                            child: Text(
                                                "msg_join_the_movement".tr,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: CustomTextStyles
                                                    .titleLargeOnPrimaryContainer
                                                    .copyWith(height: 1.40))))
                                  ])),
                          SizedBox(
                            height: 20.v,
                          ),
                          UploadButtonImage(
                            onTap: (str) {
                              logic.pickDocument(str, logic.pickedAMFilePath,
                                  DocumentType.amImage, context);
                            },
                            showImage: logic.pickedAMFilePath != null,
                            pickedFile: logic.pickedAMFile,
                            buttonTextLabel: "Upload Profile Photo",
                          ),
                          CustomFloatingTextField(
                              margin: EdgeInsets.only(
                                  left: 20.h, top: 20.v, right: 20.h),
                              controller: logic.fullNameController,
                              labelText: "lbl_full_name".tr,
                              labelStyle: theme.textTheme.bodyLarge!,
                              hintText: "lbl_full_name".tr,
                              hintStyle: theme.textTheme.bodyLarge!,
                              validator: (value) {
                                if (value!.length < 3) {
                                  return "Please enter valid text";
                                }
                                return null;
                              }),
                          CustomFloatingTextField(
                              margin: EdgeInsets.only(
                                  left: 20.h, top: 24.v, right: 20.h),
                              controller: logic.phoneNumberController,
                              labelText: "lbl_phone_number".tr,
                              labelStyle: theme.textTheme.bodyLarge!,
                              hintText: "lbl_phone_number".tr,
                              hintStyle: theme.textTheme.bodyLarge!,
                              // textInputType: TextInputType.phone,
                              textInputType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10)
                              ],
                              validator: (value) {
                                if (value!.length != 10) {
                                  return "Please enter valid phone number";
                                }
                                return null;
                              }),
                          CustomFloatingTextField(
                              margin: EdgeInsets.only(
                                  left: 20.h, top: 24.v, right: 20.h),
                              controller: logic.emailController,
                              labelText: "lbl_email_address".tr,
                              labelStyle: theme.textTheme.bodyLarge!,
                              hintText: "lbl_email_address".tr,
                              hintStyle: theme.textTheme.bodyLarge!,
                              textInputType: TextInputType.emailAddress,
                              validator: Platform.isAndroid
                                  ? (value) {
                                      if (value == null ||
                                          (!isValidEmail(value,
                                              isRequired: true))) {
                                        return "Please enter valid email";
                                      }
                                      return null;
                                    }
                                  : null),
                          CustomFloatingTextField(
                              onTap: () async {
                                var now = DateTime.now();
                                final datePick = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(
                                      now.year - 18, now.month, now.day),
                                  firstDate: new DateTime(1950),
                                  lastDate: DateTime(
                                      now.year - 18, now.month, now.day),
                                  builder:
                                      (BuildContext? context, Widget? child) {
                                    return Theme(
                                      data: ThemeData.dark().copyWith(
                                        colorScheme: ColorScheme.dark(
                                          primary: Constants.themeGradients[1],
                                          onPrimary: Colors.black87,
                                          surface: Constants.themeGradients[0],
                                          onSurface:
                                              Constants.themeGradients[1],
                                        ),
                                        dialogBackgroundColor:
                                            Constants.themeGradients[0],
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (datePick != null) {
                                  logic.onChangeDate(datePick);
                                }
                              },
                              readOnly: true,
                              margin: EdgeInsets.only(
                                  left: 20.h, top: 24.v, right: 20.h),
                              controller: logic.dobvalueController,
                              labelText: "lbl_dob".tr,
                              labelStyle: theme.textTheme.bodyMedium!,
                              hintText: "lbl_dob".tr,
                              hintStyle: theme.textTheme.bodyMedium!,
                              contentPadding:
                                  EdgeInsets.fromLTRB(16.h, 13.v, 16.h, 40.v)),
                          CustomFloatingDropDown(
                              title: 'Gender',
                              value: logic.selectedGender,
                              listValues: logic.genders,
                              onChanged: (value) {
                                FocusScope.of(context).unfocus();
                                logic.onChangeGender(value);
                              }),
                          CategoryPickerNew(
                              currentValue: logic.selectedCategory,
                              listValues: logic.categoryList,
                              // viewOnly: model.disableFields&&!model.enableMediaEdit,
                              onChanged: (val) {
                                logic.changeCategory(val);
                              },
                              labelText: "Category",
                              hintText: "Select Category"),
                          CustomFloatingTextField(
                            margin: EdgeInsets.only(
                                left: 20.h, top: 20.v, right: 20.h),
                            controller: logic.subcasteController,
                            labelText: "Sub Category",
                            labelStyle: theme.textTheme.bodyLarge!,
                            hintText: "Sub Category",
                            hintStyle: theme.textTheme.bodyLarge!,
                          ),
                          StateDropDrown(
                              title: 'Choose State',
                              value: logic.selectedState,
                              listValues: logic.stateList,
                              onChanged: (value) {
                                logic.onChangeState(value);
                              }),
                          DistrictDropDrown(
                              title: 'Choose District',
                              value: logic.selectedDistrict,
                              listValues: logic.districtList,
                              onChanged: (value) {
                                logic.onChangeDistrict(value);
                              }),
                          AssemblyDropDrown(
                              title: 'Choose Assembly ',
                              value: logic.selectedAssembly,
                              listValues: logic.assemblyList,
                              onChanged: (value) {
                                logic.onChangeAssembly(value);
                              }),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text('Affiliation',
                                style: theme.textTheme.bodyLarge),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              children: List.generate(
                                  logic.registrationFiled.length,
                                  (index) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Checkbox(
                                                activeColor: Colors.green,
                                                value: logic
                                                    .selectedRegistrationField
                                                    .contains(index),
                                                onChanged: (value) {
                                                  logic
                                                      .onClickRegistrationFiledCheckedBox(
                                                          index);
                                                }),
                                            SizedBox(
                                              width: 7,
                                            ),
                                            Expanded(
                                                child: Container(
                                                    child: Text(
                                                        '${logic.registrationFiled[index]}',
                                                        style: theme.textTheme
                                                            .bodyLarge)))
                                          ],
                                        ),
                                      )),
                            ),
                          ),
                          CustomFloatingTextField(
                              margin: EdgeInsets.only(
                                  left: 20.h, top: 24.v, right: 20.h),
                              controller: logic.referralNumberController,
                              labelText: "Referral Mobile Number",
                              labelStyle: theme.textTheme.bodyLarge!,
                              hintText: "Referral Mobile Number",
                              hintStyle: theme.textTheme.bodyLarge!,
                              textInputType: TextInputType.phone,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10)
                              ],
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (value.length != 10) {
                                    return "Enter valid referral mobile number";
                                  }
                                }
                                return null;
                              }),
                          CustomFloatingTextField(
                              margin: EdgeInsets.only(
                                  left: 20.h, top: 24.v, right: 20.h),
                              controller: logic.addressController,
                              labelText: "Address",
                              labelStyle: theme.textTheme.bodyLarge!,
                              hintText: "Address",
                              hintStyle: theme.textTheme.bodyLarge!,
                              textInputType: TextInputType.streetAddress,
                              validator: Platform.isAndroid
                                  ? (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter valid address";
                                      }
                                      return null;
                                    }
                                  : null),
                          CustomFloatingTextField(
                              margin: EdgeInsets.only(
                                  left: 20.h, top: 24.v, right: 20.h),
                              controller: logic.pincodeController,
                              labelText: "Pincode",
                              labelStyle: theme.textTheme.bodyLarge!,
                              hintText: "Pincode",
                              hintStyle: theme.textTheme.bodyLarge!,
                              textInputType: TextInputType.phone,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6)
                              ],
                              validator: (value) {
                                if (value!.length != 6) {
                                  return "Please enter valid pincode";
                                }
                                return null;
                              }),
                          CustomFloatingTextField(
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(15)
                              ],
                              margin: EdgeInsets.only(
                                  left: 20.h, top: 24.v, right: 20.h),
                              controller: logic.voterController,
                              labelText: "lbl_voter_id".tr,
                              labelStyle: CustomTextStyles.bodyLargeIndigo100,
                              hintText: "lbl_voter_id".tr,
                              textInputAction: TextInputAction.done),
                          CustomElevatedButton(
                              text: "lbl_register".tr.toUpperCase(),
                              margin: EdgeInsets.only(
                                  left: 20.h, top: 24.v, right: 20.h),
                              onTap: () {
                                logic.onTapRegister();
                              }),
                          SizedBox(height: 22.v),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: RoutesManagement.goToLoginScreen,
                                child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: "msg_already_have_an2".tr,
                                          style: CustomTextStyles
                                              .bodyLargeBluegray300),
                                      TextSpan(text: "  ".tr),
                                      TextSpan(
                                          text: "lbl_login".tr,
                                          style: CustomTextStyles
                                              .bodyLargePrimary_1)
                                    ]),
                                    textAlign: TextAlign.left),
                              ),
                            ],
                          ),
                          SizedBox(height: 32.v)
                        ])))),
          ));
    }));
  }
}
