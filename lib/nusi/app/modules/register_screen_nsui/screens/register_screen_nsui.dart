import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/validation_functions.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/custom_floating_drop_down_nsui.dart';
import 'package:iyc/app/widgets/custom_floating_text_field_nsui.dart';
import 'package:iyc/app/widgets/drop_down/state_picker_drop_down_nsui.dart';
import 'package:iyc/nusi/app/modules/register_screen_nsui/screens/register_controller_nsui.dart';
// ignore: unused_import
import 'package:iyc/nusi/app/modules/splash/screens/splash_controller_nsui.dart';
import 'package:iyc/nusi/widgets/upload_button_nsui.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/app/widgets/upload_button/upload_image_button.dart'
    as upload;

class RegisterScreenNSUI extends GetWidget<RegisterNSUIController> {
  const RegisterScreenNSUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return GetBuilder<RegisterNSUIController>(builder: (controller) {
      return SafeArea(
          child: Scaffold(
        // resizeToAvoidBottomInset: true,
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Color(0xFF4193D0),
                  Color(0xFF3367B1),
                ])),
            // padding: EdgeInsets.only(bottom: 235.v),
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: mediaQueryData.size.width * 0.9,
                        // height: mediaQueryData.size.height * 0.23,
                        padding: EdgeInsets.all(mediaQueryData.size.width * 0.05),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: [
                                Text(
                                  'Sign Up',
                                  style: theme.textTheme.titleLarge!.copyWith(
                                      // color: Colors.white,
                                      fontSize:
                                          mediaQueryData.size.height * 0.03),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Create an account to continue!',
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                      color: Colors.lightBlue,
                                      fontSize:
                                          mediaQueryData.size.height * 0.015),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                
                                CustomFloatingTextFieldNSUI(
                                    // margin: EdgeInsets.only(
                                    //     left: 20.h, top: 20.v, right: 20.h),
                                    controller: controller.fullNameController,
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
                                CustomFloatingTextFieldNSUI(
                                    // margin: EdgeInsets.only(
                                    //     left: 20.h, top: 24.v, right: 20.h),
                                    controller: controller.phoneNumberController,
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
                                CustomFloatingTextFieldNSUI(
                                    // margin: EdgeInsets.only(
                                    //     left: 20.h, top: 24.v, right: 20.h),
                                    controller: controller.emailController,
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
                                CustomFloatingDropDownNSUI(
                                  defaultMargin: false,
                                  title: 'Gender',
                                  value: controller.selectedGender,
                                  listValues: controller.genders,
                                  onChanged: (value) {
                                    FocusScope.of(context).unfocus();
                                    controller.onChangeGender(value);
                                  },
                                  labelText: 'Gender',
                                ),
                                CustomFloatingTextFieldNSUI(
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
                                              primary:
                                                  Constants.themeGradients[1],
                                              onPrimary: Colors.black87,
                                              surface:
                                                  Constants.themeGradients[0],
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
                                      controller.onChangeDate(datePick);
                                    }
                                  },
                                  readOnly: true,
                                  // margin: EdgeInsets.only(
                                  //     left: 20.h, top: 24.v, right: 20.h),
                                  controller: controller.dobvalueController,
                                  labelText: "lbl_dob".tr,
                                  labelStyle: theme.textTheme.bodyMedium!,
                                  hintText: " " + "lbl_dob".tr,
                                  hintStyle: theme.textTheme.bodyLarge!,
                                  // contentPadding: EdgeInsets.fromLTRB(
                                  //     16.h, 13.v, 16.h, 40.v)
                                ),
                                // CategoryPickerNew(
                                //     currentValue: controller.selectedCategory,
                                //     listValues: controller.categoryList,
                                //     // viewOnly: model.disableFields&&!model.enableMediaEdit,
                                //     onChanged: (val) {
                                //       controller.changeCategory(val);
                                //     },
                                //     labelText: "Category",
                                //     hintText: "Select Category"),
                                // CustomFloatingTextFieldNSUI(
                                //   margin: EdgeInsets.only(
                                //       left: 20.h, top: 20.v, right: 20.h),
                                //   controller: controller.subcasteController,
                                //   labelText: "Sub Category",
                                //   labelStyle: theme.textTheme.bodyLarge!,
                                //   hintText: "Sub Category",
                                //   hintStyle: theme.textTheme.bodyLarge!,
                                // ),
                                StateDropDrownNSUI(
                                  title: '  Choose State',
                                  value: controller.selectedState,
                                  listValues: controller.stateList,
                                  onChanged: (value) {
                                    controller.onChangeState(value);
                                  },
                                  lable: 'State',
                                ),
                                UploadButtonImageNSUI(
                                  onTap: (str) {
                                    controller.pickDocument(
                                        str,
                                        controller.pickedAMFilePath,
                                        upload.DocumentType.amImage,
                                        context);
                                  },
                                  showImage: controller.pickedAMFilePath != null,
                                  pickedFile: controller.pickedAMFile,
                                  buttonTextLabel: "Upload Photo",
                                  labelText: 'Upload Selfie',
                                ),
                                // DistrictDropDrown(
                                //     title: 'Choose District',
                                //     value: controller.selectedDistrict,
                                //     listValues: controller.districtList,
                                //     onChanged: (value) {
                                //       controller.onChangeDistrict(value);
                                //     }),
                                // AssemblyDropDrown(
                                //     title: 'Choose Assembly ',
                                //     value: controller.selectedAssembly,
                                //     listValues: controller.assemblyList,
                                //     onChanged: (value) {
                                //       controller.onChangeAssembly(value);
                                //     }),
                                // CustomFloatingTextFieldNSUI(
                                //     margin: EdgeInsets.only(
                                //         left: 20.h, top: 24.v, right: 20.h),
                                //     controller:
                                //         controller.referralNumberController,
                                //     labelText: "Referral Mobile Number",
                                //     labelStyle: theme.textTheme.bodyLarge!,
                                //     hintText: "Referral Mobile Number",
                                //     hintStyle: theme.textTheme.bodyLarge!,
                                //     textInputType: TextInputType.phone,
                                //     inputFormatters: [
                                //       LengthLimitingTextInputFormatter(10)
                                //     ],
                                //     validator: (value) {
                                //       if (value!.isNotEmpty) {
                                //         if (value.length != 10) {
                                //           return "Enter valid referral mobile number";
                                //         }
                                //       }
                                //       return null;
                                //     }),
                                // CustomFloatingTextFieldNSUI(
                                //     margin: EdgeInsets.only(
                                //         left: 20.h, top: 24.v, right: 20.h),
                                //     controller: controller.addressController,
                                //     labelText: "Address",
                                //     labelStyle: theme.textTheme.bodyLarge!,
                                //     hintText: "Address",
                                //     hintStyle: theme.textTheme.bodyLarge!,
                                //     textInputType: TextInputType.streetAddress,
                                //     validator: Platform.isAndroid
                                //         ? (value) {
                                //             if (value!.isEmpty) {
                                //               return "Please enter valid address";
                                //             }
                                //             return null;
                                //           }
                                //         : null),
                                // CustomFloatingTextFieldNSUI(
                                //     margin: EdgeInsets.only(
                                //         left: 20.h, top: 24.v, right: 20.h),
                                //     controller: controller.pincodeController,
                                //     labelText: "Pincode",
                                //     labelStyle: theme.textTheme.bodyLarge!,
                                //     hintText: "Pincode",
                                //     hintStyle: theme.textTheme.bodyLarge!,
                                //     textInputType: TextInputType.phone,
                                //     inputFormatters: [
                                //       LengthLimitingTextInputFormatter(6)
                                //     ],
                                //     validator: (value) {
                                //       if (value!.length != 6) {
                                //         return "Please enter valid pincode";
                                //       }
                                //       return null;
                                //     }),
                                SizedBox(
                                  height: mediaQueryData.size.height * 0.03,
                                ),
                                SizedBox(
                                    width: mediaQueryData.size.width,
                                    height: mediaQueryData.size.height * 0.05,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF1D61E7),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        onPressed: () {
                                          controller.onTapRegister();
                                        },
                                        child: Text(
                                          "Register",
                                          style: theme.textTheme.bodyLarge!
                                              .copyWith(color: Colors.white),
                                        ))),
                                SizedBox(
                                  height: mediaQueryData.size.height * 0.05,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      RoutesManagement.goToLoginscreenNSUI();
                                    },
                                    child: RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: "Already have an account?",
                                              style: theme.textTheme.bodyMedium!
                                                  .copyWith(color: Colors.black)),
                                          TextSpan(text: "  ".tr),
                                          TextSpan(
                                              text: "Login",
                                              style: theme.textTheme.bodyMedium!
                                                  .copyWith(color: Colors.orange))
                                        ]),
                                        textAlign: TextAlign.left)),
                              ],
                            ),
                            SizedBox(
                              height: mediaQueryData.size.height * 0.1,
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )),
      ));
    });
  }
}
