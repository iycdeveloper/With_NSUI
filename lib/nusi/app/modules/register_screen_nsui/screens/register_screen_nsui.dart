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
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Color(0xFF1356BF),
                  Color(0xFF5B2EC4),
                  Color(0xFF2CC7E2),
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
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 24,
                                  offset: const Offset(0, 12))
                            ]),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: [
                                Container(
                                  height: 76,
                                  width: 76,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFEAF1FC),
                                        Color(0xFFF3ECFF)
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                          color: const Color(0xFF1356BF)
                                              .withOpacity(0.18),
                                          blurRadius: 16,
                                          offset: const Offset(0, 6))
                                    ],
                                  ),
                                  child: Image.asset(
                                      'assets/nsui/applogo/playstore.png'),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      color: Color(0xFF1F2A44),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  'Join the movement — create your account 🚀',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 13),
                                ),
                                const SizedBox(
                                  height: 24,
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

                                    /// Registration DOB is open — anything
                                    /// from 60 years ago up to today. (It used
                                    /// to force a minimum age of 18 by capping
                                    /// lastDate at now - 18 years.)
                                    final datePick = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime(
                                          now.year - 18, now.month, now.day),
                                      firstDate: DateTime(
                                          now.year - 60, now.month, now.day),
                                      lastDate: now,
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
                                  onChanged: (value) =>
                                      controller.onChangeState(value),
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
                                GestureDetector(
                                  onTap: () {
                                    controller.onTapRegister();
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 54,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF1356BF),
                                          Color(0xFF2CC7E2)
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                            color: const Color(0xFF1356BF)
                                                .withOpacity(0.35),
                                            blurRadius: 16,
                                            offset: const Offset(0, 8))
                                      ],
                                    ),
                                    child: const Text(
                                      "Register",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
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
