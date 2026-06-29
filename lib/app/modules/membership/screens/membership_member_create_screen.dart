import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/app/modules/membership/controllers/membership_member_create_controller.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/app/widgets/custom_floating_drop_down.dart';
import 'package:iyc/app/widgets/custom_floating_drop_down_nsui.dart';
import 'package:iyc/app/widgets/custom_floating_text_field.dart';
import 'package:iyc/app/widgets/drop_down/state_picker_drop_down_nsui.dart';
import 'package:iyc/app/widgets/upload_button/upload_image_button.dart'
    as upload;
import 'package:iyc/nusi/widgets/date_picker_widget_nsui.dart';
import 'package:iyc/nusi/widgets/dropdown_picker_nsui.dart';
import 'package:iyc/nusi/widgets/textfeild_with_label_nsui.dart';
import 'package:iyc/nusi/widgets/upload_button_nsui.dart';
import 'package:iyc/screens/ui/membership/widgets/state_candidate_dropdown.dart';
import 'package:iyc/screens/widgets/u_round_button.dart';
import 'package:iyc/utils/constants.dart';
import 'package:pinput/pinput.dart';

class MembershipMemberCreateScreen extends StatelessWidget {
  const MembershipMemberCreateScreen();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<MembershipMemberCreateController>(
        builder: (logic) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFF),
            appBar: CustomAppBar(
              leadingWidth: 44.h,
              leading: AppbarImage(
                onTap: () => Get.back(),
                svgPath: ImageConstant.imgBiarrowleftIndigo800,
                margin: EdgeInsets.only(left: 20.h, top: 15.v, bottom: 15.v),
              ),
              title: AppbarSubtitle1(
                text: "${logic.member.memberId}",
                margin: EdgeInsets.only(left: 12.h),
              ),
              styleType: Style.standard,
            ),
            bottomNavigationBar: _buildBottomNavBar(logic, context),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepper(logic),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Step ${logic.activeStep + 1} - ${logic.steps['${logic.activeStep + 1}']}',
                    style: const TextStyle(
                      color: Color(0xFF244974),
                      fontFamily: 'Be Vietnam Pro',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    pageSnapping: true,
                    controller: logic.pageController,
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (page) {
                      logic.pageNumberChange(page);
                    },
                    children: [
                      _basicDetails(logic, context),
                      _consistencyDetails(logic),
                      // _personalDetail(logic),
                      // _contactDetails(logic),
                      _identityDetails(logic, context),
                      _candidateDetails(logic)
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepper(MembershipMemberCreateController logic) {
    return Container(
      height: 76.v,
      width: double.infinity,
      color: const Color(0xFF244974),
      child: EasyStepper(
        activeStep: logic.activeStep,
        // lineLength: 40,
        // lineSpace: 0,
        // lineType: LineType.normal,
        // defaultLineColor: const Color(0xFFC0D5F3),
        // finishedLineColor: const Color(0xFFC0D5F3),
        activeStepTextColor: Colors.black87,
        finishedStepBackgroundColor: Colors.transparent,
        finishedStepTextColor: Colors.black87,
        internalPadding: 0,
        showLoadingAnimation: false,
        showStepBorder: false,
        stepShape: StepShape.rRectangle,
        stepBorderRadius: 15,
        padding: const EdgeInsetsDirectional.all(0),
        steps: List.generate(
          logic.steps.keys.length,
          (index) => EasyStep(
            customStep: Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: logic.activeStep >= index
                    ? Color(0xFFF28812)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1, color: const Color(0xFFC0D5F3)),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Color(0xFFC0D5F3),
                    fontFamily: 'Be Vietnam Pro',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
        ),
        // onStepReached: logic.updateStepperIndex,
      ),
    );
  }

  Widget _buildBottomNavBar(
      MembershipMemberCreateController logic, BuildContext context) {
    if (logic.activeStep == 0) {
      return Container(
        padding: EdgeInsets.only(
          left: 20.h,
          right: 20.h,
          bottom: 10.v,
          top: 10.v,
        ),
        decoration: AppDecoration.outlineBlue100011,
        child: CustomElevatedButton(
          
          buttonStyle: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Color(0xFF0297F3))),
          text: "NEXT",
          onTap: () => logic.next(context),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.only(
        left: 20.h,
        right: 20.h,
        bottom: 10.v,
        top: 10.v,
      ),
      decoration: AppDecoration.outlineBlue100011,
      child: Row(
        children: [
          InkWell(
            onTap: logic.previous,
            child: Container(
              width: 158,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFC0D5F3),
                  width: 1.0,
                ),
                color: Colors.white,
              ),
              child: Center(
                child: Text("Previous".toUpperCase()),
              ),
            ),
          ),
          const Spacer(),
          CustomElevatedButton(
            buttonStyle: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Color(0xFF0297F3))),
            width: 158,
            text: logic.activeStep == 3 ? "SUBMIT" : "NEXT",
            onTap: () => logic.activeStep == 3
                ? logic.onSubmit(Get.context!)
                : logic.next(context),
          ),
        ],
      ),
    );
  }

  Widget _basicDetails(
          MembershipMemberCreateController logic, BuildContext context) =>
      Form(
        key: logic.basicDetailFormKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              TextFieldWithLabelNSUI(
                readOnly: logic.isUpdate,
                labelcolor: theme.textTheme.bodyLarge!.color,
                label: "Full Name",
                hintText: "Full Name",
                // focusNode: model.usernameFocus,
                // nextFocus: model.lastNameFocus,

                // readOnly: model.disableFields,
                keyBoardType: TextInputType.name,
                controller: logic.usernameController,
                validation: (value) {
                  if (value.isEmpty) {
                    return 'Enter a Full Name';
                  }
                  return null;
                },
              ), //
              TextFieldWithLabelNSUI(
                readOnly: logic.isUpdate,

                labelcolor: theme.textTheme.bodyLarge!.color,

                label: "Father's Name",
                hintText: "Father's Name",
                // focusNode: model.usernameFocus,
                // nextFocus: model.lastNameFocus,

                // readOnly: model.disableFields,
                keyBoardType: TextInputType.name,
                controller: logic.fatherNameController,
                validation: (value) {
                  if (value.isEmpty) {
                    return "Enter a Father's Name";
                  }
                  return null;
                },
              ),
              Form(
                key: logic.mobileFormKey,
                child: TextFieldWithLabelNSUI(
                  readOnly: logic.isUpdate,

                  labelcolor: theme.textTheme.bodyLarge!.color,

                  label: "Mobile Number",
                  hintText: "Mobile Number",
                  maxLength: 10,

                  // focusNode: model.usernameFocus,
                  // nextFocus: model.lastNameFocus,

                  // readOnly: model.disableFields,
                  keyBoardType: TextInputType.name,
                  controller: logic.mobileController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validation: (value) {
                    if (value.isEmpty) {
                      return 'Enter a Mobile Number';
                    }
                    return null;
                  },
                ),
              ),
              if (!logic.isUpdate) ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 150,
                    height: 70,
                    child: URoundButton(
                        title: "Get OTP",
                        onTap: () async {
                          final isValid =
                              logic.mobileFormKey.currentState!.validate();
                          if (!isValid) {
                            return;
                          }
                          logic.mobileFormKey.currentState!.save();
                          logic.verificationCodeController.clear();
                          logic.getOtp(context);
                        }),
                  ),
                ),
              ],

              if (logic.otpSend && !logic.otpVerified)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Pinput(
                    length: 6,
                    focusNode: logic.otpCodeFocus,
                    controller: logic.verificationCodeController,
                    defaultPinTheme: defaultPinTheme(),
                    followingPinTheme: defaultPinTheme(),
                    submittedPinTheme: defaultPinTheme(),
                    pinAnimationType: PinAnimationType.fade,
                  ),
                ),
              TextFieldWithLabelNSUI(
                readOnly: logic.isUpdate,

                labelcolor: theme.textTheme.bodyLarge!.color,

                label: "Email",
                hintText: "Email",
                // focusNode: model.usernameFocus,
                // nextFocus: model.lastNameFocus,

                // readOnly: model.disableFields,
                keyBoardType: TextInputType.name,
                controller: logic.emailController,
                validation: (input) =>
                    input.isValidEmail() ? null : "Enter a Valid Email Address",
              ),
              DatePickerWidgetNSUI(
                  labelcolor: theme.textTheme.bodyLarge!.color,
                  labelText: 'Date of Birth',
                  selectedDate: logic.selectedDate,
                  onTap: () async {
                    if (logic.isUpdate) {
                      return;
                    }

                    FocusScope.of(context).unfocus();
                    print("-------");
                    print(await LocalStorageServices().getDobEndRange());
                    final datePick = await showDatePicker(
                      context: context,
                      initialDate: new DateTime.utc(
                        int.parse(
                            await LocalStorageServices().getDobEndRange()),
                      ),
                      firstDate: new DateTime(int.parse(
                        await LocalStorageServices().getDobStartRange(),
                      )),
                      lastDate: new DateTime(
                          int.parse(
                            await LocalStorageServices().getDobEndRange(),
                          ),
                          12,
                          31),
                      builder: (BuildContext? context, Widget? child) {
                        return Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: Constants.themeGradients[1],
                              onPrimary: Colors.black87,
                              surface: Constants.themeGradients[0],
                              onSurface: Constants.themeGradients[1],
                            ),
                            dialogBackgroundColor: Constants.themeGradients[0],
                          ),
                          child: child!,
                        );
                      },
                    );
                    //await datePicker(context);

                    if (datePick != null && datePick != logic.eventDate) {
                      logic.onChangeDate(datePick);
                    }
                  }),
              DropDownPickerNSUI(
                viewOnly: logic.isUpdate,

                labelcolor: theme.textTheme.bodyLarge!.color,

                currentValue: logic.selectedGender,
                listValues: logic.gender,
                // refKey: context
                //     .read<
                //         NominationsProvider>()
                //     .dropdownButtonKey,
                onChanged: (val) {
                  logic.onChangeGender(val);
                },
                labelText: "Gender",
                hintText: "Select a Gender",
              ),
              TextFieldWithLabelNSUI(
                readOnly: logic.isUpdate,
                labelcolor: theme.textTheme.bodyLarge!.color,

                label: "Course",
                hintText: "Course",
                // focusNode: model.usernameFocus,
                // nextFocus: model.lastNameFocus,

                // readOnly: model.disableFields,
                keyBoardType: TextInputType.name,
                controller: logic.courseController,
                validation: (value) {
                  if (value.isEmpty) {
                    return 'Enter a Course';
                  }
                  return null;
                },
              ),
              TextFieldWithLabelNSUI(
                readOnly: logic.isUpdate,
                labelcolor: theme.textTheme.bodyLarge!.color,
                label: "Permanent Address",
                hintText: "Permanent Address",
                // focusNode: model.usernameFocus,
                // nextFocus: model.lastNameFocus,

                // readOnly: model.disableFields,
                keyBoardType: TextInputType.name,
                controller: logic.addressController,
                validation: (value) {
                  if (value.isEmpty) {
                    return 'Enter a permanent ddress';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              )
              // CustomFloatingTextField(
              //   readOnly: logic.isUpdate,
              //   textInputType: TextInputType.text,
              //   controller: logic.usernameController,
              //   margin: const EdgeInsets.only(top: 10),
              //   labelText: 'First Name',
              //   labelStyle: theme.textTheme.bodyLarge!,
              //   hintText: 'Enter First name',
              //   hintStyle: theme.textTheme.bodyLarge!,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return "Please enter first name";
              //     }
              //     return null;
              //   },
              // ),
              // CustomFloatingTextField(
              //   readOnly: logic.isUpdate,
              //   textInputType: TextInputType.text,
              //   controller: logic.lastNameController,
              //   margin: const EdgeInsets.only(top: 10),
              //   labelText: 'Last Name',
              //   labelStyle: theme.textTheme.bodyLarge!,
              //   hintText: 'Enter Last name',
              //   hintStyle: theme.textTheme.bodyLarge!,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return "Please enter last name";
              //     }
              //     return null;
              //   },
              // ),
              // CustomFloatingTextField(
              //   readOnly: logic.isUpdate,
              //   textInputType: TextInputType.text,
              //   controller: logic.fatherNameController,
              //   margin: const EdgeInsets.only(top: 10),
              //   labelText: 'Father/Husband Name',
              //   labelStyle: theme.textTheme.bodyLarge!,
              //   hintText: 'Enter Father/Husband Name',
              //   hintStyle: theme.textTheme.bodyLarge!,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return "Please enter Father/Husband Name";
              //     }
              //     return null;
              //   },
              // ),
              // CustomFloatingTextField(
              //   readOnly: logic.isUpdate,
              //   textInputType: TextInputType.text,
              //   controller: logic.professionController,
              //   margin: const EdgeInsets.only(top: 10),
              //   labelText: 'Your Profession',
              //   labelStyle: theme.textTheme.bodyLarge!,
              //   hintText: 'Enter Your Profession',
              //   hintStyle: theme.textTheme.bodyLarge!,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return "Please enter your profession";
              //     }
              //     return null;
              //   },
              // ),
            ],
          ),
        ),
      );

  PinTheme defaultPinTheme() {
    return PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: const Color.fromRGBO(126, 203, 224, 1),
        ),
      ),
    );
  }

  Widget _personalDetail(MembershipMemberCreateController logic) => Form(
        key: logic.personalDetailFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              CustomFloatingDropDown(
                readOnly: logic.isUpdate,
                title: 'Gender',
                value: logic.selectedGender,
                listValues: logic.gender,
                onChanged: (value) {
                  logic.onChangeGender(value);
                },
                defaultMargin: false,
              ),
              SizedBox(
                height: 20,
              ),
              CustomFloatingDropDown(
                readOnly: logic.isUpdate,
                title: 'Education',
                value: logic.selectedEducation,
                listValues: logic.educationalDetailsList,
                onChanged: (value) {
                  logic.onChangeEducation(value);
                },
                defaultMargin: false,
              ),
              SizedBox(
                height: 20,
              ),
              CustomFloatingDropDown(
                readOnly: logic.isUpdate,
                title: 'Category',
                value: logic.selectedCategory,
                listValues: logic.category,
                onChanged: (value) {
                  logic.onChangeCategory(value);
                },
                defaultMargin: false,
              ),
              SizedBox(
                height: 20,
              ),
              CustomFloatingTextField(
                readOnly: true,
                textInputType: TextInputType.text,
                controller: logic.dobController,
                margin: const EdgeInsets.only(top: 10),
                labelText: 'DOB',
                labelStyle: theme.textTheme.bodyLarge!,
                hintText: 'Date of birth',
                hintStyle: theme.textTheme.bodyLarge!,
                onTap: () async {
                  if (logic.isUpdate) return;
                  final datePick = await showDatePicker(
                    context: Get.context!,
                    initialDate: new DateTime.utc(
                      int.parse(await LocalStorageServices().getDobEndRange()),
                    ),
                    firstDate: new DateTime(int.parse(
                      await LocalStorageServices().getDobStartRange(),
                    )),
                    lastDate: new DateTime(
                        int.parse(
                          await LocalStorageServices().getDobEndRange(),
                        ),
                        12,
                        31),
                    builder: (BuildContext? context, Widget? child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: ColorScheme.dark(
                            primary: Constants.themeGradients[1],
                            onPrimary: Colors.black87,
                            surface: Constants.themeGradients[0],
                            onSurface: Constants.themeGradients[1],
                          ),
                          dialogBackgroundColor: Constants.themeGradients[0],
                        ),
                        child: child!,
                      );
                    },
                  );
                  //await datePicker(context);
                  print(datePick);
                  if (datePick != null && datePick != logic.eventDate) {
                    logic.onChangeDate(datePick);
                  }
                },
              ),
            ],
          ),
        ),
      );

  Widget _contactDetails(MembershipMemberCreateController logic) => Form(
        key: logic.contactDetailFormKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              CustomFloatingTextField(
                readOnly: logic.isUpdate,
                textInputType: TextInputType.number,
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                controller: logic.mobileController,
                margin: const EdgeInsets.only(top: 10),
                labelText: 'Mobile Number',
                labelStyle: theme.textTheme.bodyLarge!,
                hintText: 'Enter Mobile Number',
                hintStyle: theme.textTheme.bodyLarge!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter mobile number";
                  }
                  return null;
                },
              ),
              CustomFloatingTextField(
                readOnly: logic.isUpdate,
                textInputType: TextInputType.emailAddress,
                controller: logic.emailController,
                margin: const EdgeInsets.only(top: 10),
                labelText: 'Email',
                labelStyle: theme.textTheme.bodyLarge!,
                hintText: 'Enter Email',
                hintStyle: theme.textTheme.bodyLarge!,
                validator: (value) => value!.isValidEmail()
                    ? null
                    : "Enter a Valid Email Address",
              ),
              CustomFloatingTextField(
                readOnly: logic.isUpdate,
                textInputType: TextInputType.text,
                controller: logic.addressController,
                margin: const EdgeInsets.only(top: 10),
                labelText: 'Address',
                labelStyle: theme.textTheme.bodyLarge!,
                hintText: 'Enter Address',
                hintStyle: theme.textTheme.bodyLarge!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter address";
                  }
                  return null;
                },
              ),
              CustomFloatingTextField(
                readOnly: logic.isUpdate,
                textInputType: TextInputType.number,
                inputFormatters: [LengthLimitingTextInputFormatter(6)],
                controller: logic.pinController,
                margin: const EdgeInsets.only(top: 10),
                labelText: 'Pincode',
                labelStyle: theme.textTheme.bodyLarge!,
                hintText: 'Enter Your Pincode',
                hintStyle: theme.textTheme.bodyLarge!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter pincode";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      );

  Widget _identityDetails(
          MembershipMemberCreateController logic, BuildContext context) =>
      SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // CustomFloatingDropDown(
            //   readOnly: true,
            //   title: 'ID Proof',
            //   value: logic.selectedIdProof,
            //   listValues: logic.idProofList,
            //   onChanged: (value) {
            //     logic.onChangeIdProof(value);
            //   },
            //   defaultMargin: false,
            // ),
            // CustomFloatingTextField(
            //   readOnly: logic.isUpdate,
            //   textInputType: TextInputType.text,
            //   inputFormatters: [LengthLimitingTextInputFormatter(15)],
            //   controller: logic.idController,
            //   margin: const EdgeInsets.only(top: 10),
            //   labelText: 'ID Document Number',
            //   labelStyle: theme.textTheme.bodyLarge!,
            //   hintText: 'Enter ID Document Number',
            //   hintStyle: theme.textTheme.bodyLarge!,
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return "Please enter ID document number";
            //     }
            //     return null;
            //   },
            // ),
            SizedBox(
              height: 10,
            ),
            UploadButtonImageNSUI(
            
              lablecolor: theme.textTheme.bodyLarge!.color,
              onlyCamera: true,
              // disableGallery: true,
              // defaultPadding: true,
              // readOnly: logic.isUpdate,
              onTap: (str) {
                logic.pickDocument(str, logic.pickedAMFilePath,
                    upload.DocumentType.amImage, context);
                // logic.clickLivePhotoNew(context);
              },
              showImage: logic.pickedAMFilePath != null,
              pickedFile: logic.pickedAMFile,
              buttonTextLabel:
                  logic.showAMImage ? "Change Photo" : "Upload Photo",
              labelText: 'Upload Photo',
            ),
            SizedBox(
              height: 10,
            ),
            UploadButtonImageNSUI(
              lablecolor: theme.textTheme.bodyLarge!.color,

              // readOnly: logic.isUpdate,
              // titleText: 'Document',
              // defaultPadding: true,
              onlyCamera: true,
              buttonTextLabel: "Upload Photo",
              onTap: (str) {
                logic.pickDocument(str, logic.pickedIdProofPath,
                    upload.DocumentType.idFront, Get.context!);
              },
              pickedFile: logic.pickedIdFile,
              showImage: logic.pickedIdProofPath != null,
              labelText: 'Upload College ID',
            ),
            SizedBox(
              height: 10,
            ),
            UploadButtonImageNSUI(
              lablecolor: theme.textTheme.bodyLarge!.color,
              // readOnly: logic.isUpdate,
              // titleText: 'Document',
              // defaultPadding: true,
              onlyCamera: true,
              buttonTextLabel: "Upload Photo",
              onTap: (str) {
                logic.pickDocument(str, logic.pickedDocumentBackFilePath,
                    upload.DocumentType.idBack, Get.context!);
              },
              pickedFile: logic.pickedDocumentBack,
              showImage: logic.pickedDocumentBackFilePath != null,
              labelText: 'Upload Government ID',
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      );

  Widget _consistencyDetails(MembershipMemberCreateController logic) =>
      SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            StateDropDrownNSUI(
              labelcolor: theme.textTheme.bodyLarge!.color,
              title: 'Select State',
              value: logic.selectedState,
              listValues: logic.stateList,
              margin: EdgeInsets.only(top: 10),
              onChanged: (value) {},
              lable: 'State',
            ),
            // StateDropDrown(
            //     title: 'State',
            //     value: logic.selectedState,
            //     listValues: logic.stateList,
            //     margin: EdgeInsets.only(top: 10),
            //     onChanged: (value) {}),
            // SizedBox(
            //   height: 10,
            // ),
            CustomFloatingDropDownNSUI(
              labelcolor: theme.textTheme.bodyLarge!.color,
              readOnly: logic.isUpdate,
              title: 'Select District',
              value: logic.selectedDistrict,
              listValues: logic.districtDropdownItems,
              onChanged: (value) {
                logic.onChangedDistrict(value);
              },
              defaultMargin: false,
              labelText: 'District',
            ),
            // CustomFloatingDropDownNSUI(
            //   labelcolor: theme.textTheme.bodyLarge!.color,
            //   readOnly: logic.isUpdate,
            //   title: 'Select University',
            //   value: logic.selectedAssembly,
            //   listValues: logic.assemblyDropdownItems,
            //   onChanged: (value) {
            //     logic.onChangedAssembly(value);
            //   },
            //   defaultMargin: false,
            //   labelText: 'University',
            // ),
            // CustomFloatingDropDownNSUI(
            //   labelcolor: theme.textTheme.bodyLarge!.color,
            //   readOnly: logic.isUpdate,
            //   title: 'Select a College',
            //   value: logic.selectedBooth,
            //   listValues: logic.boothDropdownItems,
            //   onChanged: (value) {
            //     logic.onChangedBooth(value);
            //   },
            //   defaultMargin: false,
            //   labelText: 'College',
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            // CustomFloatingDropDown(
            //   readOnly: logic.isUpdate,
            //   title: 'Select Assembly/Zone',
            //   value: logic.selectedAssembly,
            //   listValues: logic.assemblyDropdownItems,
            //   onChanged: (value) {
            //     logic.onChangedAssembly(value);
            //   },
            //   defaultMargin: false,
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            // if (["LA"].contains(logic.userState))
            //   CustomFloatingDropDown(
            //     readOnly: logic.isUpdate,
            //     title: 'Select a Mandalam/Block',
            //     value: logic.selectedMandalam,
            //     listValues: logic.mandalamDropdownItems,
            //     onChanged: (value) {
            //       logic.onChangedMandalam(value);
            //     },
            //     defaultMargin: false,
            //   ),
            // SizedBox(
            //   height: 10,
            // ),
            // CustomFloatingDropDown(
            //   readOnly: logic.isUpdate,
            //   title: 'Select a Booth',
            //   value: logic.selectedBooth,
            //   listValues: logic.boothDropdownItems,
            //   onChanged: (value) {
            //     logic.onChangedBooth(value);
            //   },
            //   defaultMargin: false,
            // ),
          ],
        ),
      );

  Widget _candidateDetails(MembershipMemberCreateController logic) =>
      SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // Container(
            //   padding: EdgeInsets.only(left: 20, top: 10),
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     "Candidate section",
            //     style: GoogleFonts.poppins(
            //       textStyle: TextStyle(color: Colors.black, fontSize: 14),
            //     ),
            //   ),
            // ),
            StateNominationPickerWidget(
              lablecolor: theme.textTheme.bodyLarge!.color,
              onChanged: (val) {
                logic.changeStateNomination(val);
              },
              listValues: logic.statePresidentNominationsList,
              labelText: "State President Candidate",
              currentValue: logic.selectedStatePresidentNominations,
              defaultValue: "Select State President Nomination",
            ),
            StateNominationPickerWidget(
                            lablecolor: theme.textTheme.bodyLarge!.color,

              onChanged: (val) {
                logic.changeStateGSNomination(val);
              },
              listValues: logic.stateGeneralSecretaryNominationsList,
              labelText: "State General Secretary Candidate",
              currentValue: logic.selectedStateGSNominations,
              defaultValue: "Select State General Secretary Nomination",
            ),
            StateNominationPickerWidget(
              lablecolor: theme.textTheme.bodyLarge!.color,
              onChanged: (val) {
                logic.changeDistrictNomination(val);
              },
              listValues: logic.districtNominationsList,
              labelText: "District President Candidate",
              currentValue: logic.selectedDistrictNominations,
              defaultValue: "Select District President Nomination",
            ),
            // StateNominationPickerWidget(
            //   lablecolor: theme.textTheme.bodyLarge!.color,
            //   onChanged: (val) {
            //     logic.changeAssemblyNomination(val);
            //   },
            //   listValues: logic.assemblyNominationsList,
            //   labelText: "University President",
            //   currentValue: logic.selectedAssemblyNominations,
            //   defaultValue: "University President",
            // ),
            // StateNominationPickerWidget(
            //   lablecolor: theme.textTheme.bodyLarge!.color,
            //   onChanged: (val) {
            //     logic.changeDistrictNomination(val);
            //   },
            //   listValues: logic.districtNominationsList,
            //   labelText: "University/College President",
            //   currentValue: logic.selectedDistrictNominations,
            //   defaultValue: "University/College President",
            // ),
            // StateNominationPickerWidget(
            //   onChanged: (val) {
            //     logic.changeDistrictGsNomination(val);
            //   },
            //   listValues: logic.districtGsNominationsList,
            //   labelText: "District GS Candidate",
            //   currentValue: logic.selectedDistrictGsNominations,
            //   defaultValue: "Select District GS Nomination",
            // ),
            // AppConstants.blockStatesList
            //         .contains(logic.selectedState?.stateCode)
            //     ? Column(
            //         children: [
            //           StateNominationPickerWidget(
            //             onChanged: (val) {
            //               logic.changeBlockNomination(val);
            //             },
            //             listValues: logic.blockNominationsList,
            //             labelText: "Block Candidate",
            //             currentValue: logic.selectedBlockNominations,
            //             defaultValue: "Select Block Nomination",
            //           ),
            // StateNominationPickerWidget(
            //   lablecolor: theme.textTheme.bodyLarge!.color,
            //   onChanged: (val) {
            //     logic.changeBoothNomination(val);
            //   },
            //   listValues: logic.boothNominationsList,
            //   labelText: "College President",
            //   currentValue: logic.selectedBoothNominations,
            //   defaultValue: "College President",
            // ),
            //         ],
            //       )
            //     : StateNominationPickerWidget(
            //         onChanged: (val) {
            //           logic.changeAssemblyNomination(val);
            //         },
            //         listValues: logic.assemblyNominationsList,
            //         labelText: "Assembly/Zone/Ward Candidate",
            //         currentValue: logic.selectedAssemblyNominations,
            //         defaultValue: "Select Assembly/Zone/Ward Nomination",
            //       ),
            // if (["KL", "TL", "KA", "DL", "HP", "LA"]
            //     .contains(logic.selectedState?.stateCode))
            //   StateNominationPickerWidget(
            //     onChanged: (val) {
            //       logic.changeMandalamNomination(val);
            //     },
            //     listValues: logic.mandalamNominationsList,
            //     labelText: "Mandalam/Block Candidate",
            //     currentValue: logic.selectedMandalamNominations,
            //     defaultValue: "Select Mandalam/Block Nomination",
            //   ),
            SizedBox(
              height: 10,
            ),
            Container(
                // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  // Text(
                  //   'Declaration',
                  //   style: TextStyle(
                  //       color: Colors.grey.shade600, fontSize: 14),
                  // ),
                  Row(
                    children: [
                      Checkbox(
                        value: logic.declarationStatus,
                        activeColor: Colors.orange,
                        onChanged: (value) {
                          logic.changeDeclarationStatus(value!);
                        },
                      ),
                      Container(
                        width: MediaQuery.of(Get.context!).size.width * 0.8,
                        child: Text(
                          'I’m under 27 years of age and I accept the terms and conditions of NSUI',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 14),
                        ),
                      ),
                    ],
                  )
                ])),
          ],
        ),
      );
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
